#ifndef GOCEAN_SHADOWSAMPLING
#define GOCEAN_SHADOWSAMPLING

#include "GOcean_HDRP_ShadowDefines.hlsl"

float3 GetDirectionalShadowSamplingCoords(HDShadowData sd, float4 cascadeAtlasSize, float3 positionWS)
{
    float3x4 view;
    view[0] = float4(sd.rot0, sd.pos.x);
    view[1] = float4(sd.rot1, sd.pos.y);
    view[2] = float4(sd.rot2, sd.pos.z);
    
    positionWS = mul(view, float4(positionWS, 1.0)).xyz;
    
    float4x4 proj =
    {
        sd.proj[0], 0.0,        0.0,        0.0,
        0.0,        sd.proj[1], 0.0,        0.0,
        0.0,        0.0,        sd.proj[2], sd.proj[3],
        0.0,        0.0,        0.0,        1.0
    };
    
    float4 positionCS = mul(proj, float4(positionWS, 1.0));
    
    float3 positionTC = float3(saturate(positionCS.xy * 0.5 + 0.5), positionCS.z);
    positionTC.xy = positionTC.xy * sd.shadowMapSize.xy * cascadeAtlasSize.zw + sd.atlasOffset;
    
    return positionTC;
}

#endif // GOCEAN_SHADOWSAMPLING