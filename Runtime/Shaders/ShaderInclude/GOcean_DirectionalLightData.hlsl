#ifndef GOCEAN_DIRECTIONAL_LIGHT_DATA
#define GOCEAN_DIRECTIONAL_LIGHT_DATA

// copied from LightDefinition.cs.hlsl and ShaderVariablesLightLoop.hlsl

struct DirectionalLightData
{
    float3 positionRWS;
    uint lightLayers;
    float3 forward;
    int cookieMode;
    float4 cookieScaleOffset;
    float3 right;
    int shadowIndex;
    float3 up;
    int contactShadowIndex;
    float3 color;
    int contactShadowMask;
    float3 shadowTint;
    float shadowDimmer;
    float volumetricShadowDimmer;
    int nonLightMappedOnly;
    float minRoughness;
    int screenSpaceShadowIndex;
    float4 shadowMaskSelector;
    float diffuseDimmer;
    float specularDimmer;
    float lightDimmer;
    float volumetricLightDimmer;
    float penumbraTint;
    float isRayTracedContactShadow;
    float angularDiameter;
    float distanceFromCamera;
};

StructuredBuffer<DirectionalLightData> _DirectionalLightDatas;

#endif // GOCEAN_DIRECTIONAL_LIGHT_DATA