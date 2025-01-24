using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;
    using static Helper;

    public class Caustic : Component
    {
        public const float MAX_CAUSTIC_STRENGTH_WIND_SPEED = 5f;

        public float causticStrengthUser;
        [ShaderParam("_CausticStrength")]
        public float causticStrength;
        [ShaderParam("_CausticTiling")]
        public float causticTiling;
        [ShaderParam("_CausticDistortion")]
        public float causticDistortion;
        [ShaderParam("_CausticDefinition")]
        public float causticDefinition;
        [ShaderParam("_CausticFadeDepth")]
        public float causticFadeDepth;
        [ShaderParam("_CausticAboveWaterFadeDistance")]
        public float causticAboveWaterFadeDistance;

        private int shaderPassOpaqueCaustic;

        public Caustic()
        {
        }

        public override void Initialize()
        {
            InitializeParams(ocean.parametersUser.caustic);

            shaderPassOpaqueCaustic = ocean.FullscreenM.FindPass("OpaqueCaustic");
        }

        public override void InitializeParams(BaseParamsUser userParams)
        {
            CausticParamsUser u = userParams as CausticParamsUser;

            causticStrengthUser = u.causticStrength;
            causticStrength = CalculateCausticStrength(ocean.WindSpeed, causticStrengthUser);
            causticTiling = u.causticTiling;
            causticDistortion = u.causticDistortion;
            causticDefinition = u.causticDefinition;
            causticFadeDepth = u.causticFadeDepth;
            causticAboveWaterFadeDistance = u.causticAboveWaterFadeDistance;
        }

        public void DrawOpaqueCaustic(CustomPassContext ctx)
        {
            ctx.propertyBlock.SetTexture(PropIDs.cameraDepthTexture, ctx.cameraDepthBuffer);
            //ctx.propertyBlock.SetTexture(PropIDs.temporaryColorTexture, components.Generic.temporaryColorTexture);
            //ctx.propertyBlock.SetTexture(PropIDs.waterDepthTexture, components.Generic.waterDepthTexture);
            //ctx.propertyBlock.SetTexture(PropIDs.oceanScreenTexture, components.Screen.screenTexture);

            CoreUtils.SetRenderTarget(ctx.cmd, ctx.cameraColorBuffer, ClearFlag.None);
            CoreUtils.DrawFullScreen(ctx.cmd, ocean.FullscreenM, ctx.propertyBlock, shaderPassOpaqueCaustic);
        }

        public float CalculateCausticStrength(float windSpeed, float causticStrengthUser)
        {
            float o = Mathf.Min(windSpeed, MAX_CAUSTIC_STRENGTH_WIND_SPEED) / MAX_CAUSTIC_STRENGTH_WIND_SPEED;
            o = o * o * (3f - 2f * o);
            o *= causticStrengthUser;
            return o;
        }

        public void UpdateCausticStrength(float windSpeed)
        {
            causticStrength = CalculateCausticStrength(windSpeed, causticStrengthUser);
        }
    }
}