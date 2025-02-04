#if (SHADERPASS != SHADERPASS_DEPTH_ONLY && SHADERPASS != SHADERPASS_SHADOWS && SHADERPASS != SHADERPASS_TRANSPARENT_DEPTH_PREPASS && SHADERPASS != SHADERPASS_TRANSPARENT_DEPTH_POSTPASS)
#error SHADERPASS_is_not_correctly_define
#endif

#include "GOcean_Constants.hlsl"
#include "GOcean_HelperFunctions.hlsl"

float4 Vert(uint vertexID : SV_VertexID) : SV_Position
{
    return GetFullScreenTriangleVertexPosition(vertexID, UNITY_NEAR_CLIP_VALUE);
}

float Frag(float4 iVertex : SV_Position) : SV_Depth
{
    float4 posNDC = float4(iVertex.xy / _ScreenSize.xy, 1.0, 1.0);
    float4 posCS = float4(posNDC.xy * 2.0 - 1.0, 1.0, 1.0);
#if UNITY_UV_STARTS_AT_TOP
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
    
    float2 uvWS = posRWS.xz + _WorldSpaceCameraPos_Internal.xz;
    
    bool inSquare = IsInSquare(_CameraPositionStepped.xy, _ChunkGridResolution * _ChunkSize, uvWS);
    bool mask = oceanHeightMask ? !hemisphereMask : hemisphereMask;
    
#if UNITY_REVERSED_Z
    bool isNotFarPlane = (posCS.z + 0.00000001) > 0.0;
#else
    bool isNotFarPlane = (posCS.z - 0.00000001) < 1.0;
#endif
    
    if (mask || (inSquare && isNotFarPlane))
    {
        discard;
    }
    
    return saturate(posCS.z / posCS.w);
}
