#ifndef GOCEAN_WATERSCREENMASK_PASS_CLEAR
#define GOCEAN_WATERSCREENMASK_PASS_CLEAR

#include "GOcean_WaterScreenMask_Properties.hlsl"
#include "GOcean_HelperFunctions.hlsl"

float4 vert(uint vertexID : SV_VertexID) : SV_Position
{
    return GetFullScreenTriVertexPosition(vertexID, GetNearClipValue());
}

float4 frag(out float outDepth : SV_Depth) : SV_Target
{
    outDepth = 1.0 - GetNearClipValue();
    return float4(0.0, 0.0, _ClearValue, 0.0);
}

#endif // GOCEAN_WATERSCREENMASK_PASS_CLEAR