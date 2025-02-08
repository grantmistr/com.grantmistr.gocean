#ifndef GOCEAN_WATERSCREENMASK_PASS_CLEARMASKS
#define GOCEAN_WATERSCREENMASK_PASS_CLEARMASKS

#include "GOcean_WaterScreenMask_Properties.hlsl"
#include "GOcean_UnderwaterSampling.hlsl"

float4 vert(uint vertexID : SV_VertexID) : SV_Position
{
    return GetFullScreenTriVertexPosition(vertexID, GetNearClipValue());
}

uint frag() : SV_Target
{
    return CACHED_TIME_BIT_MASK;
}

#endif