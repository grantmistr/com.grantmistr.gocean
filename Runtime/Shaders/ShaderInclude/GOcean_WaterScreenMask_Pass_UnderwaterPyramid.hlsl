#ifndef GOCEAN_WATERSCREENMASK_PASS_FACING
#define GOCEAN_WATERSCREENMASK_PASS_FACING

#include "GOcean_WaterScreenMask_Properties.hlsl"
#include "GOcean_HelperFunctions.hlsl"
#include "GOcean_GetTrisFromBuffer.hlsl"

float4 vert(uint vertexID : SV_VertexID) : SV_POSITION
{
    float3 displacedPosition = GetUnderwaterMaskVertexPositionFromTri(vertexID);
    
    //displacedPosition -= _WorldSpaceCameraPos_Internal.xyz;
    
    return mul(_ViewProjMatrix, float4(displacedPosition, 1.0));
}

float4 frag() : SV_Target
{
    return float4(0.0, 0.0, 1.0, 0.0);
}

#endif // GOCEAN_WATERSCREENMASK_PASS_FACING