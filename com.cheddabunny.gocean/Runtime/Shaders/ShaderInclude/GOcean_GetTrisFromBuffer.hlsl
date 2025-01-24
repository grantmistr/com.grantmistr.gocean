#ifndef GOCEAN_GET_TRIS_FROM_BUFFER
#define GOCEAN_GET_TRIS_FROM_BUFFER

#include "GOcean_MeshData.hlsl"

ByteAddressBuffer _VertexBuffer;

const static float2 baryCoords[3] = { float2(1.0, 0.0), float2(0.0, 1.0), float2(0.0, 0.0) };

void GetUnderwaterMaskVertexPositionWithBaryFromTri(uint vertexID, out float3 displacedPosition, out float2 barycentricCoord)
{
    uint3 displaced = _VertexBuffer.Load3(vertexID * VERTEX_SIZE_BYTE + VERTEX_PREDISPLACED_POSITION_XZ_SIZE_BYTE);
    
    displacedPosition = asfloat(displaced);
    barycentricCoord = baryCoords[vertexID % 3];
}

float3 GetUnderwaterMaskVertexPositionFromTri(uint vertexID)
{
    return asfloat(_VertexBuffer.Load3(vertexID * VERTEX_SIZE_BYTE + VERTEX_PREDISPLACED_POSITION_XZ_SIZE_BYTE));
}

void GetVertexPreDisplacedPositionXZFromTri(uint vertexID, out float2 preDisplacedPositionXZ)
{
    uint2 preDisplaced = _VertexBuffer.Load2(vertexID * VERTEX_SIZE_BYTE + UNDERWATER_MASK_VERTEX_COUNT * VERTEX_SIZE_BYTE);
    
    preDisplacedPositionXZ = asfloat(preDisplaced);
}

void GetVertexPreDisplacedPositionXZWithBaryFromTri(uint vertexID, out float2 preDisplacedPositionXZ, out float2 barycentricCoord)
{
    uint2 preDisplaced = _VertexBuffer.Load2(vertexID * VERTEX_SIZE_BYTE + UNDERWATER_MASK_VERTEX_COUNT * VERTEX_SIZE_BYTE);
    
    preDisplacedPositionXZ = asfloat(preDisplaced);
    barycentricCoord = baryCoords[vertexID % 3];
}

void GetVertexDisplacedPositionFromTri(uint vertexID, out float3 displacedPosition)
{
    uint3 displaced = _VertexBuffer.Load3(vertexID * VERTEX_SIZE_BYTE + VERTEX_PREDISPLACED_POSITION_XZ_SIZE_BYTE + UNDERWATER_MASK_VERTEX_COUNT * VERTEX_SIZE_BYTE);
    
    displacedPosition = asfloat(displaced);
}

void GetVertexDisplacedPositionWithBaryFromTri(uint vertexID, out float3 displacedPosition, out float2 barycentricCoord)
{
    uint3 displaced = _VertexBuffer.Load3(vertexID * VERTEX_SIZE_BYTE + VERTEX_PREDISPLACED_POSITION_XZ_SIZE_BYTE + UNDERWATER_MASK_VERTEX_COUNT * VERTEX_SIZE_BYTE);
    
    displacedPosition = asfloat(displaced);
    barycentricCoord = baryCoords[vertexID % 3];
}

void GetVertexFromTri(uint vertexID, out float2 preDisplacedPositionXZ, out float3 displacedPosition)
{
    uint2 preDisplaced = _VertexBuffer.Load2(vertexID * VERTEX_SIZE_BYTE + UNDERWATER_MASK_VERTEX_COUNT * VERTEX_SIZE_BYTE);
    uint3 displaced = _VertexBuffer.Load3(vertexID * VERTEX_SIZE_BYTE + VERTEX_PREDISPLACED_POSITION_XZ_SIZE_BYTE + UNDERWATER_MASK_VERTEX_COUNT * VERTEX_SIZE_BYTE);
    
    preDisplacedPositionXZ = asfloat(preDisplaced);
    displacedPosition = asfloat(displaced);
}

void GetVertexWithBaryFromTri(uint vertexID, out float2 preDisplacedPositionXZ, out float3 displacedPosition, out float2 barycentricCoord)
{
    uint2 preDisplaced = _VertexBuffer.Load2(vertexID * VERTEX_SIZE_BYTE + UNDERWATER_MASK_VERTEX_COUNT * VERTEX_SIZE_BYTE);
    uint3 displaced = _VertexBuffer.Load3(vertexID * VERTEX_SIZE_BYTE + VERTEX_PREDISPLACED_POSITION_XZ_SIZE_BYTE + UNDERWATER_MASK_VERTEX_COUNT * VERTEX_SIZE_BYTE);
    
    preDisplacedPositionXZ = asfloat(preDisplaced);
    displacedPosition = asfloat(displaced);
    barycentricCoord = baryCoords[vertexID % 3];
}

// Shader Graph Methods //

void GetVertexPreDisplacedPositionXZFromTri_float(uint vertexID, out float2 preDisplacedPositionXZ)
{
    GetVertexPreDisplacedPositionXZFromTri(vertexID, preDisplacedPositionXZ);
}

void GetVertexDisplacedPositionFromTri_float(uint vertexID, out float3 displacedPosition)
{
    GetVertexDisplacedPositionFromTri(vertexID, displacedPosition);
}

void GetVertexFromTri_float(uint vertexID, out float2 preDisplacedPositionXZ, out float3 displacedPosition)
{
    GetVertexFromTri(vertexID, preDisplacedPositionXZ, displacedPosition);
}

void GetVertexWithBaryFromTri_float(uint vertexID, out float2 preDisplacedPositionXZ, out float3 displacedPosition, out float2 barycentricCoord)
{
    GetVertexWithBaryFromTri(vertexID, preDisplacedPositionXZ, displacedPosition, barycentricCoord);
}

#endif // GOCEAN_GET_TRIS_FROM_BUFFER