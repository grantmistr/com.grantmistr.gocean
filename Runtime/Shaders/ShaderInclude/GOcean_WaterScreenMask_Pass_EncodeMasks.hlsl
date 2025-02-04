#ifndef GOCEAN_WATERSCREENMASK_PASS_ENCODEMASKS
#define GOCEAN_WATERSCREENMASK_PASS_ENCODEMASKS

#include "GOcean_WaterScreenMask_Properties.hlsl"
#include "GOcean_HelperFunctions.hlsl"
#include "GOcean_UnderwaterSampling.hlsl"

float4 vert(uint vertexID : SV_VertexID) : SV_Position
{
    return GetFullScreenTriVertexPosition(vertexID, GetNearClipValue());
}

uint frag(float4 positionSS : SV_Position) : SV_Target
{
    float4 s = _TemporaryColorTexture[positionSS.xy];
    bool underwaterMask = s.z > 0.0;
    bool waterSurfaceMask = s.w > 0.0;
    bool distantWaterSurfaceMask = s.w < 0.0;
    
    // remove holes //
    
    float4 D = _TemporaryColorTexture[int2(positionSS.x, positionSS.y - 2)];
    float4 U = _TemporaryColorTexture[int2(positionSS.x, positionSS.y + 2)];
    
    bool invalid = ((underwaterMask != D.z) && (underwaterMask != U.z));
    underwaterMask = invalid ? !underwaterMask : underwaterMask;
    
    //invalid = ((waterSurfaceMask != D.w) && (waterSurfaceMask != U.w));
    //waterSurfaceMask = invalid && (!distantWaterSurfaceMask) ? !waterSurfaceMask : waterSurfaceMask;
    //
    //invalid = ((distantWaterSurfaceMask != D.w) && (distantWaterSurfaceMask != U.w));
    //distantWaterSurfaceMask = invalid && (!waterSurfaceMask) ? !distantWaterSurfaceMask : distantWaterSurfaceMask;
    
    // ------------ //
    
    return EncodeMasks(underwaterMask, waterSurfaceMask, distantWaterSurfaceMask);
}

#endif