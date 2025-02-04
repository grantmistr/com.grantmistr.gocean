#ifndef GOCEAN_WIREFRAME_VERTEX
#define GOCEAN_WIREFRAME_VERTEX

#include "GOcean_Wireframe_Properties.hlsl"
#include "GOcean_GetTrisFromBuffer.hlsl"

v2f vert(uint vertexID : SV_VertexID)
{
    v2f o;
    
    float3 position;
    float2 bary;
    GetUnderwaterMaskVertexPositionWithBaryFromTri(vertexID, position, bary);
    
    //position -= _WorldSpaceCameraPos_Internal.xyz;
    
    o.barycentricCoord = bary;
    o.vertex = mul(_ViewProjMatrix, float4(position, 1.0));
    
    return o;
}

#endif // GOCEAN_WIREFRAME_VERTEX