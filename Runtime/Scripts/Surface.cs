using UnityEngine;

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;
    using static Helper;

    public class Surface : Component
    {
        [ShaderParam("_NormalStrength")]
        public float normalStrength;
        [ShaderParam("_Smoothness")]
        public float smoothness;
        [ShaderParam("_DistantSmoothness")]
        public float distantSmoothness;
        [ShaderParam("_SmoothnessTransitionDistance")]
        public float smoothnessTransitionDistance;
        [ShaderParam("_RefractionStrength")]
        public float refractionStrength;
        [ShaderParam("_WaterColor")]
        public Color waterColor;
        [ShaderParam("_TintColor")]
        public Color tintColor;
        [ShaderParam("_ScatteringColor")]
        [ColorUsage(true, true)]
        public Color scatteringColor;
        [ShaderParam("_ScatteringFalloff")]
        public float scatteringFalloff;

        public Surface()
        {
        }

        public override void Initialize()
        {
            InitializeParams(ocean.parametersUser.surface);
        }

        public override void InitializeParams(BaseParamsUser userParams)
        {
            SurfaceParamsUser u = userParams as SurfaceParamsUser;

            normalStrength = u.normalStrength;
            smoothness = u.smoothness;
            distantSmoothness = u.distantSmoothness;
            smoothnessTransitionDistance = u.smoothnessTransitionDistance;
            refractionStrength = u.refractionStrength;
            waterColor = u.waterColor;
            tintColor = CalculateTintColor(u.waterColor);
            scatteringFalloff = u.scatteringFalloff;
            scatteringColor = u.scatteringColor;
        }

        private Color CalculateTintColor(Color waterColor)
        {
            return Color.Lerp(waterColor, new Color(1f, 1f, 1f, 1f), 0.5f);
        }
    }
}