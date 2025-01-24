#ifndef GOCEAN_WATERSCREENMASK_PASS_FACING
#define GOCEAN_WATERSCREENMASK_PASS_FACING

#include "GOcean_WaterScreenMask_Properties.hlsl"
#include "GOcean_HelperFunctions.hlsl"
#include "GOcean_GetTrisFromBuffer.hlsl"

float4 vert(uint vertexID : SV_VertexID) : SV_Position
{
    float3 displacedPosition;
    GetVertexDisplacedPositionFromTri(vertexID, displacedPosition);
    
    displacedPosition -= _WorldSpaceCameraPos_Internal.xyz;
    
    return mul(_ViewProjMatrix, float4(displacedPosition, 1.0));
}

float4 frag(float4 i : SV_Position, bool facing : SV_IsFrontFace) : SV_Target
{
    // flip facing - want underwater to be white
    float f = facing ? 0.0 : 1.0;
    
    return float4(f, 1.0, 0.0, 0.0);
}

#endif // GOCEAN_WATERSCREENMASK_PASS_FACING