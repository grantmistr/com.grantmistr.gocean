#ifndef GOCEAN_STOCHASTIC_SAMPLING
#define GOCEAN_STOCHASTIC_SAMPLING

#define GRID_TO_SKEWED_GRID float2x2(1.0, 0.0, -0.5773502, 1.1547)
#define HASH_2D_MATRIX float2x2(127.1, 311.7, 269.5, 183.3)

float2 Hash2D(float2 v)
{
    return frac(sin(mul(HASH_2D_MATRIX, v)) * 43758.54);
}

float4 StochasticSample(Texture2D t, SamplerState s, float2 uv)
{
    float w1, w2, w3;
    float2 v1, v2, v3;
    
    float2 skewedUV = mul(GRID_TO_SKEWED_GRID, uv * 3.464101);
    
    float2 baseID = floor(skewedUV);
    float3 bary = float3(frac(skewedUV), 0.0);
    bary.z = 1.0 - bary.x - bary.y;
    
    bool test = bary.z > 0.0;
    
    w1 = test ? bary.z : -bary.z;
    w2 = test ? bary.y : 1.0 - bary.y;
    w3 = test ? bary.x : 1.0 - bary.x;
    
    float2 b0 = baseID;
    float2 b1 = b0 + float2(1.0, 1.0);
    float2 b2 = b0 + float2(1.0, 0.0);
    float2 b3 = b0 + float2(0.0, 1.0);
    
    v1 = test ? b0 : b1;
    v2 = test ? b3 : b2;
    v3 = test ? b2 : b3;
    
    float2 uv1 = uv + Hash2D(v1);
    float2 uv2 = uv + Hash2D(v2);
    float2 uv3 = uv + Hash2D(v3);
    
    float2 dxUV = ddx(uv);
    float2 dyUV = ddy(uv);
    
    float4 t_s1 = t.SampleGrad(s, uv1, dxUV, dyUV);
    float4 t_s2 = t.SampleGrad(s, uv2, dxUV, dyUV);
    float4 t_s3 = t.SampleGrad(s, uv3, dxUV, dyUV);
    
    float4 output = w1 * t_s1 + w2 * t_s2 + w3 * t_s3;
    return output;
}

float4 StochasticSample(Texture2DArray t, SamplerState s, float2 uv, float slice)
{
    float w1, w2, w3;
    float2 v1, v2, v3;
    
    float2 skewedUV = mul(GRID_TO_SKEWED_GRID, uv * 3.464101);
    
    float2 baseID = floor(skewedUV);
    float3 bary = float3(frac(skewedUV), 0.0);
    bary.z = 1.0 - bary.x - bary.y;
    
    bool test = bary.z > 0.0;
    
    w1 = test ? bary.z : -bary.z;
    w2 = test ? bary.y : 1.0 - bary.y;
    w3 = test ? bary.x : 1.0 - bary.x;
    
    float2 b0 = baseID;
    float2 b1 = b0 + float2(1.0, 1.0);
    float2 b2 = b0 + float2(1.0, 0.0);
    float2 b3 = b0 + float2(0.0, 1.0);
    
    v1 = test ? b0 : b1;
    v2 = test ? b3 : b2;
    v3 = test ? b2 : b3;
    
    float2 uv1 = uv + Hash2D(v1);
    float2 uv2 = uv + Hash2D(v2);
    float2 uv3 = uv + Hash2D(v3);
    
    float2 dxUV = ddx(uv);
    float2 dyUV = ddy(uv);
    
    float4 t_s1 = t.SampleGrad(s, float3(uv1, slice), dxUV, dyUV);
    float4 t_s2 = t.SampleGrad(s, float3(uv2, slice), dxUV, dyUV);
    float4 t_s3 = t.SampleGrad(s, float3(uv3, slice), dxUV, dyUV);
    
    float4 output = w1 * t_s1 + w2 * t_s2 + w3 * t_s3;
    return output;
}

float4 StochasticSampleLevel(Texture2D t, SamplerState s, float2 uv, float lod)
{
    float w1, w2, w3;
    float2 v1, v2, v3;
    
    float2 skewedUV = mul(GRID_TO_SKEWED_GRID, uv * 3.464101);
    
    float2 baseID = floor(skewedUV);
    float3 bary = float3(frac(skewedUV), 0.0);
    bary.z = 1.0 - bary.x - bary.y;
    
    bool test = bary.z > 0.0;
    
    w1 = test ? bary.z : -bary.z;
    w2 = test ? bary.y : 1.0 - bary.y;
    w3 = test ? bary.x : 1.0 - bary.x;
    
    float2 b0 = baseID;
    float2 b1 = b0 + float2(1.0, 1.0);
    float2 b2 = b0 + float2(1.0, 0.0);
    float2 b3 = b0 + float2(0.0, 1.0);
    
    v1 = test ? b0 : b1;
    v2 = test ? b3 : b2;
    v3 = test ? b2 : b3;
    
    float2 uv1 = uv + Hash2D(v1);
    float2 uv2 = uv + Hash2D(v2);
    float2 uv3 = uv + Hash2D(v3);
    
    float4 t_s1 = t.SampleLevel(s, uv1, lod);
    float4 t_s2 = t.SampleLevel(s, uv2, lod);
    float4 t_s3 = t.SampleLevel(s, uv3, lod);
    
    float4 output = w1 * t_s1 + w2 * t_s2 + w3 * t_s3;
    return output;
}

float4 StochasticSampleLevel(Texture2DArray t, SamplerState s, float2 uv, float slice, float lod)
{
    float w1, w2, w3;
    float2 v1, v2, v3;
    
    float2 skewedUV = mul(GRID_TO_SKEWED_GRID, uv * 3.464101);
    
    float2 baseID = floor(skewedUV);
    float3 bary = float3(frac(skewedUV), 0.0);
    bary.z = 1.0 - bary.x - bary.y;
    
    bool test = bary.z > 0.0;
    
    w1 = test ? bary.z : -bary.z;
    w2 = test ? bary.y : 1.0 - bary.y;
    w3 = test ? bary.x : 1.0 - bary.x;
    
    float2 b0 = baseID;
    float2 b1 = b0 + float2(1.0, 1.0);
    float2 b2 = b0 + float2(1.0, 0.0);
    float2 b3 = b0 + float2(0.0, 1.0);
    
    v1 = test ? b0 : b1;
    v2 = test ? b3 : b2;
    v3 = test ? b2 : b3;
    
    float2 uv1 = uv + Hash2D(v1);
    float2 uv2 = uv + Hash2D(v2);
    float2 uv3 = uv + Hash2D(v3);
    
    float4 t_s1 = t.SampleLevel(s, float3(uv1, slice), lod);
    float4 t_s2 = t.SampleLevel(s, float3(uv2, slice), lod);
    float4 t_s3 = t.SampleLevel(s, float3(uv3, slice), lod);
    
    float4 output = w1 * t_s1 + w2 * t_s2 + w3 * t_s3;
    return output;
}

// Shader Graph Methods

void StochasticSampleTex2DArray_float(Texture2DArray t, SamplerState s, float2 uv, float slice, out float4 output)
{
    output = StochasticSample(t, s, uv, slice);
}

#endif // GOCEAN_STOCHASTIC_SAMPLING