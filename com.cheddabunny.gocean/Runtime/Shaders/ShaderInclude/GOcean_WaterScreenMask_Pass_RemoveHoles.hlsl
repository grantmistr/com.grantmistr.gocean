#ifndef GOCEAN_WATERSCREENMASK_PASS_REMOVE_HOLES
#define GOCEAN_WATERSCREENMASK_PASS_REMOVE_HOLES

#include "GOcean_WaterScreenMask_Properties.hlsl"
#include "GOcean_HelperFunctions.hlsl"
#include "GOcean_TextureSamplers.hlsl"
#include "GOcean_UnderwaterSampling.hlsl"

float4 vert(uint vertexID : SV_VertexID) : SV_Position
{
    return GetFullScreenTriVertexPosition(vertexID, 0.0);
}

// if a pixel is isolated, flip its color
float4 frag(float4 positionSS : SV_Position) : SV_Target
{
    float4 oceanScreenTextureSample = _OceanScreenTexture[positionSS.xy];
    
    float2 D = _OceanScreenTexture[int2(positionSS.x, positionSS.y - 2)].xy;
    float2 U = _OceanScreenTexture[int2(positionSS.x, positionSS.y + 2)].xy;
    
    //bool invalid = ((v != L) && (v != R)) || ((v != D) && (v != U));
    bool invalid = ((oceanScreenTextureSample.x != D.x) && (oceanScreenTextureSample.x != U.x));
    oceanScreenTextureSample.x = invalid ? 1.0 - oceanScreenTextureSample.x : oceanScreenTextureSample.x;
    
    invalid = ((oceanScreenTextureSample.y != D.y) && (oceanScreenTextureSample.y != U.y));
    oceanScreenTextureSample.y = invalid ? 1.0 - oceanScreenTextureSample.y : oceanScreenTextureSample.y;
    
    return oceanScreenTextureSample;
}

#endif // GOCEAN_WATERSCREENMASK_PASS_REMOVE_HOLES