#ifndef GOCEAN_WATERSCREENMASK_PASS_CLEAR
#define GOCEAN_WATERSCREENMASK_PASS_CLEAR

#include "GOcean_WaterScreenMask_Properties.hlsl"
#include "GOcean_HelperFunctions.hlsl"

float4 vert(uint vertexID : SV_VertexID) : SV_Position
{
    return GetFullScreenTriVertexPosition(vertexID, 0.0);
}

float4 frag() : SV_Target
{
    return float4(_ClearValue, 0.0, 0.0, 0.0);
}

#endif // GOCEAN_WATERSCREENMASK_PASS_CLEAR