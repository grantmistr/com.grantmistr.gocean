#ifndef GOCEAN_DIRECTIONAL_LIGHT_DATA
#define GOCEAN_DIRECTIONAL_LIGHT_DATA

struct DirectionalLightData
{
    float3 positionRWS;
    uint lightLayers;
    float lightDimmer;
    float volumetricLightDimmer;
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
    float2 cascadesBorderFadeScaleBias;
    float diffuseDimmer;
    float specularDimmer;
    float penumbraTint;
    float isRayTracedContactShadow;
    float distanceFromCamera;
    float angularDiameter;
    float flareFalloff;
    float flareCosInner;
    float flareCosOuter;
    float __unused__;
    float3 flareTint;
    float flareSize;
    float3 surfaceTint;
    float4 surfaceTextureScaleOffset;
};

StructuredBuffer<DirectionalLightData> _DirectionalLightDatas;

#endif // GOCEAN_DIRECTIONAL_LIGHT_DATA