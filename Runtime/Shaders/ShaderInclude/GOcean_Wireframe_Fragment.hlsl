#ifndef GOCEAN_WIREFRAME_FRAGMENT
#define GOCEAN_WIREFRAME_FRAGMENT

#include "GOcean_Wireframe_Properties.hlsl"

float4 frag(v2f i) : SV_Target
{
    float edge = 1.0 - i.barycentricCoord.x - i.barycentricCoord.y;
    edge = min(edge, i.barycentricCoord.x);
    edge = min(edge, i.barycentricCoord.y);
    
    //float alpha = edge < (fwidth(edge) * 0.2);
    
    float alpha = saturate(fwidth(edge) * 0.5 - edge);
    alpha = pow(alpha, 0.2);
    
    return float4(0.0, 0.0, 0.0, alpha);
}

#endif // GOCEAN_WIREFRAME_FRAGMENT