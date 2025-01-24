#ifndef GOCEAN_TERRAIN_HEIGHTMAP_PROPERTIES
#define GOCEAN_TERRAIN_HEIGHTMAP_PROPERTIES

Texture2DArray<float> _TerrainHeightmapArrayTexture;
SamplerState sampler_TerrainHeightmapArrayTexture;
Texture2DArray<float4> _TerrainShoreWaveArrayTexture;
SamplerState sampler_TerrainShoreWaveArrayTexture;

float4  _TerrainPosScaledBounds;
float3  _TerrainSize;
float   _UVMultiplier, _WaveDisplacementFade, _ShoreWaveHeight;

uint    _TerrainLookupResolution;

#endif // GOCEAN_TERRAIN_HEIGHTMAP_PROPERTIES