#ifndef GOCEAN_TEXTURE_SAMPLERS
#define GOCEAN_TEXTURE_SAMPLERS

SamplerState sampler_Point_Repeat
{
    Filter = MIN_MAG_MIP_Point;
    AddressU = Wrap;
    AddressV = Wrap;
};

SamplerState sampler_Point_Clamp
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU = Clamp;
    AddressV = Clamp;
};

SamplerState sampler_Linear_Repeat
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

SamplerState sampler_Linear_Clamp
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp;
};

#endif // GOCEAN_TEXTURE_SAMPLERS