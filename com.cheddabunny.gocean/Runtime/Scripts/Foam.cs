using UnityEngine;

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;
    using static Helper;

    public class Foam : Component
    {
        [ShaderParam("_FoamTexture")]
        public Texture2D foamTexture;
        [ShaderParam("_FoamColor")]
        public Color foamColor;
        [ShaderParam("_FoamTextureFadeDistance")]
        public float foamTextureFadeDistance;
        [ShaderParam("_FoamTiling")]
        public float foamTiling;
        [ShaderParam("_SecondaryFoamTiling")]
        public float secondaryFoamTiling;
        [ShaderParam("_FoamOffsetSpeed")]
        public float foamOffsetSpeed;
        [ShaderParam("_FoamHardness")]
        public float foamHardness;
        [ShaderParam("_DistantFoam")]
        public float distantFoam;
        [ShaderParam("_EdgeFoamWidth")]
        public float edgeFoamWidth;
        [ShaderParam("_EdgeFoamFalloff")]
        public float edgeFoamFalloff;
        [ShaderParam("_EdgeFoamStrength")]
        public float edgeFoamStrength;
        [ShaderParam("_FoamBias")]
        public float foamBias;
        [ShaderParam("_FoamDecayRate")]
        public float foamDecayRate;
        [ShaderParam("_FoamAccumulationRate")]
        public float foamAccumulationRate;
        [ShaderParam("_ShoreWaveFoamAmount")]
        public float shoreWaveFoamAmount;

        public Foam()
        {
        }

        public override void Initialize()
        {
            InitializeParams(ocean.parametersUser.foam);
        }

        public override void InitializeParams(BaseParamsUser userParams)
        {
            FoamParamsUser u = userParams as FoamParamsUser;

            foamTexture = u.foamTexture;
            foamColor = u.foamColor;
            foamTextureFadeDistance = u.foamTextureFadeDistance;
            foamTiling = CalculateFoamTiling(u.foamTiling);
            secondaryFoamTiling = CalculateSecondaryFoamTiling(foamTiling, u.secondaryFoamTiling);
            foamOffsetSpeed = u.foamOffsetSpeed;
            foamHardness = u.foamHardness;
            distantFoam = CalculateDistantFoam(u.distantFoam);
            edgeFoamWidth = u.edgeFoamWidth;
            edgeFoamFalloff = u.edgeFoamFalloff;
            edgeFoamStrength = u.edgeFoamStrength;
            shoreWaveFoamAmount = u.shoreWaveFoamAmount;
            foamDecayRate = u.foamDecayRate;
            foamBias = u.foamBias;
            foamAccumulationRate = u.foamAccumulationRate;
        }

        private float CalculateFoamTiling(float userFoamTiling)
        {
            return userFoamTiling * 0.001f;
        }

        private float CalculateSecondaryFoamTiling(float foamTiling, float userSecondaryFoamTiling)
        {
            return foamTiling * userSecondaryFoamTiling;
        }

        private float CalculateDistantFoam(float userDistantFoam)
        {
            return 1f - userDistantFoam;
        }
    }
}