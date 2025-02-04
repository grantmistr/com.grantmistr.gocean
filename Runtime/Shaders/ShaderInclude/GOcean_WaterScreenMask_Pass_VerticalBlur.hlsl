#ifndef GOCEAN_WATERSCREENMASK_PASS_VERTICALBLUR
#define GOCEAN_WATERSCREENMASK_PASS_VERTICALBLUR

#include "GOcean_WaterScreenMask_Properties.hlsl"
#include "GOcean_HelperFunctions.hlsl"

float4 vert(uint vertexID : SV_VertexID) : SV_Position
{
    return GetFullScreenTriVertexPosition(vertexID, GetNearClipValue());
}

float2 frag(float4 input : SV_Position) : SV_Target
{
    int2 sampleCoord = (int2) input.xy;
    int2 maxCoord = ((int2) _ScreenSize.xy) - 1;
    float4 screenTextureSample = _TemporaryColorTexture[sampleCoord];
    float lightRays = screenTextureSample.z;
    float opaqueDepth = _CameraDepthTexture[uint3(sampleCoord, 0)];
    float waterDepth = _WaterDepthTexture[sampleCoord];
#ifdef UNITY_REVERSED_Z
    float depth = max(opaqueDepth, waterDepth);
#else
    float depth = min(opaqueDepth, waterDepth);
#endif
    float viewDepth = RawToViewDepth(depth, _ZBufferParams);
    
    float2 sum = float2(0.0, 0.0);
    
    [unroll]
    for (int i = 0; i < blurIterations; i++)
    {
        int2 c = sampleCoord;
        c.y += i - blurOffset;
        c.y = clamp(c.y, 0, maxCoord.y);
        
        float2 s = _TemporaryColorTexture[c].zw;
        
        float opaqueDepth0 = _CameraDepthTexture[uint3(c, 0)];
        float waterDepth0 = _WaterDepthTexture[c];
#ifdef UNITY_REVERSED_Z
        float depth0 = max(opaqueDepth0, waterDepth0);
#else
        float depth0 = min(opaqueDepth0, waterDepth0);
#endif
        float viewDepth0 = RawToViewDepth(depth0, _ZBufferParams);
        
        s.x = lerp(s.x, lightRays, saturate(abs(viewDepth - viewDepth0) / (depthDeltaThresholdMultiplier * viewDepth0 * viewDepth0)));
        
        sum += s * weights[i];
    }
    
    // write to temp blur tex
    return sum;
}

#endif // GOCEAN_WATERSCREENMASK_PASS_VERTICALBLUR