#if SHADERPASS != SHADERPASS_FORWARD
#error SHADERPASS_is_not_correctly_define
#endif

#include "GOcean_Constants.hlsl"
#include "GOcean_UnderwaterSampling.hlsl"
#include "GOcean_HelperFunctions.hlsl"
#include "GOcean_AtmosphericScattering.hlsl"

float4 Vert(uint vertexID : SV_VertexID) : SV_Position
{
    return GetFullScreenTriangleVertexPosition(vertexID, UNITY_NEAR_CLIP_VALUE);
}

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplayMaterial.hlsl"

#if defined(_TRANSPARENT_REFRACTIVE_SORT) || defined(_ENABLE_FOG_ON_TRANSPARENT)
#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Water/Shaders/UnderWaterUtilities.hlsl"
#endif

//NOTE: some shaders set target1 to be
//   Blend 1 One OneMinusSrcAlpha
//The reason for this blend mode is to let virtual texturing alpha dither work.
//Anything using Target1 should write 1.0 or 0.0 in alpha to write / not write into the target.

#ifdef UNITY_VIRTUAL_TEXTURING
    #if defined(SHADER_API_PSSL)
        //For exact packing on pssl, we want to write exact 16 bit unorm (respect exact bit packing).
        //In some sony platforms, the default is FMT_16_ABGR, which would incur in loss of precision.
        //Thus, when VT is enabled, we force FMT_32_ABGR
        #pragma PSSL_target_output_format(target 1 FMT_32_ABGR)
    #endif
#endif

void Frag(float4 iVertex : SV_Position
    , out float4 outColor : SV_Target0
    #ifdef UNITY_VIRTUAL_TEXTURING
        , out float4 outVTFeedback : SV_Target1
    #endif
    , out float outputDepth : DEPTH_OFFSET_SEMANTIC
)
{
    uint oceanScreenTextureSample = _OceanScreenTexture[iVertex.xy];
    
    if (!GetDistantWaterSurfaceMask(oceanScreenTextureSample))
    {
        discard;
    }

    FragInputs input;

    //======================================================================================================//
    
    float4 posNDC = float4(iVertex.xy / _ScreenSize.xy, 1.0, 1.0);
    float4 posCS = float4(posNDC.xy * 2.0 - 1.0, UNITY_NEAR_CLIP_VALUE, 1.0);
#if UNITY_UV_STARTS_AT_TOP
    posCS.y = -posCS.y;
#endif
    float4 posRWS = mul(_InvViewProjMatrix, posCS);
    posRWS.xyz /= posRWS.w;
    
    float3 dir = normalize(posRWS.xyz);
    float dirDotUp = dot(dir, float3(0.0, 1.0, 0.0));
    
    bool hemisphereMask = dirDotUp < 0.0;
    bool oceanHeightMask = _WorldSpaceCameraPos_Internal.y > _WaterHeight;
    
    float tiling = _WorldSpaceCameraPos_Internal.y - _WaterHeight;
    tiling = oceanHeightMask ? tiling : -tiling;
    posRWS.xz = (dir.xz * tiling) / max(abs(dir.y), 0.001);
    posRWS.y = _WaterHeight - _WorldSpaceCameraPos_Internal.y;
    posCS = mul(_ViewProjMatrix, float4(posRWS.xyz, 1.0));
    posCS.z /= posCS.w;

    input.positionSS = float4(iVertex.xy, posCS.z, LinearEyeDepth(posCS.z, _ZBufferParams));
    input.positionRWS = posRWS.xyz; // TODO maybe add spectrumSample.z
    input.positionPredisplacementRWS = input.positionRWS;
    input.positionPixel = input.positionSS.xy;
    input.texCoord1 = 0;
    input.texCoord2 = 0;
    input.color = 0;
    input.tangentToWorld = M_3x3_identity;
    input.primitiveID = 0;
    input.isFrontFace = !GetUnderwaterMask(oceanScreenTextureSample);
    
    //======================================================================================================//
    
    AdjustFragInputsToOffScreenRendering(input, _OffScreenRendering > 0, _OffScreenDownsampleFactor);

    uint2 tileIndex = uint2(input.positionSS.xy) / GetTileSize();

    // input.positionSS is SV_Position
    PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS.xyz, tileIndex);

    float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

    SurfaceData surfaceData;
    BuiltinData builtinData;
    GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

    BSDFData bsdfData = ConvertSurfaceDataToBSDFData(input.positionSS.xy, surfaceData);

    PreLightData preLightData = GetPreLightData(V, posInput, bsdfData);

    outColor = float4(0.0, 0.0, 0.0, 0.0);

    // We need to skip lighting when doing debug pass because the debug pass is done before lighting so some buffers may not be properly initialized potentially causing crashes on PS4.

