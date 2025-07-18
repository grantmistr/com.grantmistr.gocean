﻿using UnityEngine;
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

        public int sortingPriority;

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
        [ShaderParamGlobal("_TemporaryBlurTexture")]
        public RTHandle temporaryBlurTexture;

        private RenderParams oceanRenderParams, distantOceanRenderParams;
        private int shaderPassForwardOcean, shaderPassForwardDistantOcean;

        public Generic()
        {
        }

        public override void Initialize()
        {
            InitializeParams(ocean.parametersUser.generic);

            FindShaderPasses();
            InitializeTextures();
            CreateRenderParams();
        }

        public override void ReleaseResources()
        {
            ReleaseTexture(ref randomNoiseTexture);
            ReleaseTexture(ref waterDepthTexture);
            ReleaseTexture(ref temporaryColorTexture);
            ReleaseTexture(ref temporaryBlurTexture);
        }

        public override void InitializeParams(BaseParamsUser userParams)
        {
            GenericParamsUser u = userParams as GenericParamsUser;

            waterHeight = u.waterHeight;
            randomSeed = UpdateRandomSeed(u.randomSeed);
            sortingPriority = u.sortingPriority;
        }

        public override void SetShaderParams()
        {
            ocean.OceanM.renderQueue = (int)RenderQueue.Transparent + sortingPriority;

            base.SetShaderParams();
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

        public void SetRTHandleSystemReferenceSize(int width, int height)
        {
            rtHandleSystem.SetReferenceSize(width, height);
        }

        public void DrawWaterForward()
        {
            Graphics.RenderPrimitives(distantOceanRenderParams, MeshTopology.Triangles, 3, 1);

            if (components.Mesh.DrawMesh)
            {
                Graphics.RenderPrimitivesIndirect(oceanRenderParams, MeshTopology.Triangles, components.Mesh.indirectArgsBuffer, 1, (int)Mesh.IndirectStartCommand.VERTEX_COUNT);
            }
        }
            
        public void DrawWaterForward(CommandBuffer cmd)
        {
            //CoreUtils.SetRenderTarget(cmd, cameraColorBuffer, waterDepthTexture, ClearFlag.None);
            CoreUtils.DrawFullScreen(cmd, ocean.DistantOceanM, null, shaderPassForwardDistantOcean);

            if (components.Mesh.DrawMesh)
            {
                cmd.DrawProceduralIndirect(Matrix4x4.identity, ocean.OceanM, shaderPassForwardOcean, MeshTopology.Triangles, components.Mesh.indirectArgsBuffer, (int)Mesh.IndirectStartCommand.VERTEX_COUNT);
            }
        }
    }
}