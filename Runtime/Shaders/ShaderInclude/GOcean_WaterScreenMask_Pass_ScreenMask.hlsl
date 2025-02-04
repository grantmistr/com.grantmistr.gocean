#ifndef GOCEAN_WATERSCREENMASK_PASS_FACING
#define GOCEAN_WATERSCREENMASK_PASS_FACING

#include "GOcean_WaterScreenMask_Properties.hlsl"
#include "GOcean_HelperFunctions.hlsl"
#include "GOcean_GetTrisFromBuffer.hlsl"

v2f vert(uint vertexID : SV_VertexID)
{
    v2f o;
    
    float2 preDisplacedPositionXZ;
    float3 displacedPosition;
    GetVertexFromTri(vertexID, preDisplacedPositionXZ, displacedPosition);
    
    o.preDisplacedPositionXZ = preDisplacedPositionXZ;
    o.position = mul(_ViewProjMatrix, float4(displacedPosition, 1.0));
    
    return o;
}

float4 frag(v2f i, bool facing : SV_IsFrontFace) : SV_Target
{
    return float4(i.preDisplacedPositionXZ, facing ? 0.0 : 1.0, 1.0);
}

#endif // GOCEAN_WATERSCREENMASK_PASS_FACING