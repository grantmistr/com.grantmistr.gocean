#ifndef GOCEAN_OCCLUSION_CULLING
#define GOCEAN_OCCLUSION_CULLING

#include "GOcean_HDRP_ShaderVariablesGlobal.hlsl"
#include "GOcean_HelperFunctions.hlsl"
#include "GOcean_TextureSamplers.hlsl"
#include "GOcean_CameraDepthDefines.hlsl"

bool OcclusionQuery(float3 position, float radius)
{
    position -= _WorldSpaceCameraPos_Internal.xyz;
    
    float4 positionCS = mul(_CameraViewProjMatrix, float4(position, 1.0));
    positionCS /= positionCS.w;
#ifdef UNITY_UV_STARTS_AT_TOP
    positionCS.y = -positionCS.y;
#endif
    float2 positionNDC = saturate((positionCS.xy + 1.0) * 0.5);
    float2 positionSS = positionNDC * _ScreenSize.xy;
    
    float viewDepth = RawToViewDepth(positionCS.z, _ZBufferParams);
    
    //float fov = atan(1.0 / _ProjMatrix._22) * 2.0;
    //float radiusPixels = radius / tan(fov * 0.5) * (viewDepth - radius) * _ScreenSize.y * 0.5;
    //float radiusPixels = 1.0 / tan(fov) * radius / sqrt(viewDepth * viewDepth - radius * radius);
    
    int LOD = ceil(log2(radius / viewDepth));
    LOD = min(LOD, 11);
    int2 mipCoord = int2(positionSS) >> LOD;
    int2 mipOffset = _DepthPyramidMipLevelOffsets[LOD];
    int2 depthSampleCoord = mipOffset + mipCoord;
    
    float sampleDepth = _CameraDepthTexture[int3(depthSampleCoord, 0)];
    float sampleViewDepth = RawToViewDepth(sampleDepth, _ZBufferParams);

    return viewDepth > sampleViewDepth;
}

#endif // GOCEAN_OCCLUSION_CULLING