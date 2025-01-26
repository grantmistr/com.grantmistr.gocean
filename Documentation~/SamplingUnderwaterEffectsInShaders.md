Example code, this is in a modified version of HDRPs forward pass hlsl file:
	
	#include "GOcean_Constants.hlsl"
	#include "GOcean_UnderwaterSampling.hlsl"

...

	#ifdef _SURFACE_TYPE_TRANSPARENT
                if (_DirectionalLightCount > 0)
                {
                    HDShadowContext sc = InitShadowContext();
                    DirectionalLightData L = _DirectionalLightDatas[0];
                    float3x3 lightRotationMatrix =
                    {
                        L.right,
                        L.up,
                        L.forward
                    };
            
                    float waterDepth = _WaterDepthTexture[posInput.positionSS].x;
        
	#if UNITY_REVERSED_Z
                    bool waterMask = waterDepth > posInput.deviceDepth;
	#else
                    bool waterMask = waterDepth < posInput.deviceDepth;
	#endif
        
                    bool underwaterMask = GetUnderwaterMask(_OceanScreenTexture[posInput.positionSS]);
        
                    bool causticMaskBelow = waterMask != underwaterMask;
        
                    float linearEyeDepth = min(posInput.linearDepth, _UnderwaterFogFadeDistance);
                    float mipLevel = (1.0 - _MipFogMaxMip * saturate((linearEyeDepth - _MipFogNear) / (_MipFogFar - _MipFogNear))) * (ENVCONSTANTS_CONVOLUTION_MIP_COUNT - 1);
                    float3 skyColor = SampleSkyTexture(-V, mipLevel, 0).xyz;

                    float3 fogColor = CalculateUnderwaterFogColor(_UnderwaterFogColor.xyz, skyColor, GetCurrentExposureMultiplier());
                    float fogMask = (1.0 - GetUnderwaterDistanceFade(posInput.linearDepth, _UnderwaterFogFadeDistance)) * underwaterMask;
        
                    float3 positionAbsWS = posInput.positionWS + _WorldSpaceCameraPos;
            
                    float3 caustic = CalculateCaustic(_SpectrumTexture, _SpectrumTextureResolution, _RandomNoiseTexture, s_linear_repeat_sampler,
                        _PatchSize, lightRotationMatrix, positionAbsWS, _CausticTiling, _CausticDefinition, _CausticDistortion, causticMaskBelow);
            
                    float shadowMask = EvalShadow_CascadedDepth_Blend(sc, _ShadowmapCascadeAtlas, s_linear_clamp_compare_sampler, posInput.positionSS, posInput.positionWS,
                        surfaceData.normalWS, 0, L.forward);
        
                    float causticMask = CalculateCausticMask(surfaceData.normalWS, positionAbsWS, L.forward, waterMask, underwaterMask,
                        _WaterHeight, _SpectrumTexture, _PatchSize, s_linear_repeat_sampler, _CausticFadeDepth, _CausticAboveWaterFadeDistance,
                        _CausticStrength, shadowMask);
            
                    caustic *= causticMask;
                    caustic *= L.color * GetCurrentExposureMultiplier();
            
                    outColor.xyz += caustic;
            
	#if BLENDINGMODE_ADDITIVE
                    outColor *= 1.0 - fogMask;
	#else
                    outColor = lerp(outColor, float4(fogColor, 1.0), fogMask);
	#endif
                }
	#endif