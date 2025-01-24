#ifndef GOCEAN_CAMERA_DEPTH_DEFINES
#define GOCEAN_CAMERA_DEPTH_DEFINES

StructuredBuffer<int2> _DepthPyramidMipLevelOffsets;
Texture2DArray<float> _CameraDepthTexture;

#endif // GOCEAN_CAMERA_DEPTH_DEFINES