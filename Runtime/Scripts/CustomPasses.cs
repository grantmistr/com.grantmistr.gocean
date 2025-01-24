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
        public static readonly string[] CUSTOM_PASS_VOLUME_NAMES =
        {
            "BeforeRendering",
            "BeforePreRefraction",
            "BeforePostProcess"
        };
        public static readonly CustomPassInjectionPoint[] CUSTOM_PASS_INJECTION_POINTS =
        {
            CustomPassInjectionPoint.BeforeRendering,
            CustomPassInjectionPoint.BeforePreRefraction,
            CustomPassInjectionPoint.BeforePostProcess
        };

        private CustomPassVolume[] customPassVolumes = new CustomPassVolume[CUSTOM_PASS_VOLUME_COUNT];
        public CustomPassVolume BeforeRendering => customPassVolumes[0];
        public CustomPassVolume BeforePreRefraction => customPassVolumes[1];
        public CustomPassVolume BeforePostProcess => customPassVolumes[2];

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
#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                EditorApplication.QueuePlayerLoopUpdate();
            }
#endif
            components.Generic.SetRTHandleSystemReferenceSize(ctx);
            components.Terrain.UpdateTerrainData(ctx);
            constants.UpdatePerCameraData(ctx, components);
            components.Displacement.UpdateSpectrumTexture(ctx);
            components.Terrain.UpdateDirectionalInfluenceAndComputeTerrainTextureArray(ctx);
            components.Mesh.UpdateMesh(ctx);
            components.Screen.DrawUnderwaterMask(ctx);
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
            components.Caustic.DrawOpaqueCaustic(ctx);
            components.Underwater.DrawOpaqueUnderwaterFog(ctx);
            components.Screen.DrawLightRaysScreenWater(ctx);
            components.Screen.BlurScreenTexture(ctx);
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
            components.Generic.DrawWaterForward(ctx);
#if UNITY_EDITOR
            components.Mesh.DrawWireframe(ctx);
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
            components.Underwater.DrawUnderwaterTint(ctx);
            components.Generic.TransferFinal(ctx);
        }
    }
}