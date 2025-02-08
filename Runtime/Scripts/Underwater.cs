using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;
    using static Helper;

    public class Underwater : Component
    {
        public const float MAX_LIGHT_RAY_STRENGTH_WIND_SPEED = 5f;

        [ShaderParam("_UnderwaterFogColor")]
        public Color underwaterFogColor;
        [ShaderParam("_UnderwaterFogFadeDistance")]
        public float underwaterFogFadeDistance;
        [ShaderParam("_UnderwaterFogDensity")]
        public float underwaterFogDensity;
        [ShaderParam("_UnderwaterSurfaceEmissionStrength")]
        public float underwaterSurfaceEmissionStrength;
        [ShaderParam("_LightRayShadowMultiplier")]
        public float lightRayShadowMultiplier;
        [ShaderParam("_LightRayTiling")]
        public float lightRayTiling;
        public float lightRayStrengthFactor;
        [ShaderParam("_LightRayStrength")]
        public float lightRayStrength;
        [ShaderParam("_LightRayDefinition")]
        public float lightRayDefinition;
        [ShaderParam("_LightRayStrengthInverse")]
        public float lightRayStrengthInverse;
        [ShaderParam("_LightRayFadeInDistance")]
        public float lightRayFadeInDistance;
        [ShaderParam("_MaxSliceDepth")]
        public float maxSliceDepth;
        [ShaderParam("_MinSliceDepth")]
        public float minSliceDepth;

        private int shaderPassOpaqueUnderwaterFog, shaderPassUnderwaterTint, shaderPassUnderwaterTintWriteDepth;

        public KernelIDs kernelIDs;
        public ThreadGroupSizes threadGroupSizes;
        public ThreadGroups threadGroups;

        public struct KernelIDs
        {
            public int LightRays { get; private set; }

            public KernelIDs(Underwater underwater)
            {
                LightRays = underwater.ocean.UnderwaterCS.FindKernel("LightRays");
            }
        }

        public struct ThreadGroupSizes
        {
            public Vector3Int LightRays { get; private set; }

            public ThreadGroupSizes(Underwater underwater)
            {
                underwater.ocean.UnderwaterCS.GetKernelThreadGroupSizes(underwater.kernelIDs.LightRays, out uint x, out uint y, out uint z);
                Vector3Int v = new Vector3Int();
                v.x = (int)x;
                v.y = (int)y;
                v.z = (int)z;
                LightRays = v;
            }
        }

        public struct ThreadGroups
        {
            public Vector3Int LightRays { get; private set; }

            public ThreadGroups(Underwater underwater)
            {
                LightRays = new Vector3Int(1, 1, 1);
            }

            public void UpdateThreadGroups(Vector2Int currentViewportSize, ThreadGroupSizes tgs)
            {
                UpdateUnderwaterLightRays(currentViewportSize, tgs);
            }

            public void UpdateUnderwaterLightRays(Vector2Int currentViewportSize, ThreadGroupSizes tgs)
            {
                int x = Mathf.CeilToInt(currentViewportSize.x / (float)tgs.LightRays.x);
                int y = Mathf.CeilToInt(currentViewportSize.y / (float)tgs.LightRays.y);
                LightRays = new Vector3Int(x, y, 1);
            }
        }

        public Underwater()
        {
        }

        public override void Initialize()
        {
            InitializeParams(ocean.parametersUser.underwater);

            kernelIDs = new KernelIDs(this);
            threadGroupSizes = new ThreadGroupSizes(this);
            threadGroups = new ThreadGroups(this);

            MCSArrays.AddComputeShader(ocean.UnderwaterCS, kernelIDs.LightRays);

            GetShaderPasses();
        }

        public override void InitializeParams(BaseParamsUser userParams)
        {
            UnderwaterParamsUser u = userParams as UnderwaterParamsUser;

            underwaterFogColor = u.underwaterFogColor;
            underwaterFogFadeDistance = u.underwaterFogFadeDistance;
            underwaterSurfaceEmissionStrength = u.underwaterSurfaceEmissionStrength;
            lightRayShadowMultiplier = u.lightRayShadowMultiplier;
            lightRayTiling = u.lightRayTiling;
            lightRayFadeInDistance = u.lightRayFadeInDistance;
            lightRayDefinition = u.lightRayDefinition;
            lightRayStrengthFactor = CalculateLightRayStrengthFactor(lightRayDefinition);
            lightRayStrength = CalculateLightRayStrength(ocean.WindSpeed, lightRayDefinition, lightRayStrengthFactor);
            lightRayStrengthInverse = CalculateLightRayStrengthInverse(lightRayStrength, lightRayDefinition);

            minSliceDepth = CalculateMinSliceDepth(u);
            maxSliceDepth = CalculateMaxSliceDepth(u, minSliceDepth);
        }

        public override void SetShaderParams()
        {
            SetKeyword(ocean.UnderwaterCS, PropIDs.ShaderKeywords.UNITY_UV_STARTS_AT_TOP, SystemInfo.graphicsUVStartsAtTop);
            SetKeyword(ocean.UnderwaterCS, PropIDs.ShaderKeywords.UNITY_REVERSED_Z, SystemInfo.usesReversedZBuffer);

            base.SetShaderParams();
        }

        private void GetShaderPasses()
        {
            shaderPassOpaqueUnderwaterFog = ocean.FullscreenM.FindPass("OpaqueUnderwaterFog");
            shaderPassUnderwaterTint = ocean.FullscreenM.FindPass("UnderwaterTint");
            shaderPassUnderwaterTintWriteDepth = ocean.FullscreenM.FindPass("UnderwaterTintWriteDepth");
        }

        public void DrawOpaqueUnderwaterFog(CustomPassContext ctx)
        {
            CoreUtils.DrawFullScreen(ctx.cmd, ocean.FullscreenM, ctx.propertyBlock, shaderPassOpaqueUnderwaterFog);
        }

        public void DrawUnderwaterTint(CustomPassContext ctx)
        {
            //ctx.propertyBlock.SetTexture(PropIDs.oceanScreenTexture, components.Screen.screenTexture);
            //ctx.propertyBlock.SetTexture(PropIDs.temporaryColorTexture, components.Generic.temporaryColorTexture);

            if (components.Generic.waterWritesToDepth)
            {
                ctx.propertyBlock.SetTexture(PropIDs.waterDepthTexture, components.Generic.waterDepthTexture);
                //ctx.propertyBlock.SetTexture(PropIDs.temporaryDepthTexture, components.Generic.temporaryDepthTexture);

                CoreUtils.SetRenderTarget(ctx.cmd, components.Generic.temporaryColorTexture, components.Generic.waterDepthTexture, ClearFlag.Depth);
                CoreUtils.DrawFullScreen(ctx.cmd, ocean.FullscreenM, ctx.propertyBlock, shaderPassUnderwaterTintWriteDepth);
            }
            else
            {
                CoreUtils.SetRenderTarget(ctx.cmd, components.Generic.temporaryColorTexture, ClearFlag.None);
                CoreUtils.DrawFullScreen(ctx.cmd, ocean.FullscreenM, ctx.propertyBlock, shaderPassUnderwaterTint);
            }
        }

        public void ComputeLightRaysScreenWater(CustomPassContext ctx)
        {
            threadGroups.UpdateUnderwaterLightRays(rtHandleSystem.rtHandleProperties.currentViewportSize, components.Underwater.threadGroupSizes);
            ctx.cmd.SetComputeTextureParam(ocean.UnderwaterCS, kernelIDs.LightRays, PropIDs.cameraDepthTexture, ctx.cameraDepthBuffer);
            ctx.cmd.DispatchCompute(ocean.UnderwaterCS, kernelIDs.LightRays, threadGroups.LightRays);
        }

        private float CalculateMinSliceDepth(UnderwaterParamsUser u)
        {
            return Mathf.Min(u.maxSliceDepth, u.minSliceDepth, u.underwaterFogFadeDistance);
        }

        private float CalculateMaxSliceDepth(UnderwaterParamsUser u, float minSliceDepth)
        {
            return Mathf.Min(Mathf.Max(minSliceDepth, u.maxSliceDepth), u.underwaterFogFadeDistance);
        }

        private float CalculateLightRayStrengthFactor(float lightRayDefinition)
        {
            return 1f + lightRayDefinition * 0.25f;
        }

        public float CalculateLightRayStrength(float windSpeed, float lightRayDefinition, float lightRayStrengthFactor)
        {
            float o = Mathf.Min(windSpeed, MAX_LIGHT_RAY_STRENGTH_WIND_SPEED) / MAX_LIGHT_RAY_STRENGTH_WIND_SPEED;
            o = o * o * (3f - 2f * o);
            o *= lightRayStrengthFactor * (lightRayStrengthFactor - 1f) / lightRayStrengthFactor;
            return o + 1f;
        }

        public void UpdateLightRayStrength(float windSpeed)
        {
            lightRayStrength = CalculateLightRayStrength(windSpeed, lightRayDefinition, lightRayStrengthFactor);

            UpdateLightRayStrengthInverse();
        }

        public float CalculateLightRayStrengthInverse(float lightRayStrength, float lightRayDefinition)
        {
            return Mathf.Pow(1f / lightRayStrength, 1f / lightRayDefinition);
        }

        public void UpdateLightRayStrengthInverse()
        {
            lightRayStrengthInverse = CalculateLightRayStrengthInverse(lightRayStrength, lightRayDefinition);
        }
    }
}