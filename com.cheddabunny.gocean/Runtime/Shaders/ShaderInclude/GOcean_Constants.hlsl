#ifndef GOCEAN_CONSTANTS
#define GOCEAN_CONSTANTS

cbuffer GOceanPerCamera
{
    float4 _CascadeShadowSplits;
    float4 _CameraPositionStepped;
    float _CameraZRotation;
    float gOcean_Unused0;
    float gOcean_Unused1;
    float gOcean_Unused2;
    int2 _TerrainLookupCoordOffset;
    int _ValidTerrainHeightmapMask;
    int gOcean_Unused3;
};

cbuffer GOceanOnDemand
{
    float2 _WindDirection;
    float2 _DirectionalInfluence;
    float _WindSpeed;
    float _CausticStrength;
    float _LightRayStrength;
    float _LightRayStrengthInverse;
    float _WaterHeight;
    float _Turbulence;
    float gOcean_Unused4;
    float gOcean_Unused5;
};

cbuffer GOceanConstant
{
    float4 _PatchSize;
    float4 _UnderwaterFogColor;
    float _UnderwaterFogFadeDistance;
    float _CausticDistortion;
    float _CausticDefinition;
    float _CausticTiling;
    float _CausticFadeDepth;
    float _CausticAboveWaterFadeDistance;
    float gOcean_Unused6;
    float gOcean_Unused7;
    uint _SpectrumTextureResolution;
    int gOcean_Unused8;
    int gOcean_Unused9;
    int gOcean_Unused10;
};

// Shader Graph methods

void IncludeGOceanConstants_float(out bool output)
{
    output = true;
}

void GetCascadeShadowSplits_float(out float4 cascadeShadowSplits)
{
    cascadeShadowSplits = _CascadeShadowSplits;
}

void GetCameraPositionStepped_float(out float4 cameraPositionStepped)
{
    cameraPositionStepped = _CameraPositionStepped;
}

void GetWindDirection_float(out float2 windDirection)
{
    windDirection = _WindDirection;
}

void GetDirectionalInfluence_float(out float2 directionalInfluence)
{
    directionalInfluence = _DirectionalInfluence;
}

void GetCameraZRotation_float(out float cameraZRotation)
{
    cameraZRotation = _CameraZRotation;
}

void GetWindSpeed_float(out float windSpeed)
{
    windSpeed = _WindSpeed;
}

void GetCausticStrength_float(out float causticStrength)
{
    causticStrength = _CausticStrength;
}

void GetLightRayStrength_float(out float lightRayStrength)
{
    lightRayStrength = _LightRayStrength;
}

void GetLightRayStrengthInverse_float(out float lightRayStrengthInverse)
{
    lightRayStrengthInverse = _LightRayStrengthInverse;
}

void GetWaterHeight_float(out float waterHeight)
{
    waterHeight = _WaterHeight;
}

void GetTurbulence_float(out float turbulence)
{
    turbulence = _Turbulence;
}

void GetTerrainLookupCoordOffset_float(out int2 terrainLookupCoordOffset)
{
    terrainLookupCoordOffset = _TerrainLookupCoordOffset;
}

void GetValidTerrainHeightmapMask_float(out int validTerrainHeightmapMask)
{
    validTerrainHeightmapMask = _ValidTerrainHeightmapMask;
}

void GetPatchSize_float(out float4 patchSize)
{
    patchSize = _PatchSize;
}

void GetUnderwaterFogColor_float(out float3 underwaterFogColor)
{
    underwaterFogColor = _UnderwaterFogColor.xyz;
}

void GetUnderwaterFogFadeDistance_float(out float underwaterFogFadeDistance)
{
    underwaterFogFadeDistance = _UnderwaterFogFadeDistance;
}

void GetCausticDistortion_float(out float causticDistortion)
{
    causticDistortion = _CausticDistortion;
}

void GetCausticDefinition_float(out float causticDefinition)
{
    causticDefinition = _CausticDefinition;
}

void GetCausticTiling_float(out float causticTiling)
{
    causticTiling = _CausticTiling;
}

void GetCausticFadeDepth_float(out float causticFadeDepth)
{
    causticFadeDepth = _CausticFadeDepth;
}

void GetCausticAboveWaterFadeDistance_float(out float causticAboveWaterFadeDistance)
{
    causticAboveWaterFadeDistance = _CausticAboveWaterFadeDistance;
}

void GetSpectrumTextureResolution_float(out uint spectrumTextureResolution)
{
    spectrumTextureResolution = _SpectrumTextureResolution;
}

#endif // GOCEAN_CONSTANTS