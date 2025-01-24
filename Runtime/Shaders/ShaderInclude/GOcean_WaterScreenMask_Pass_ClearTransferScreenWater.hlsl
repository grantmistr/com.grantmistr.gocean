#ifndef GOCEAN_WATERSCREENMASK_PASS_CLEAR_TRANSFER_SCREEN_WATER
#define GOCEAN_WATERSCREENMASK_PASS_CLEAR_TRANSFER_SCREEN_WATER

#include "GOcean_WaterScreenMask_Properties.hlsl"
#include "GOcean_HelperFunctions.hlsl"

float4 vert(uint vertexID : SV_VertexID) : SV_Position
{
    return GetFullScreenTriVertexPosition(vertexID, 0.0);
}

float4 frag(float4 positionSS : SV_Position) : SV_Target
{
    float screenWater = _OceanScreenTexture[positionSS.xy].z;
    return float4(_ClearValue, 0.0, screenWater, 0.0);
}

#endif // GOCEAN_WATERSCREENMASK_PASS_CLEAR_TRANSFER_SCREEN_WATER