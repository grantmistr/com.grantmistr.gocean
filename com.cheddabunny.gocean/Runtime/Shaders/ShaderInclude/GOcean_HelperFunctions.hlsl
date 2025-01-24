#ifndef GOCEAN_HELPERFUNCTIONS
#define GOCEAN_HELPERFUNCTIONS

#ifndef PI
#define PI 3.1415926538
#endif

#define TAU PI * 2.0
#define SQRT_2 1.4142135624
#define ONE_OVER_SQRT_2 0.70710678118

const static float3x3 M_3x3_identity = {
    1, 0, 0,
    0, 0, 1,
    0, 1, 0 };

float Random(float2 uv)
{
    return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
}

float Random(float x)
{
    return frac(sin(x * 37.0) * 104003.9);
}

float Random(int x)
{
    x &= int(0x7FFFFFFF);
    return Random(float(x));
}

float Random(uint x)
{
    x &= uint(0x7FFFFFFF);
    return Random(float(x));
}

uint wang_hash(uint seed)
{
    seed = (seed ^ 61) ^ (seed >> 16);
    seed *= 9;
    seed = seed ^ (seed >> 4);
    seed *= 0x27d4eb2d;
    seed = seed ^ (seed >> 15);
    
    return seed;
}

// https://stackoverflow.com/a/3380723
float FastArcCos(float x)
{
    return (-0.69813170079773212 * x * x - 0.87266462599716477) * x + 1.5707963267948966;
}

float2 CartesianToPolar(float2 coord)
{
    float r = length(coord);
    
    float2 n = coord;
    n.x = r == 0.0 ? 1.0 : n.x;
    n = normalize(n);
    
    return float2(r, atan2(n.y, n.x));
}

float3 NormalBlend(float3 n1, float3 n2)
{
    return normalize(float3(n1.x + n2.x, n1.y + n2.y, n1.z));
}

float3 NormalStrength(float3 normal, float strength)
{
    normal.xy *= strength;
    normal.z = lerp(1.0, normal.z, saturate(strength));
    return normal;
}

float3 GetNormalFromPackedNormal(float4 t)
{
    float3 normal;
    normal.xy = t.wy * 2.0 - 1.0;
    normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
    
    return normal;
}

float WorldPosToRawDepth(float3 position, float4x4 viewProjMatrix)
{
    float4 clipSpacePos = mul(viewProjMatrix, float4(position, 1.0));
    return clipSpacePos.z / clipSpacePos.w;
}

bool IsInSquare(float2 squarePos, float squareWidth, float2 p)
{
    p = abs(squarePos - p);
    float halfWidth = squareWidth * 0.5;

    return p.x < halfWidth && p.y < halfWidth;
}

float3x3 ConstructTangentToWorldMatrix(float3 normal, float3 tangent, float3 biTangent)
{
    float3x3 m = float3x3(
        tangent.x, biTangent.x, normal.x,
        tangent.y, biTangent.y, normal.y,
        tangent.z, biTangent.z, normal.z
    );
    
    return m;
}

float3x3 ConstructTangentToWorldMatrix(float3 normal)
{
    float3 tangent = normalize(cross(normal, float3(1.0, 0.0, 0.0)));
    float3 biTangent = normalize(cross(normal, tangent));
    
    return ConstructTangentToWorldMatrix(normal, tangent, biTangent);
}

float3x3 ConstructTangentToWorldMatrix(float3 normal, float3 tangent)
{
    float3 biTangent = normalize(cross(normal, tangent));
    
    return ConstructTangentToWorldMatrix(normal, tangent, biTangent);
}

float2 Rotate180Degrees(float2 v)
{
    v.x = -v.x;
    v.y = -v.y;
    
    return v;
}

float2 Rotate90DegreesCC(float2 v)
{
    float t = v.x;
    v.x = -v.y;
    v.y = t;
    
    return v;
}

float2 Rotate90DegreesCW(float2 v)
{
    float t = v.y;
    v.y = -v.x;
    v.x = t;
    
    return v;
}

float2 RotateVector2(float2 v, float theta)
{
    float c, s;
    sincos(theta, s, c);
    
    float x = v.x * c - v.y * s;
    float y = v.x * s + v.y * c;

    return float2(x, y);
}

float InverseLerp(float a, float b, float t)
{
    return (t - a) / (b - a);
}

float LengthSquared(float2 v)
{
    return v.x * v.x + v.y * v.y;
}

float LengthSquared(float3 v)
{
    return v.x * v.x + v.y * v.y + v.z * v.z;
}

