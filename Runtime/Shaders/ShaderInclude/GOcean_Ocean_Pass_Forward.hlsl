#if SHADERPASS != SHADERPASS_FORWARD
#error SHADERPASS_is_not_correctly_define
#endif

#include "GOcean_HelperFunctions.hlsl"
#include "GOcean_UnderwaterSampling.hlsl"
#include "GOcean_Constants.hlsl"
#include "GOcean_GetTrisFromBuffer.hlsl"

struct v2f
{
    float4 position : SV_Position;
    float3 positionRWS : TEXCOORD0;
    float2 preDisplacedPositionXZ : TEXCOORD1;
};

#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/MotionVectorVertexShaderCommon.hlsl"

v2f Vert(uint vertexID : SV_VertexID)
{
    float3 displacedPosition;
    float2 preDisplacedPositionXZ;
    GetVertexFromTri(vertexID, preDisplacedPositionXZ, displacedPosition);
    
    v2f o;
    o.position = mul(_ViewProjMatrix, float4(displacedPosition, 1.0));
    o.positionRWS = displacedPosition;
    o.preDisplacedPositionXZ = preDisplacedPositionXZ;
    
    return o;
}

#else // _WRITE_TRANSPARENT_MOTION_VECTOR

v2f Vert(uint vertexID : SV_VertexID)
{
    float3 displacedPosition;
    float2 preDisplacedPositionXZ;
    GetVertexFromTri(vertexID, preDisplacedPositionXZ, displacedPosition);
    
    v2f o;
    o.position = mul(_ViewProjMatrix, float4(displacedPosition, 1.0));
    o.positionRWS = displacedPosition;
    o.preDisplacedPositionXZ = preDisplacedPositionXZ;
    
    return o;
}

#endif // _WRITE_TRANSPARENT_MOTION_VECTOR

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplayMaterial.hlsl"

#if defined(_TRANSPARENT_REFRACTIVE_SORT) || defined(_ENABLE_FOG_ON_TRANSPARENT)
#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Water/Shaders/UnderWaterUtilities.hlsl"
#endif

//NOTE: some shaders set target1 to be
//   Blend 1 One OneMinusSrcAlpha
//The reason for this blend mode is to let virtual texturing alpha dither work.
//Anything using Target1 should write 1.0 or 0.0 in alpha to write / not write into the target.

#ifdef UNITY_VIRTUAL_TEXTURING
    #if defined(_WRITE_TRANSPARENT_MOTION_VECTOR)
        #define MOTION_VECTOR_TARGET SV_Target2
        #ifdef _TRANSPARENT_REFRACTIVE_SORT
            #define BEFORE_REFRACTION_TARGET SV_Target3
            #define BEFORE_REFRACTION_ALPHA_TARGET SV_Target4
        #endif
    #endif
    #if defined(SHADER_API_PSSL)
        //For exact packing on pssl, we want to write exact 16 bit unorm (respect exact bit packing).
        //In some sony platforms, the default is FMT_16_ABGR, which would incur in loss of precision.
        //Thus, when VT is enabled, we force FMT_32_ABGR
        #pragma PSSL_target_output_format(target 1 FMT_32_ABGR)
    #endif
#else
    #if defined(_WRITE_TRANSPARENT_MOTION_VECTOR)
        #define MOTION_VECTOR_TARGET SV_Target1
        #ifdef _TRANSPARENT_REFRACTIVE_SORT
            #define BEFORE_REFRACTION_TARGET SV_Target2
            #define BEFORE_REFRACTION_ALPHA_TARGET SV_Target3
        #endif
    #endif
#endif

void Frag(v2f i, bool facing : SV_IsFrontFace
    , out float4 outColor : SV_Target0  // outSpecularLighting when outputting split lighting
    #ifdef UNITY_VIRTUAL_TEXTURING
        , out float4 outVTFeedback : SV_Target1
    #endif
    #if defined(_WRITE_TRANSPARENT_MOTION_VECTOR)
          , out float4 outMotionVec : MOTION_VECTOR_TARGET
        #ifdef _TRANSPARENT_REFRACTIVE_SORT
          , out float4 outBeforeRefractionColor : BEFORE_REFRACTION_TARGET
          , out float4 outBeforeRefractionAlpha : BEFORE_REFRACTION_ALPHA_TARGET
        #endif
    #endif
        , out float outputDepth : DEPTH_OFFSET_SEMANTIC
)
{
#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
    // Init outMotionVector here to solve compiler warning (potentially unitialized variable)
    // It is init to the value of forceNoMotion (with 2.0)
    // Always write 1.0 in alpha since blend mode could be active on this target as a side effect of VT feedback buffer
    // motion vector expected output format is RG16
    outMotionVec = float4(2.0, 0.0, 0.0, 1.0);
#endif

    FragInputs input;
    
    // ========== //
    
    input.positionSS = float4(i.position.xy, i.position.z, LinearEyeDepth(i.position.z, _ZBufferParams));
    input.positionRWS = i.positionRWS;
    input.positionPredisplacementRWS = float3(i.preDisplacedPositionXZ.x, 0.0, i.preDisplacedPositionXZ.y);
    input.positionPixel = input.positionSS.xy;
    input.texCoord1 = 0;
    input.texCoord2 = 0;
    input.color = 0;
    input.tangentToWorld = M_3x3_identity;
    input.primitiveID = 0;
    input.isFrontFace = facing;
    
    // ========== //
    
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

#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
            VaryingsPassToPS inputPass = UnpackVaryingsPassToPS(packedInput.vpass);
            bool forceNoMotion = any(unity_MotionVectorsParams.yw == 0.0);
            // outMotionVec is already initialize at the value of forceNoMotion (see above)

            if (!forceNoMotion)
            {
                float2 motionVec = CalculateMotionVector(inputPass.positionCS, inputPass.previousPositionCS);
                EncodeMotionVector(motionVec * 0.5, outMotionVec);

                // Always write 1.0 in alpha since blend mode could be active on this target as a side effect of VT feedback buffer
                // motion vector expected output format is RG16
                outMotionVec.zw = 1.0;
            }
#endif
        }

#ifdef DEBUG_DISPLAY
    }
#endif

    outputDepth = posInput.deviceDepth;

#ifdef UNITY_VIRTUAL_TEXTURING
    float vtAlphaValue = builtinData.opacity;
    #if defined(HAS_REFRACTION) && HAS_REFRACTION
        vtAlphaValue = 1.0f - bsdfData.transmittanceMask;
    #endif
    outVTFeedback = PackVTFeedbackWithAlpha(builtinData.vtPackedFeedback, input.positionSS.xy, vtAlphaValue);
    outVTFeedback.rgb *= outVTFeedback.a; // premuliplied alpha
#endif
}
