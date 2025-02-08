#ifndef GOCEAN_UNDERWATER_SAMPLING
#define GOCEAN_UNDERWATER_SAMPLING

#define UNDERWATER_MASK_BIT 0x1
#define WATER_SURFACE_MASK_BIT 0x2
#define CACHED_TIME_BIT_MASK 0xFC

#include "GOcean_HelperFunctions.hlsl"

float3 CalculateCaustic(Texture2DArray<float4> spectrumTexture, uint spectrumTextureResolution, Texture2D <float4>noiseTexture, SamplerState linearRepeatSampler,
    float4 spectrumPatchSizes, float3 positionAbsWS, float3 positionAbsWSRot, float causticTiling, float causticDefinition, float causticDistortion)
{
    float slice = 9.0;
    float patchSize = spectrumPatchSizes[0];

    float2 distortionUV = positionAbsWS.xz * causticTiling / patchSize;
    float2 distortion0 = (noiseTexture.SampleLevel(linearRepeatSampler, distortionUV, 0.0).xy - 0.5) * causticDistortion;
    float2 distortion1 = Rotate90DegreesCC(distortion0);
    float2 distortion2 = Rotate180Degrees(distortion0);
    
    float2 causticUV = lerp(positionAbsWS.xz * 4.0, positionAbsWSRot.xy, 0.3);
    causticUV *= causticTiling / patchSize;
    
    float2 causticUV0 = causticUV + distortion0;
    float2 causticUV1 = causticUV + distortion1;
    float2 causticUV2 = causticUV + distortion2;
    
    float uvOffset = 2.0 / (float) spectrumTextureResolution;

    float3 c  = spectrumTexture.SampleLevel(linearRepeatSampler, float3(causticUV, slice), 0.0).xyz;
    float3 r0 = spectrumTexture.SampleLevel(linearRepeatSampler, float3(causticUV0.x + uvOffset, causticUV0.y, slice), 0.0).xyz;
    float3 u0 = spectrumTexture.SampleLevel(linearRepeatSampler, float3(causticUV0.x, causticUV0.y + uvOffset, slice), 0.0).xyz;
    float3 r1 = spectrumTexture.SampleLevel(linearRepeatSampler, float3(causticUV1.x + uvOffset, causticUV1.y, slice), 0.0).xyz;
    float3 u1 = spectrumTexture.SampleLevel(linearRepeatSampler, float3(causticUV1.x, causticUV1.y + uvOffset, slice), 0.0).xyz;
    float3 r2 = spectrumTexture.SampleLevel(linearRepeatSampler, float3(causticUV2.x + uvOffset, causticUV2.y, slice), 0.0).xyz;
    float3 u2 = spectrumTexture.SampleLevel(linearRepeatSampler, float3(causticUV2.x, causticUV2.y + uvOffset, slice), 0.0).xyz;
    
    float3 caustic;
    caustic.x = abs(c.x - r0.x) + abs(c.y - r0.y) + abs(c.x - u0.x) + abs(c.y - u0.y);
    caustic.y = abs(c.x - r1.x) + abs(c.y - r1.y) + abs(c.x - u1.x) + abs(c.y - u1.y);
    caustic.z = abs(c.x - r2.x) + abs(c.y - r2.y) + abs(c.x - u2.x) + abs(c.y - u2.y);

    caustic = 1.0 / (caustic + 1.0);
    caustic = pow(caustic, causticDefinition);
    
    return caustic;
}

float3 CalculateCaustic(Texture2DArray<float4> spectrumTexture, uint spectrumTextureResolution, Texture2D<float4> noiseTexture, SamplerState linearRepeatSampler,
    float4 spectrumPatchSizes, float3x3 lightRotationMatrix, float3 positionAbsWS, float causticTiling, float causticDefinition, float causticDistortion)
{
    float3 positionAbsWSRot = mul(lightRotationMatrix, positionAbsWS);
    return CalculateCaustic(spectrumTexture, spectrumTextureResolution, noiseTexture, linearRepeatSampler,
        spectrumPatchSizes, positionAbsWS, positionAbsWSRot, causticTiling, causticDefinition, causticDistortion);
}

float3 CalculateCaustic(Texture2DArray<float4> spectrumTexture, uint spectrumTextureResolution, Texture2D<float4> noiseTexture, SamplerState linearRepeatSampler,
    float4 spectrumPatchSizes, float3x3 lightRotationMatrix, float3 positionAbsWS, float causticTiling, float causticDefinition, float causticDistortion, bool underwaterMask)
{
    lightRotationMatrix._23 = underwaterMask ? lightRotationMatrix._23 : -lightRotationMatrix._23;
    float3 positionAbsWSRot = mul(lightRotationMatrix, positionAbsWS);
    return CalculateCaustic(spectrumTexture, spectrumTextureResolution, noiseTexture, linearRepeatSampler,
        spectrumPatchSizes, positionAbsWS, positionAbsWSRot, causticTiling, causticDefinition, causticDistortion);
}

