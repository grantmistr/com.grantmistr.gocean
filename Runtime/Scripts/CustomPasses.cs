using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;
    using static Helper;

    /// <summary>
    /// EnableVolumes after all GOcean components are initialized
    /// </summary>
    public class CustomPasses
    {
        public const int CUSTOM_PASS_VOLUME_COUNT = 3;
        public static readonly CustomPassInjectionPoint[] CUSTOM_PASS_INJECTION_POINTS = new CustomPassInjectionPoint[CUSTOM_PASS_VOLUME_COUNT]
        {
            CustomPassInjectionPoint.BeforeRendering,
            CustomPassInjectionPoint.BeforePreRefraction,
            //CustomPassInjectionPoint.BeforeTransparent,
            CustomPassInjectionPoint.BeforePostProcess
        };

        private CustomPassVolume[] customPassVolumes = new CustomPassVolume[CUSTOM_PASS_VOLUME_COUNT];

        public void Initialize(Ocean ocean, ComponentContainer components, Constants constants)
        {
            GameObject gameObject = ocean.gameObject;

            CustomPassVolume[] volumes = gameObject.GetComponents<CustomPassVolume>();

            // delete extra volumes
            for (int i = 0; i < volumes.Length; i++)
            {
                if (i >= CUSTOM_PASS_VOLUME_COUNT)
                {
                    SmartDestroy(volumes[i]);
                }
            }

            for (int i = 0; i < CUSTOM_PASS_VOLUME_COUNT; i++)
            {
                CustomPassVolume v;

                if (i >= volumes.Length)
                {
                    v = gameObject.AddComponent<CustomPassVolume>();
                }
                else
                {
                    v = volumes[i];
                }

                v.customPasses.Clear();

                switch (i)
                {
                    case 0:
                        v.customPasses.Add(new BeforeRenderingCustomPass(ocean, components, constants));
                        break;
                    case 1:
                        v.customPasses.Add(new BeforePreRefractionCustomPass(ocean, components));
                        break;
                    //case 2:
                    //    v.customPasses.Add(new BeforeTransparentCustomPass(ocean, components));
                    //    break;
                    case 2:
                        v.customPasses.Add(new BeforePostProcessCustomPass(ocean, components));
                        break;
                    default:
                        break;
                }

                v.injectionPoint = CUSTOM_PASS_INJECTION_POINTS[i];
                v.isGlobal = true;
                v.enabled = false;
                v.hideFlags = HideFlags.NotEditable;

                customPassVolumes[i] = v;
            }

#if UNITY_EDITOR
            EditorApplication.delayCall += () =>
            {
                if (this != null)
                {
                    foreach (CustomPassVolume v in customPassVolumes)
                    {
                        if (v != null)
                        {
                            v.hideFlags = HideFlags.NotEditable;
                        }
                    }
                }
            };
#endif
        }

        public void EnableVolumes()
        {
            if (this == null)
            {
                return;
            }

            foreach (UnityEngine.Rendering.HighDefinition.CustomPassVolume v in customPassVolumes)
            {
                if (v != null)
                {
                    v.enabled = true;
                }
            }
        }

        public void DisableVolumes()
        {
            if (this == null)
            {
                return;
            }

            foreach (UnityEngine.Rendering.HighDefinition.CustomPassVolume v in customPassVolumes)
            {
                if (v != null)
                {
                    v.enabled = false;
                }
            }
        }

        public void Destroy(Ocean ocean)
        {
            if (this == null)
            {
                return;
            }

            foreach (CustomPassVolume v in customPassVolumes)
            {
                LateUpdateSmartDestroy(v);
            }
        }
    }

    public sealed class BeforeRenderingCustomPass : CustomPass
    {
        public Ocean ocean;
        public ComponentContainer components;
        public Constants constants;

        public BeforeRenderingCustomPass(Ocean ocean, ComponentContainer components, Constants constants)
        {
            this.ocean = ocean;
            this.components = components;
            this.constants = constants;
        }

        protected override void Setup(ScriptableRenderContext renderContext, CommandBuffer cmd)
        {
            targetColorBuffer = TargetBuffer.None;
            targetDepthBuffer = TargetBuffer.None;
            clearFlags = ClearFlag.None;
            name = "GOceanBeforeRendering";
        }

        protected override void Execute(CustomPassContext ctx)
        {
            components.Generic.SetRTHandleSystemReferenceSize(ctx.hdCamera.actualWidth, ctx.hdCamera.actualHeight);
            components.Terrain.UpdateTerrainData(ctx.cmd, ctx.hdCamera.camera.transform.position);
            constants.UpdatePerCameraData(ctx.hdCamera, components);
            components.Displacement.UpdateSpectrumTexture(ctx.cmd);
            components.Terrain.UpdateDirectionalInfluenceAndComputeTerrainTextureArray(ctx.cmd);
            components.Mesh.UpdateMesh(ctx.cmd, ctx.hdCamera.frustum.planes, ctx.cameraDepthBuffer, ctx.hdCamera.camera.transform.position);
            components.Screen.DrawUnderwaterMask(ctx.cmd, ctx.propertyBlock, ctx.hdCamera.camera.transform.position);
        }
    }

    public sealed class BeforePreRefractionCustomPass : CustomPass
    {
        public Ocean ocean;
        public ComponentContainer components;

        public BeforePreRefractionCustomPass(Ocean ocean, ComponentContainer components)
        {
            this.ocean = ocean;
            this.components = components;
        }

        protected override void Setup(ScriptableRenderContext renderContext, CommandBuffer cmd)
        {
            targetColorBuffer = TargetBuffer.None;
            targetDepthBuffer = TargetBuffer.None;
            clearFlags = ClearFlag.None;
            name = "GOceanBeforePreRefraction";
        }

        protected override void Execute(CustomPassContext ctx)
        {
            components.Caustic.DrawOpaqueCaustic(ctx.cmd, ctx.propertyBlock, ctx.cameraColorBuffer, ctx.cameraDepthBuffer);
            components.Underwater.DrawOpaqueUnderwaterFog(ctx.cmd, ctx.propertyBlock);
            components.Underwater.ComputeLightRaysScreenWater(ctx.cmd, ctx.cameraDepthBuffer);
            components.Screen.BlurScreenTexture(ctx.cmd, ctx.propertyBlock);
        }
    }

    public sealed class BeforeTransparentCustomPass : CustomPass
    {
        public Ocean ocean;
        public ComponentContainer components;

        public BeforeTransparentCustomPass(Ocean ocean, ComponentContainer components)
        {
            this.ocean = ocean;
            this.components = components;
        }

        protected override void Setup(ScriptableRenderContext renderContext, CommandBuffer cmd)
        {
            targetColorBuffer = TargetBuffer.None;
            targetDepthBuffer = TargetBuffer.None;
            clearFlags = ClearFlag.None;
            name = "GOceanBeforePreRefraction";
        }

        protected override void Execute(CustomPassContext ctx)
        {
            components.Generic.DrawWaterForward(ctx.cmd);
#if UNITY_EDITOR
            components.Mesh.DrawWireframe(ctx.cmd, ctx.cameraColorBuffer);
#endif
        }
    }

    public sealed class BeforePostProcessCustomPass : CustomPass
    {
        public Ocean ocean;
        public ComponentContainer components;

        public BeforePostProcessCustomPass(Ocean ocean, ComponentContainer components)
        {
            this.ocean = ocean;
            this.components = components;
        }

        protected override void Setup(ScriptableRenderContext renderContext, CommandBuffer cmd)
        {
            targetColorBuffer = TargetBuffer.None;
            targetDepthBuffer = TargetBuffer.None;
            clearFlags = ClearFlag.None;
            name = "GOceanBeforePostProcess";
        }

        protected override void Execute(CustomPassContext ctx)
        {
            components.Underwater.DrawUnderwaterTint(ctx.cmd, ctx.propertyBlock);
            components.Screen.TransferFinal(ctx.cmd, ctx.cameraColorBuffer, ctx.cameraDepthBuffer, ctx.propertyBlock);
        }
    }
}