#ifdef DEBUG_DISPLAY
    // Init in debug display mode to quiet warning

    bool viewMaterial = GetMaterialDebugColor(outColor, input, builtinData, posInput, surfaceData, bsdfData);

    if (!viewMaterial)
    {
        if (_DebugFullScreenMode == FULLSCREENDEBUGMODE_VALIDATE_DIFFUSE_COLOR || _DebugFullScreenMode == FULLSCREENDEBUGMODE_VALIDATE_SPECULAR_COLOR)
        {
            float3 result = float3(0.0, 0.0, 0.0);

            GetPBRValidatorDebug(surfaceData, result);

            outColor = float4(result, 1.0f);
        }
        else if (_DebugFullScreenMode == FULLSCREENDEBUGMODE_TRANSPARENCY_OVERDRAW)
        {
            float4 result = _DebugTransparencyOverdrawWeight * float4(TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_A);
            outColor = result;
        }
        else
#endif
        {
            uint featureFlags = LIGHT_FEATURE_MASK_FLAGS_TRANSPARENT;
        
            LightLoopOutput lightLoopOutput;
            LightLoop(V, posInput, preLightData, bsdfData, builtinData, featureFlags, lightLoopOutput);

            // Alias
            float3 diffuseLighting = lightLoopOutput.diffuseLighting;
            float3 specularLighting = lightLoopOutput.specularLighting;

            diffuseLighting *= GetCurrentExposureMultiplier();
            specularLighting *= GetCurrentExposureMultiplier();
        
            outColor = ApplyBlendMode(diffuseLighting, specularLighting, builtinData.opacity);
        
            #ifdef _ENABLE_FOG_ON_TRANSPARENT
            outColor = EvaluateAtmosphericScattering(posInput, V, outColor);
            #endif
        
            #ifdef _TRANSPARENT_REFRACTIVE_SORT
            ComputeRefractionSplitColor(posInput, outColor, outBeforeRefractionColor, outBeforeRefractionAlpha);
            #endif
        
            float underwaterFogMask = (1.0 - GetUnderwaterDistanceFade(posInput.linearDepth, _UnderwaterFogFadeDistance)) * !input.isFrontFace;
            float linearEyeDepth = min(posInput.linearDepth, _UnderwaterFogFadeDistance);
            float mipLevel = (1.0 - _MipFogMaxMip * saturate((linearEyeDepth - _MipFogNear) / (_MipFogFar - _MipFogNear))) * (ENVCONSTANTS_CONVOLUTION_MIP_COUNT - 1);
            float3 skyColor = SampleSkyTexture(-V, mipLevel, 0).xyz;
            float3 underWaterFogColor = CalculateUnderwaterFogColor(_UnderwaterFogColor.xyz, skyColor, GetCurrentExposureMultiplier());
            
            outColor.xyz = lerp(outColor.xyz, underWaterFogColor, underwaterFogMask);
    }

#ifdef DEBUG_DISPLAY
    }
#endif

    outputDepth = saturate(posInput.deviceDepth);

#ifdef UNITY_VIRTUAL_TEXTURING
    float vtAlphaValue = builtinData.opacity;
#if defined(HAS_REFRACTION) && HAS_REFRACTION
        vtAlphaValue = 1.0f - bsdfData.transmittanceMask;
#endif
    outVTFeedback = PackVTFeedbackWithAlpha(builtinData.vtPackedFeedback, input.positionSS.xy, vtAlphaValue);
    outVTFeedback.rgb *= outVTFeedback.a; // premuliplied alpha
#endif
}