float CalculateCausticMask(float3 normalWS, float3 positionAbsWS, float3 lightForward, bool waterMask, bool underwaterMask, float waterHeight, Texture2DArray<float4> spectrumTexture,
    float4 spectrumPatchSizes, SamplerState linearRepeatSampler, float causticFadeDepth, float causticAboveWaterFadeDistance, float causticStrength, float shadowSample)
{
    bool causticMaskBelow = waterMask != underwaterMask;
    bool causticMaskAbove = !causticMaskBelow;
    
    float heightDelta = waterHeight + spectrumTexture.SampleLevel(linearRepeatSampler, float3(positionAbsWS.xz / spectrumPatchSizes[0], 0.0), 0.0).y - positionAbsWS.y;
    
    float normalDotUp = saturate(dot(normalWS, float3(0.0, 1.0, 0.0)) * 0.5 + 0.5);
    
    float t = 1.0 - saturate(heightDelta / min(10.0 + normalDotUp * 30.0, causticFadeDepth));
    t *= t;
    
    float normalMaskBelow = lerp(saturate(-dot(normalWS, lightForward) * 0.5 + 0.5), normalDotUp, t);
    float normalMaskAbove = 1.0 - normalDotUp;
    
    float shadowMask = lerp(shadowSample, 1.0, t);
    
    float heightFade = heightDelta / (causticMaskBelow ? causticFadeDepth : -causticAboveWaterFadeDistance);
    heightFade = saturate(1.0 - heightFade);
    heightFade *= heightFade;

    float maskAbove = (float) causticMaskAbove * causticStrength * normalMaskAbove * heightFade * 0.25;
    float maskBelow = (float) causticMaskBelow * causticStrength * normalMaskBelow * heightFade * shadowMask;
    float mask = causticMaskBelow ? maskBelow : maskAbove;
    
    return mask;
}

float GetCausticHeightFade(float3 position, float waterHeight, float heightFadeDistance)
{
    float fade = saturate(1.0 - (waterHeight - position.y) / heightFadeDistance);
    return fade * fade;
}

float GetLightRayHeightFade(float3 position, float waterHeight, float heightFadeDistance)
{
    return GetCausticHeightFade(position, waterHeight, heightFadeDistance);
}

float GetLightRayFadeIn(float startDepth, float viewDepth, float lightRayFadeInDistance)
{
    float fadeIn = saturate((viewDepth - startDepth) / lightRayFadeInDistance);
    return fadeIn * fadeIn;
}

float GetLightRayFadeIn(float startDepth, float viewDepth, float lightRayFadeInDistance, float bias)
{
    return GetLightRayFadeIn(startDepth, viewDepth + bias, lightRayFadeInDistance);
}

float GetUnderwaterDistanceFade(float viewDepth, float fadeDistance)
{
    float distanceFade = saturate(1.0 - viewDepth / fadeDistance);
    distanceFade *= distanceFade;
    distanceFade *= distanceFade;
    return distanceFade;
}

float3 CalculateUnderwaterFogColor(float3 underwaterFogColor, float3 skyColor, float3 currentExposureMultiplier)
{
    float3 exposedSkyColor = skyColor * currentExposureMultiplier;
    float luminance = saturate(1.0 - CalculateLuminance(exposedSkyColor));
    luminance *= luminance;
    luminance *= luminance;
    luminance = 1.0 - luminance;
    luminance *= 0.5;
    return 1.0 - (1.0 - luminance * underwaterFogColor) * (1.0 - exposedSkyColor);
}

uint EncodeMasks(float underwaterMask, float waterSurfaceMask)
{
    // first bit is flipped facing (1 underwater)
    // second bit is always 1 anywhere water renders
    // screen texture is R8 uint
    
    return
        (underwaterMask > 0.0 ? UNDERWATER_MASK_BIT : 0x0) |
        (waterSurfaceMask > 0.0 ? WATER_SURFACE_MASK_BIT : 0x0);

}

uint EncodeMasks(bool underwaterMask, bool waterSurfaceMask)
{
    // first bit is flipped facing (1 underwater)
    // second bit is always 1 anywhere water renders
    // screen texture is R8 uint
    
    return
        (underwaterMask ? UNDERWATER_MASK_BIT : 0x0) |
        (waterSurfaceMask ? WATER_SURFACE_MASK_BIT : 0x0);
}

bool GetUnderwaterMask(uint oceanScreenTextureSample)
{
    return (oceanScreenTextureSample & UNDERWATER_MASK_BIT) > 0x0;
}

bool GetWaterSurfaceMask(uint oceanScreenTextureSample)
{
    return (oceanScreenTextureSample & WATER_SURFACE_MASK_BIT) > 0x0;
}

void EncodeCachedTime(uint cachedTime, inout uint oceanScreenTextureSample)
{
    // clear screen water bits
    oceanScreenTextureSample &= (~CACHED_TIME_BIT_MASK);
    
    // set bits
    oceanScreenTextureSample |= (cachedTime << 2);
}

uint ExtractCachedTime(uint oceanScreenTextureSample)
{
    return oceanScreenTextureSample >> 2;
}

// ShaderGraph

void GetUnderwaterDistanceFade_float(float viewDepth, float fadeDistance, out float distanceFade)
{
    distanceFade = GetUnderwaterDistanceFade(viewDepth, fadeDistance);
}

void GetUnderwaterMask_float(uint oceanScreenTextureSample, out bool underwaterMask)
{
    underwaterMask = GetUnderwaterMask(oceanScreenTextureSample);
}

void GetWaterSurfaceMask_float(uint oceanScreenTextureSample, out bool waterSurfaceMask)
{
    waterSurfaceMask = GetWaterSurfaceMask(oceanScreenTextureSample);
}

#endif // GOCEAN_UNDERWATER_SAMPLING