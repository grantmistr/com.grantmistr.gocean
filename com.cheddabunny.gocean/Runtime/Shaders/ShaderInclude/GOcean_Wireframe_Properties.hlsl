#ifndef GOCEAN_WIREFRAME_PROPERTIES
#define GOCEAN_WIREFRAME_PROPERTIES

struct v2f
{
    float4 vertex : SV_Position;
    float2 barycentricCoord : TEXCOORD0;
};

#include "GOcean_HDRP_ShaderVariablesGlobal.hlsl"

#endif // GOCEAN_WIREFRAME_PROPERTIES