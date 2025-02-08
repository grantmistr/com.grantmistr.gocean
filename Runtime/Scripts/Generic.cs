using System;
using System.Linq;
using System.Threading.Tasks;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;
    using static Helper;

    public class Generic : Component
    {
        [ShaderParam("_RandomNoiseTextureResolution")]
        public const int RANDOM_NOISE_TEXTURE_RESOLUTION = 256;

        public bool waterWritesToDepth;

        public DiffusionProfileSettings diffusionProfile;
        private Vector4 diffusionProfileVec4GUI;
        private float diffusionProfileHash;

        [ShaderParam("_RandomSeed")]
        public int randomSeed;
        private bool newSeed = true;
        
        [ShaderParam("_WaterHeight")]
        public float waterHeight;
        [ShaderParamGlobal("_RandomNoiseTexture")]
        public RenderTexture randomNoiseTexture;
        [ShaderParamGlobal("_WaterDepthTexture")]
        public RTHandle waterDepthTexture;
        [ShaderParamGlobal("_TemporaryColorTexture")]
        public RTHandle temporaryColorTexture;
        [ShaderParamGlobal("_TemporaryDepthTexture")]
        public RTHandle temporaryDepthTexture;
        [ShaderParamGlobal("_TemporaryBlurTexture")]
        public RTHandle temporaryBlurTexture;

        private RenderParams oceanRenderParams, distantOceanRenderParams;
        private int shaderPassForwardOcean, shaderPassForwardDistantOcean, shaderPassTransferFinal, shaderPassTransferFinalWriteDepth;

        public Generic()
        {
        }

        public override void Initialize()
        {
            InitializeParams(ocean.parametersUser.generic);

            AddDiffusionProfileToList(diffusionProfile);
            FindShaderPasses();
            InitializeTextures();
            SetMaterialKeywords();
            CreateRenderParams();
        }

        public override void ReleaseResources()
        {
            ReleaseTexture(ref randomNoiseTexture);
            ReleaseTexture(ref waterDepthTexture);
            ReleaseTexture(ref temporaryColorTexture);
            ReleaseTexture(ref temporaryDepthTexture);
            ReleaseTexture(ref temporaryBlurTexture);
        }

        public override void InitializeParams(BaseParamsUser userParams)
        {
            GenericParamsUser u = userParams as GenericParamsUser;

            waterWritesToDepth = u.waterWritesToDepth;
            waterHeight = u.waterHeight;
            diffusionProfile = u.diffusionProfile;
            randomSeed = UpdateRandomSeed(u.randomSeed);
        }

        public override void SetShaderParams()
        {
            HDMaterial.SetDiffusionProfileShaderGraph(ocean.OceanM, diffusionProfile, "_DiffusionProfile");
            HDMaterial.SetDiffusionProfileShaderGraph(ocean.DistantOceanM, diffusionProfile, "_DiffusionProfile");

            base.SetShaderParams();
        }

        private void UpdateDiffusionProfileData(string diffusionProfileGUI)
        {
            if (string.IsNullOrEmpty(diffusionProfileGUI))
            {
                diffusionProfileVec4GUI = Vector4.zero;
                diffusionProfileHash = 0f;

                Debug.Log("Diffusion Profile 0");

                return;
            }

            diffusionProfileVec4GUI = DiffusionProfileHelper.ConvertGUIDToVector4(diffusionProfileGUI);
            diffusionProfileHash = math.asfloat(DiffusionProfileHelper.GetDiffusionProfileHash(diffusionProfileGUI));
        }

        private async void AddDiffusionProfileToList(DiffusionProfileSettings diffusionProfile)
        {
            if (!await WaitForVolumeManagerInstanceInitialization(VolumeManager.instance))
            {
                Debug.Log("Volume manager instance did not initialize in ~999 frames.");
                return;
            }

            if (VolumeManager.instance.globalDefaultProfile == null)
            {
                Debug.Log("Could not get global default volume profile.");
                return;
            }

            if (!VolumeManager.instance.globalDefaultProfile.TryGet<DiffusionProfileList>(out DiffusionProfileList diffusionProfileList))
            {
                Debug.Log("Could not get diffusion profile list on global default volume profile, creating one.");
                diffusionProfileList = VolumeManager.instance.globalDefaultProfile.Add<DiffusionProfileList>();
            }

            if (!diffusionProfileList.diffusionProfiles.value.Contains(diffusionProfile))
            {
                DiffusionProfileSettings[] newSettings = new DiffusionProfileSettings[diffusionProfileList.diffusionProfiles.value.Length + 1];
                for (int i = 0; i < diffusionProfileList.diffusionProfiles.value.Length; i++)
                {
                    newSettings[i] = diffusionProfileList.diffusionProfiles.value[i];
                }
                newSettings[newSettings.Length - 1] = diffusionProfile;

                diffusionProfileList.diffusionProfiles.value = newSettings;

                // it took literal days to figure out I needed to call this function. about had an aneurysm
                VolumeManager.instance.OnVolumeComponentChanged(diffusionProfileList);
            }
        }

        private async Task<bool> WaitForVolumeManagerInstanceInitialization(VolumeManager instance)
        {
            int i = 0;
            while (!instance.isInitialized)
            {
                i++;
                if (i > 999)
                {
                    return false;
                }

                int delay = Mathf.RoundToInt(Time.deltaTime * 1000f);
                delay = delay == 0 ? 100 : delay;
                await Task.Delay(delay);
            }

            return true;
        }

        private void SetMaterialKeywords()
        {
            SetKeyword(ocean.FullscreenM, PropIDs.ShaderKeywords.WATER_WRITES_TO_DEPTH, waterWritesToDepth);
        }

        private int UpdateRandomSeed(int userRandomSeed)
        {
            if (this.randomSeed != userRandomSeed)
            {
                newSeed = true;
            }

            return userRandomSeed;
        }

        private void CreateRenderParams()
        {
            oceanRenderParams = new RenderParams(ocean.OceanM);
            oceanRenderParams.shadowCastingMode = ShadowCastingMode.Off;
            oceanRenderParams.receiveShadows = false;
            oceanRenderParams.worldBounds = MAX_BOUNDS;

            distantOceanRenderParams = new RenderParams(ocean.DistantOceanM);
            distantOceanRenderParams.shadowCastingMode = ShadowCastingMode.Off;
            distantOceanRenderParams.receiveShadows = false;
            distantOceanRenderParams.worldBounds = MAX_BOUNDS;
        }

        private void FindShaderPasses()
        {
            shaderPassForwardOcean = ocean.OceanM.FindPass("Forward");
            shaderPassForwardDistantOcean = ocean.DistantOceanM.FindPass("Forward");
            shaderPassTransferFinal = ocean.FullscreenM.FindPass("TransferFinal");
            shaderPassTransferFinalWriteDepth = ocean.FullscreenM.FindPass("TransferFinalWriteDepth");
        }

        private void InitializeTextures()
        {
            InitializeRandomNoiseTexture();
            InitializeRTHandles();
        }

        private void InitializeRTHandles()
        {
            if (waterDepthTexture == null)
            {
                waterDepthTexture = rtHandleSystem.Alloc(
                    Vector2.one,
                    1,
                    DepthBits.Depth32,
                    GraphicsFormat.None,
                    FilterMode.Point,
                    TextureWrapMode.Clamp,
                    TextureDimension.Tex2D,
                    name: "WaterDepthTexture"
                );
            }

            if (temporaryDepthTexture == null)
            {
                temporaryDepthTexture = rtHandleSystem.Alloc(
                    Vector2.one,
                    1,
                    DepthBits.Depth32,
                    GraphicsFormat.None,
                    FilterMode.Point,
                    TextureWrapMode.Clamp,
                    TextureDimension.Tex2D,
                    name: "TemporaryDepthTexture"
                );
            }

            RenderPipelineSettings currentSettings = (GraphicsSettings.currentRenderPipeline as HDRenderPipelineAsset).currentPlatformRenderPipelineSettings;
            GraphicsFormat graphicsFormat = (GraphicsFormat)currentSettings.colorBufferFormat;

            if (temporaryColorTexture == null)
            {
                temporaryColorTexture = rtHandleSystem.Alloc(
                    Vector2.one,
                    1,
                    DepthBits.None,
                    graphicsFormat,
                    FilterMode.Bilinear,
                    TextureWrapMode.Clamp,
                    TextureDimension.Tex2D,
                    name: "TemporaryColorTexture"
                );
            }
            else if (temporaryColorTexture.rt.graphicsFormat != graphicsFormat)
            {
                temporaryColorTexture.Release();
                temporaryColorTexture = rtHandleSystem.Alloc(
                    Vector2.one,
                    1,
                    DepthBits.None,
                    graphicsFormat,
                    FilterMode.Bilinear,
                    TextureWrapMode.Clamp,
                    TextureDimension.Tex2D,
                    name: "TemporaryColorTexture"
                );
            }

            if (temporaryBlurTexture == null)
            {
                temporaryBlurTexture = rtHandleSystem.Alloc(
                    Vector2.one,
                    1,
                    DepthBits.None,
                    GraphicsFormat.R16G16_SFloat,
                    FilterMode.Point,
                    TextureWrapMode.Clamp,
                    TextureDimension.Tex2D,
                    true,
                    name: "TemporaryBlurTexture"
                );
            }
        }

        private void InitializeRandomNoiseTexture()
        {
            RenderTexture rt = randomNoiseTexture;
            int resolution = RANDOM_NOISE_TEXTURE_RESOLUTION;
            bool update = false;

            if (rt == null)
            {
                Create();
            }
            else if (rt.width != resolution || rt.height != resolution)
            {
                rt.Release();
                Create();
            }
            else if (!rt.IsCreated())
            {
                rt.Create();
                update = true;
            }

            randomNoiseTexture = rt;

            if (update || newSeed)
            {
                GenerateRandomNoise();
                newSeed = false;
            }

            void Create()
            {
                rt = new RenderTexture(resolution, resolution, 0, GraphicsFormat.R8G8B8A8_UNorm);
                rt.name = "RandomNoiseTexture";
                rt.filterMode = FilterMode.Point;
                rt.wrapMode = TextureWrapMode.Repeat;
                rt.dimension = TextureDimension.Tex2D;
                rt.memorylessMode = RenderTextureMemoryless.Depth | RenderTextureMemoryless.MSAA;
                rt.enableRandomWrite = true;
                rt.useMipMap = false;
                rt.autoGenerateMips = false;
                rt.Create();

                update = true;
            }
        }

        public void GenerateRandomNoise()
        {
            ComputeShader helperCS = Resources.Load<ComputeShader>("Shaders/ComputeShaders/GOceanHelper");

            int kernel = helperCS.FindKernel("GenerateRandomNoise");

            Vector3Int threadGroups = Vector3Int.one;
            helperCS.GetKernelThreadGroupSizes(kernel, out uint x, out uint y, out uint z);
            threadGroups.x = Mathf.CeilToInt(RANDOM_NOISE_TEXTURE_RESOLUTION / (float)x);
            threadGroups.y = Mathf.CeilToInt(RANDOM_NOISE_TEXTURE_RESOLUTION / (float)y);

            helperCS.SetTexture(kernel, PropIDs.randomNoiseTexture, randomNoiseTexture);
            helperCS.SetInt(PropIDs.randomNoiseTextureResolution, RANDOM_NOISE_TEXTURE_RESOLUTION);
            helperCS.SetInt(PropIDs.randomSeed, randomSeed);
            helperCS.Dispatch(kernel, threadGroups);
        }

        public void SetRTHandleSystemReferenceSize(CustomPassContext ctx)
        {
            rtHandleSystem.SetReferenceSize(ctx.hdCamera.actualWidth, ctx.hdCamera.actualHeight);
        }

        public void DrawWaterForward()
        {
            Graphics.RenderPrimitives(distantOceanRenderParams, MeshTopology.Triangles, 3, 1);

            if (components.Mesh.DrawMesh)
            {
                Graphics.RenderPrimitivesIndirect(oceanRenderParams, MeshTopology.Triangles, components.Mesh.indirectArgsBuffer, 1, (int)Mesh.IndirectStartCommand.VERTEX_COUNT);
            }
        }
            
        public void DrawWaterForward(CustomPassContext ctx)
        {
            //CoreUtils.SetRenderTarget(ctx.cmd, ctx.cameraColorBuffer, waterDepthTexture, ClearFlag.None);
            CoreUtils.DrawFullScreen(ctx.cmd, ocean.DistantOceanM, null, shaderPassForwardDistantOcean);

            if (components.Mesh.DrawMesh)
            {
                ctx.cmd.DrawProceduralIndirect(Matrix4x4.identity, ocean.OceanM, shaderPassForwardOcean, MeshTopology.Triangles, components.Mesh.indirectArgsBuffer, (int)Mesh.IndirectStartCommand.VERTEX_COUNT);
            }
        }

        public void TransferFinal(CustomPassContext ctx)
        {
            if (waterWritesToDepth)
            {
                CoreUtils.SetRenderTarget(ctx.cmd, ctx.cameraColorBuffer, ctx.cameraDepthBuffer);
                CoreUtils.DrawFullScreen(ctx.cmd, ocean.FullscreenM, ctx.propertyBlock, shaderPassTransferFinalWriteDepth);
            }
            else
            {
                CoreUtils.SetRenderTarget(ctx.cmd, ctx.cameraColorBuffer);
                CoreUtils.DrawFullScreen(ctx.cmd, ocean.FullscreenM, ctx.propertyBlock, shaderPassTransferFinal);
            }
        }
    }
}