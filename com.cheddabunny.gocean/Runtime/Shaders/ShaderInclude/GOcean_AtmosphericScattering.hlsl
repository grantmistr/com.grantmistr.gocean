#ifndef GOCEAN_ATMOSPHERIC_SCATTERING
#define GOCEAN_ATMOSPHERIC_SCATTERING

// Copied and slightly modified the functions from AtmosphericScattering.hlsl and Material.hlsl

// Returns false when fog is not applied
bool EvaluateAtmosphericScattering_GOcean(PositionInputs posInput, float3 V, out float3 color, out float3 opacity)
{
    color = opacity = 0;

#ifdef DEBUG_DISPLAY
    // Don't sample atmospheric scattering when lighting debug more are enabled so fog is not visible
    if (_DebugLightingMode == DEBUGLIGHTINGMODE_MATCAP_VIEW || (_DebugLightingMode >= DEBUGLIGHTINGMODE_DIFFUSE_LIGHTING && _DebugLightingMode <= DEBUGLIGHTINGMODE_EMISSIVE_LIGHTING))
        return false;

    if (_DebugShadowMapMode == SHADOWMAPDEBUGMODE_SINGLE_SHADOW || _DebugLightingMode == DEBUGLIGHTINGMODE_LUX_METER || _DebugLightingMode == DEBUGLIGHTINGMODE_LUMINANCE_METER)
        return false;

    if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
        return false;
#endif

    // Convert depth to distance along the ray. Doesn't work with tilt shift, etc.
    // When a pixel is at far plane, the world space coordinate reconstruction is not reliable.
    // So in order to have a valid position (for example for height fog) we just consider that the sky is a sphere centered on camera with a radius of 5km (arbitrarily chosen value!)
    float tFrag = posInput.linearDepth * rcp(dot(-V, GetViewForwardDir()));

    // Analytic fog starts where volumetric fog ends
    float volFogEnd = 0.0f;

    if (_FogEnabled)
    {
        float4 volFog = float4(0.0, 0.0, 0.0, 0.0);

        if (_EnableVolumetricFog != 0)
        {
            bool doBiquadraticReconstruction = _VolumetricFilteringEnabled == 0; // Only if filtering is disabled.
            float4 value = SampleVBuffer(TEXTURE3D_ARGS(_VBufferLighting, s_linear_clamp_sampler),
                                         posInput.positionNDC,
                                         tFrag,
                                         _VBufferViewportSize,
                                         _VBufferLightingViewportScale.xyz,
                                         _VBufferLightingViewportLimit.xyz,
                                         _VBufferDistanceEncodingParams,
                                         _VBufferDistanceDecodingParams,
                                         true, doBiquadraticReconstruction, false);

            // TODO: add some slowly animated noise (dither?) to the reconstructed value.
            // TODO: re-enable tone mapping after implementing pre-exposure.
            volFog = DelinearizeRGBA(float4(/*FastTonemapInvert*/(value.rgb), value.a));
            volFogEnd = _VBufferLastSliceDist;
        }

        float distDelta = tFrag - volFogEnd;
        if (distDelta > 0)
        {
            // Apply the distant (fallback) fog.
            float cosZenith = -dot(V, _PlanetUp);

            float startHeight = volFogEnd * cosZenith;
            
#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING == 0)
            startHeight += _CameraAltitude;
#endif

            float3 volAlbedo = _HeightFogBaseScattering.xyz / _HeightFogBaseExtinction;
            float  odFallback = OpticalDepthHeightFog(_HeightFogBaseExtinction, _HeightFogBaseHeight,
                _HeightFogExponents, cosZenith, startHeight, distDelta);
            float  trFallback = TransmittanceFromOpticalDepth(odFallback);
            float  trCamera = 1 - volFog.a;

            volFog.rgb += trCamera * GetFogColor(V, tFrag) * GetCurrentExposureMultiplier() * volAlbedo * (1 - trFallback);
            volFog.a = 1 - (trCamera * trFallback);
        }

        color = volFog.rgb; // Already pre-exposed
        opacity = volFog.a;
    }

#ifndef ATMOSPHERE_NO_AERIAL_PERSPECTIVE
    // Sky pass already applies atmospheric scattering to the far plane.
    // This pass only handles geometry.
    if (_PBRFogEnabled)
    {
        float3 skyColor = 0, skyOpacity = 0;

        EvaluateAtmosphericScattering(-V, posInput.positionNDC, tFrag, skyColor, skyOpacity);

        CompositeOver(color, opacity, skyColor, skyOpacity, color, opacity);
    }
#endif

    return true;
}

// Used for transparent object. input color is color + alpha of the original transparent pixel.
// This must be call after ApplyBlendMode to work correctly
// Caution: Must stay in sync with VFXApplyFog in VFXCommon.hlsl
float4 EvaluateAtmosphericScattering_GOcean(PositionInputs posInput, float3 V, float4 inputColor)
{
    float4 result = inputColor;

#ifdef _ENABLE_FOG_ON_TRANSPARENT
    float3 volColor, volOpacity;
    EvaluateAtmosphericScattering_GOcean(posInput, V, volColor, volOpacity); // Premultiplied alpha

    if (_BlendMode == BLENDINGMODE_ALPHA)
    {
        result.rgb = result.rgb * (1 - volOpacity) + volColor * result.a;
    }
    else if (_BlendMode == BLENDINGMODE_ADDITIVE)
    {
        result.rgb = result.rgb * (1.0 - volOpacity);
    }
    else if (_BlendMode == BLENDINGMODE_PREMULTIPLY)
    {
        result.rgb = result.rgb * (1 - volOpacity) + volColor * result.a;
    }
#endif

    return result;
}

#endif // GOCEAN_ATMOSPHERIC_SCATTERING