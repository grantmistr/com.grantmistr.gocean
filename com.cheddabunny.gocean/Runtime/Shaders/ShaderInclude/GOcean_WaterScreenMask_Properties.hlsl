#ifndef GOCEAN_WATERSCREENMASK_PROPERTIES
#define GOCEAN_WATERSCREENMASK_PROPERTIES

#include "GOcean_Constants.hlsl"
#include "GOcean_HDRP_ShaderVariablesGlobal.hlsl"
#include "GOcean_GlobalTextures.hlsl"

const static int blurIterations = 11;
const static int blurOffset = blurIterations >> 1;
const static float depthDeltaThresholdMultiplier = 0.01;

const static float weights[blurIterations] =
{
    0.0088122293, 0.027143577, 0.065114057, 0.12164907, 0.17699836, 0.20056541, 0.17699836, 0.12164907, 0.065114057, 0.027143577, 0.0088122293
};

Texture2DArray<float> _CameraDepthTexture;

float _ClearValue;
int _ChunkGridResolution, _ChunkSize;

#endif // GOCEAN_WATERSCREENMASK_PROPERTIES