float DistanceSquared(uint2 id, float2 center)
{
    return LengthSquared(center - (float2) id);
}

float DistanceSquared(float2 v1, float2 v2)
{
    return LengthSquared(v1 - v2);
}

float DistanceSquared(float3 v1, float3 v2)
{
    return LengthSquared(v1 - v2);
}

float RawToViewDepth(float depth, float4 zBufferParams)
{
    return 1.0 / (zBufferParams.z * depth + zBufferParams.w);
}

float ViewToRawDepth(float depth, float4 zBufferParams)
{
    return (1.0 - depth * zBufferParams.w) / (depth * zBufferParams.z);
}

float CalculateLuminance(float3 color)
{
    return 0.2126 * color.x + 0.7152 * color.y + 0.0722 * color.z;
}

float2x2 GetRotationMatrixWithAspectRatio(float theta, float aspect)
{
    float c, s;
    sincos(theta, s, c);
    
    return float2x2(c, s / aspect, -aspect * s, c);
}

float NoNegativeMod(float v, float x)
{
    v = fmod(v, x);
    v = v < 0.0 ? v + x : v;
    
    return v;
}

float2 NoNegativeMod(float2 v, float x)
{
    v.x = NoNegativeMod(v.x, x);
    v.y = NoNegativeMod(v.y, x);

    return v;
}

int NoNegativeMod(int v, int x)
{
    v %= x;
    v < 0 ? v + x : v;
    
    return v;
}

int2 NoNegativeMod(int2 v, int x)
{
    v.x = NoNegativeMod(v.x, x);
    v.y = NoNegativeMod(v.y, x);

    return v;
}

float3 GetSpectrumNormal(float x, float z)
{
    float y = sqrt(1.0 - x * x - z * z);
    return float3(x, y, z);
}

float4 GetFullScreenTriVertexPosition(uint vertexID, float nearClipValue)
{
    // note: the triangle vertex position coordinates are x2 so the returned UV coordinates are in range -1, 1 on the screen.
    float2 uv = float2((vertexID << 1) & 2, vertexID & 2);
    float4 pos = float4(uv * 2.0 - 1.0, nearClipValue, 1.0);
    return pos;
}

float4 EncodeFloatRGBA(float v)
{
    float4 enc = v;
    [unroll]
    for (int i = 0; i < 3; i++)
    {
        enc[i + 1] = modf(enc[i] * 255.0, enc[i]);
    }
    enc.w = floor(enc.w * 255.0);
    
    return enc;
}

float DecodeFloatRGBA(float4 rgba)
{
    return dot(rgba, float4(0.0039215686274509803921568627451, 0.0000153787004998077662437524029, 0.0000000603086294110108480147153, 0.0000000002365044290627876392733));
}

float3 EncodeFloatRGB(float v)
{
    float3 enc = v;
    [unroll]
    for (int i = 0; i < 2; i++)
    {
        enc[i + 1] = modf(enc[i] * 255.0, enc[i]);
    }
    enc.z = floor(enc.z * 255.0);
    
    return enc;
}

float DecodeFloatRGB(float3 rgb)
{
    return dot(rgb, float3(0.0039215686274509803921568627451, 0.0000153787004998077662437524029, 0.0000000603086294110108480147153));
}

float2 GetDepthTextureSamplingCoords(int2 coord, int LOD, float4 texelSize, StructuredBuffer<int2> depthPyramidMipLevelOffsets)
{
    int2 mipOffset = depthPyramidMipLevelOffsets[LOD];
    
    float2 normalizedCoord = coord * texelSize.xy;
    normalizedCoord /= (float) (1 << LOD);
    normalizedCoord += (float2) mipOffset * texelSize.xy;
    
    return normalizedCoord;
}

// Shadergraph

void RawToViewDepth_float(float depth, float4 zBufferParams, out float viewDepth)
{
    viewDepth = RawToViewDepth(depth, zBufferParams);
}

void ViewToRawDepth_float(float depth, float4 zBufferParams, out float rawDepth)
{
    rawDepth = ViewToRawDepth(depth, zBufferParams);
}

void GetDepthTextureSamplingCoords_float(int2 coord, int LOD, float4 texelSize, StructuredBuffer<int2> depthPyramidMipLevelOffsets, out float2 normalizedCoord)
{
    int2 mipOffset = depthPyramidMipLevelOffsets[LOD];
    
    normalizedCoord = coord * texelSize.xy;
    normalizedCoord /= (float) (1 << LOD);
    normalizedCoord += (float2) mipOffset * texelSize.xy;
}

#endif // GOCEAN_HELPERFUNCTIONS