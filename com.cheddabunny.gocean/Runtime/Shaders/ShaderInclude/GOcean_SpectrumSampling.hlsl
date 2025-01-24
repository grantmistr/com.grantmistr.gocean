#ifndef GOCEAN_SPECTRUM_SAMPLING
#define GOCEAN_SPECTRUM_SAMPLING

#include "GOcean_TerrainHeightmapProperties.hlsl"
#include "GOcean_TerrainHeightmapSampling.hlsl"
#include "GOcean_Constants.hlsl"
#include "GOcean_HelperFunctions.hlsl"

float Dispersion(float waveCount, float gravity)
{
    return sqrt(gravity * waveCount);
}

float DispersionDerivitive(float waveCount, float gravity)
{
    return 1.0 / (2.0 * sqrt(gravity * waveCount));
}

float CalculateWindFactor(float2 waveDirection, float frequency, float2 windDirection, float turbulence)
{
    float windFactor = -dot(windDirection, waveDirection);
    windFactor *= windFactor < 0.0 ? 0.5 : 1.0;
    windFactor = windFactor * windFactor * windFactor * windFactor * windFactor * windFactor;
    windFactor = lerp(windFactor, 1.0, saturate(frequency / (1.1 - turbulence) * turbulence));
    
    return windFactor;
}

float Phillips(float frequency, float amplitude, float gravity, float windSpeed)
{
    float w2 = frequency * frequency;
    float w4 = w2 * w2;
    float largestWave = windSpeed * windSpeed / gravity;
    largestWave *= largestWave;
    
    return sqrt(amplitude * exp(-1.0 / (w2 * largestWave)) / w4) * ONE_OVER_SQRT_2;
}

float Phillips(float2 waveDirection, float frequency, float amplitude, float gravity, float2 windDirection, float windSpeed, float turbulence)
{
    float w2 = frequency * frequency;
    float w4 = w2 * w2;
    float largestWave = windSpeed * windSpeed / gravity;
    largestWave *= largestWave;
    
    float windFactor = CalculateWindFactor(waveDirection, frequency, windDirection, turbulence);
    
    return sqrt(amplitude * exp(-1.0 / (w2 * largestWave)) / w4 * windFactor) * ONE_OVER_SQRT_2;
}

float Phillips(uint3 id, int spectrumTextureResolution, float4 patchSize, float4 patchLowestWaveCount, float4 patchHighestWaveCount,
    float amplitude, float gravity, float2 windDirection, float windSpeed, float turbulence)
{
    float2 gridPoint = float2(id.xy) - float(spectrumTextureResolution >> 1);
    float2 waveVector = (gridPoint * TAU) / patchSize[id.z];
    float2 waveDirection = normalize(waveVector);
    float frequency = length(waveVector);

    if (frequency < patchLowestWaveCount[id.z] || frequency > patchHighestWaveCount[id.z])
    {
        return 0.0;
    }
    
    return Phillips(waveDirection, frequency, amplitude, gravity, windDirection, windSpeed, turbulence);
}

float4 GetDisplacedPosition(Texture2DArray<float4> spectrumTexture, SamplerState linearRepeatSampler, float2 position, TerrainSamplingData terrainSamplingData)
{
    return spectrumTexture.SampleLevel(linearRepeatSampler, float3(position, 0.0), 0.0);
}

#endif // GOCEAN_SPECTRUM_SAMPLING