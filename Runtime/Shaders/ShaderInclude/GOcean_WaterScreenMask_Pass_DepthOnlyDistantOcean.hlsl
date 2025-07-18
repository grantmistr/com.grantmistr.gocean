#ifndef GOCEAN_WATERSCREENMASK_PASS_DEPTHONLYDISTANTOCEAN
#define GOCEAN_WATERSCREENMASK_PASS_DEPTHONLYDISTANTOCEAN

#include "GOcean_WaterScreenMask_Properties.hlsl"
#include "GOcean_HelperFunctions.hlsl"

float4 vert(uint vertexID : SV_VertexID) : SV_Position
{
    return GetFullScreenTriVertexPosition(vertexID, GetNearClipValue());
}

float4 frag(float4 position : SV_Position, out float outputDepth : SV_Depth) : SV_Target
{
    float4 posNDC = float4(position.xy / _ScreenSize.xy, 1.0, 1.0);
    float4 posCS = float4(posNDC.xy * 2.0 - 1.0, GetNearClipValue(), 1.0);
#ifdef UNITY_UV_STARTS_AT_TOP
        posCS.y = -posCS.y;
#endif
    float4 posRWS = mul(_InvViewProjMatrix, posCS);
    posRWS.xyz /= posRWS.w;
    
    float3 dir = normalize(posRWS.xyz);
    float dirDotUp = dot(dir, float3(0.0, 1.0, 0.0));
    
    bool hemisphereMask = dirDotUp < 0.0;
    bool oceanHeightMask = _WorldSpaceCameraPos_Internal.y > _WaterHeight;
    
    float tiling = _WorldSpaceCameraPos_Internal.y - _WaterHeight;
    tiling = oceanHeightMask ? tiling : -tiling;
    posRWS.xz = (dir.xz * tiling) / max(abs(dir.y), 0.001);
    posRWS.y = _WaterHeight - _WorldSpaceCameraPos_Internal.y;
    posCS = mul(_ViewProjMatrix, float4(posRWS.xyz, 1.0));
    posCS.z /= posCS.w;
    
    float2 uvWS = posRWS.xz + _WorldSpaceCameraPos_Internal.xz;
    
    bool inSquare = IsInSquare(_CameraPositionStepped.xy, _ChunkGridResolution * _ChunkSize, uvWS);
    bool mask = oceanHeightMask ? !hemisphereMask : hemisphereMask;
    
    if (mask || (inSquare && !IsFarPlane(posCS.z, 0.00000001)))
    {
        discard;
    }
    
    outputDepth = saturate(posCS.z);
    
    return float4(0.0, 1.0, 0.0, 0.0);
}

#endif