Shader "GOcean/Fullscreen"
{
    Properties
    {
        [NoScaleOffset]_ScreenWaterNoiseTexture("_ScreenWaterNoiseTexture", 2D) = "black" {}
        _PatchHighestWaveCount("_PatchHighestWaveCount", Vector) = (1.0, 1.0, 1.0, 1.0)
        _PatchLowestWaveCount("_PatchLowestWaveCount", Vector) = (1.0, 1.0, 1.0, 1.0)
        _WaterColor("_WaterColor", Color) = (1.0, 1.0, 1.0, 1.0)
        _MaxSliceDepth("_MaxSliceDepth", Float) = 1.0
        _MinSliceDepth("_MinSliceDepth", Float) = 1.0
        _LightRayFadeInDistance("_LightRayFadeInDistance", Float) = 1.0
        _LightRayTiling("_LightRayTiling", Float) = 1.0
        _LightRayDefinition("_LightRayDefinition", Float) = 1.0
        _LightRayShadowMultiplier("_LightRayShadowMultiplier", Float) = 1.0
        _ScreenWaterFadeSpeed("_ScreenWaterFadeSpeed", Float) = 1.0
        _ScreenWaterTiling("_ScreenWaterTiling", Float) = 1.0
    }

    HLSLINCLUDE

    #pragma target 4.5
    #pragma vertex Vert

    #pragma multi_compile_fragment _ WATER_WRITES_TO_DEPTH

    // maybe use ULTRA_LOW shadows
    #define PUNCTUAL_SHADOW_LOW
    #define DIRECTIONAL_SHADOW_LOW
    #define AREA_SHADOW_LOW

    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/EntityLighting.hlsl"
    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/AtmosphericScattering/AtmosphericScattering.hlsl"
    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/RenderPass/CustomPass/CustomPassCommon.hlsl"
    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/NormalBuffer.hlsl"
    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinGIUtilities.hlsl"

    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"

    // The PositionInputs struct allow you to retrieve a lot of useful information for your fullScreenShader:
    // struct PositionInputs
    // {
    //     float3 positionWS;  // World space position (could be camera-relative)
    //     float2 positionNDC; // Normalized screen coordinates within the viewport    : [0, 1) (with the half-pixel offset)
    //     uint2  positionSS;  // Screen space pixel coordinates                       : [0, NumPixels)
    //     uint2  tileCoord;   // Screen tile coordinates                              : [0, NumTiles)
    //     float  deviceDepth; // Depth from the depth buffer                          : [0, 1] (typically reversed)
    //     float  linearDepth; // View space Z coordinate                              : [Near, Far]
    // };

    // To sample custom buffers, you have access to these functions:
    // But be careful, on most platforms you can't sample to the bound color buffer. It means that you
    // can't use the SampleCustomColor when the pass color buffer is set to custom (and same for camera the buffer).
    // float4 CustomPassSampleCustomColor(float2 uv);
    // float4 CustomPassLoadCustomColor(uint2 pixelCoords);
    // float LoadCustomDepth(uint2 pixelCoords);
    // float SampleCustomDepth(float2 uv);

    // There are also a lot of utility function you can use inside Common.hlsl and Color.hlsl,
    // you can check them out in the source code of the core SRP package.

    #include "ShaderInclude/GOcean_Constants.hlsl"
    #include "ShaderInclude/GOcean_GlobalTextures.hlsl"
    #include "ShaderInclude/GOcean_TerrainHeightmapProperties.hlsl"
    #include "ShaderInclude/GOcean_TerrainHeightmapSampling.hlsl"
    #include "ShaderInclude/GOcean_HDRP_ShaderVariablesGlobal.hlsl"
    #include "ShaderInclude/GOcean_HelperFunctions.hlsl"
    #include "ShaderInclude/GOcean_UnderwaterSampling.hlsl"
    #include "ShaderInclude/GOcean_ShadowSampling.hlsl"

    Texture2D _ScreenWaterNoiseTexture;

    float4  _PatchHighestWaveCount, _PatchLowestWaveCount, _WaterColor;
    float   _MaxSliceDepth, _MinSliceDepth, _LightRayFadeInDistance, _LightRayTiling, _LightRayDefinition, _LightRayShadowMultiplier,
            _ScreenWaterFadeSpeed, _ScreenWaterTiling;

    float4 OpaqueCaustic(Varyings varyings) : SV_Target
    {
        if (_DirectionalLightCount < 1)
        {
            return float4(0.0, 0.0, 0.0, 0.0);
        }
    
        UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(varyings);

        float depth = LoadCameraDepth(varyings.positionCS.xy); // opaque depth
    
#if UNITY_REVERSED_Z
        bool isNotFarPlane = (depth != 0.0);
#else
        bool isNotFarPlane = (depth != 1.0);
#endif
    
        if (!isNotFarPlane)
        {
            discard;
        }
    
        HDShadowContext shadowContext = InitShadowContext();

        NormalData normalData;
        DecodeFromNormalBuffer(varyings.positionCS.xy, normalData);

        DirectionalLightData L = _DirectionalLightDatas[0];
        float3x3 lightRotationMatrix = {
            L.right,
            L.up,
            L.forward
        };

        float waterDepth = _WaterDepthTexture[varyings.positionCS.xy].x; // water depth
        float linearEyeWaterDepth = LinearEyeDepth(waterDepth, _ZBufferParams);
        float linearEyeDepth = LinearEyeDepth(depth, _ZBufferParams);
        float4 screenTextureSample = _TemporaryColorTexture[varyings.positionCS.xy];
        bool underwaterMask = screenTextureSample.x; // x: underwater mask (above: 0, below: 1)
        bool waterSurfaceMask = screenTextureSample.y;
    
        float2 ndc = varyings.positionCS.xy / _ScreenSize.xy;
        float4 positionCS = float4(ndc * 2.0 - 1.0, depth, 1.0);
#if UNITY_UV_STARTS_AT_TOP
        positionCS.y = -positionCS.y;
#endif
        float4 positionWS = mul(_InvViewProjMatrix, positionCS);
        positionWS /= positionWS.w;
        float3 positionAbsWS = positionWS.xyz + _WorldSpaceCameraPos;

#if UNITY_REVERSED_Z
        bool waterMask = waterDepth > depth;
#else
        bool waterMask = waterDepth < depth;
#endif
    
        bool causticMaskBelow = waterMask != underwaterMask;
    
        float shadowMask = EvalShadow_CascadedDepth_Blend(shadowContext, _ShadowmapCascadeAtlas, s_linear_clamp_compare_sampler, varyings.positionCS.xy,
            positionWS.xyz, normalData.normalWS, 0, L.forward);
    
        float3 caustic = CalculateCaustic(_SpectrumTexture, _SpectrumTextureResolution, _RandomNoiseTexture, s_linear_repeat_sampler,
                _PatchSize, lightRotationMatrix, positionAbsWS, _CausticTiling, _CausticDefinition, _CausticDistortion, causticMaskBelow);
    
        caustic *= L.color * GetCurrentExposureMultiplier();
        
        float causticMask = CalculateCausticMask(normalData.normalWS, positionAbsWS, L.forward, waterMask, underwaterMask, _WaterHeight,
                _SpectrumTexture, _PatchSize, s_linear_repeat_sampler, _CausticFadeDepth, _CausticAboveWaterFadeDistance, _CausticStrength, shadowMask);
    
        caustic *= causticMask;
    
        return float4(caustic, 1.0);
    }

    float4 OpaqueUnderwaterFog(Varyings varyings) : SV_Target
    {
        UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(varyings);
    
        float4 screenTextureSample = _TemporaryColorTexture[varyings.positionCS.xy];
        bool underwaterMask = screenTextureSample.x; // x: underwater mask (above: 0, below: 1)
        bool waterSurfaceMask = screenTextureSample.y;

        float depth = LoadCameraDepth(varyings.positionCS.xy); // opaque depth
        float linearEyeDepth = LinearEyeDepth(depth, _ZBufferParams);
        float waterDepth = _WaterDepthTexture[varyings.positionCS.xy];
        float linearEyeWaterDepth = LinearEyeDepth(waterDepth, _ZBufferParams);

        float2 ndc = varyings.positionCS.xy / _ScreenSize.xy;
        float4 positionCS = float4(ndc * 2.0 - 1.0, depth, 1.0);

#if UNITY_UV_STARTS_AT_TOP
        positionCS.y = -positionCS.y;
#endif

        float4 positionWS = mul(_InvViewProjMatrix, positionCS);
        positionWS.xyz /= positionWS.w;
        float3 V = normalize(positionWS.xyz);

#if UNITY_REVERSED_Z
        bool isFarPlane = (depth == 0.0);
#else
        bool isFarPlane = (depth == 1.0);
#endif

        float fogMask = linearEyeDepth - linearEyeWaterDepth * !(isFarPlane && waterSurfaceMask) * !underwaterMask;
        fogMask = GetUnderwaterDistanceFade(fogMask, _UnderwaterFogFadeDistance);
        fogMask *= underwaterMask ? 1.0 : fogMask * fogMask;
        fogMask = 1.0 - fogMask;
    
        float mipLevelDepth = min(linearEyeDepth, _UnderwaterFogFadeDistance);
        float mipLevel = (1.0 - _MipFogMaxMip * saturate((mipLevelDepth - _MipFogNear) / (_MipFogFar - _MipFogNear))) * (ENVCONSTANTS_CONVOLUTION_MIP_COUNT - 1);
        float3 skyColor = SampleSkyTexture(V, mipLevel, 0).xyz;
        
        float3 fogColor = CalculateUnderwaterFogColor(_UnderwaterFogColor.xyz, skyColor, GetCurrentExposureMultiplier());
        fogColor = lerp(_WaterColor.xyz * skyColor * GetCurrentExposureMultiplier(), fogColor, underwaterMask);
    
        return float4(fogColor, fogMask);
    }

    struct CoordinateData
    {
        float2 positionNDC;
        float4 positionCS;
        float4 positionRWS;
        float3 positionWS;
        float3 positionWSRot;
    
        float viewDepth;
        float rawDepth;
    };

    const static int2 coordOffset[8] = { int2(-1, -1), int2(0, -1), int2(1, -1), int2(-1, 0), int2(1, 0), int2(-1, 1), int2(0, 1), int2(1, 1) };
    const static uint slices = 8;
    const static float sliceStep = 1.0 / (float) slices;

    float CalculateScreenWater(float2 positionCS, uint2 coord, float4 oceanScreenTextureSample)
    {
        float aspect = _ScreenSize.x / _ScreenSize.y;
        float2x2 m = GetRotationMatrixWithAspectRatio(_CameraZRotation, aspect);
        float2 uvScreen = positionCS;
        uvScreen = mul(m, uvScreen);
        uvScreen *= _ScreenWaterTiling;
        uvScreen.x *= aspect;
    
        float flowMask = _ScreenWaterNoiseTexture.SampleLevel(s_linear_repeat_sampler, uvScreen, 0.0).x;
        float2 flowDirection = mul(m, float2(0.0, -1.0));
    
        int2 dim = (int2) _ScreenSize.xy - 1;
        float contribution = 0.0;
        [unroll(8)]
        for (int i = 0; i < 8; i++)
        {
            int2 c = (int2) coord + coordOffset[i];
            c = clamp(c, int2(0, 0), dim);
            bool valid = dot((float2) coordOffset[i], flowDirection) < 0.0;
        
            contribution += _TemporaryColorTexture[c].z * valid;
        }
    
        float screenWater = oceanScreenTextureSample.z;
        screenWater -= saturate(_ScreenWaterFadeSpeed * unity_DeltaTime.x);
        screenWater += saturate(contribution * flowMask * unity_DeltaTime.x);
        screenWater = saturate(screenWater + oceanScreenTextureSample.x * 2.0);
    
        return screenWater;
    }

    float4 ComputeLightRaysScreenWater(Varyings varyings) : SV_Target
    {
        UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(varyings);
        uint2 coord = varyings.positionCS.xy;
    
        float4 oceanScreenTextureSample = _TemporaryColorTexture[coord];
        bool underwaterMask = (bool) oceanScreenTextureSample.x;
        float waterDepth = _WaterDepthTexture[coord].x;
        float sceneDepth = LoadCameraDepth(coord).x;
        float viewDepth = RawToViewDepth(sceneDepth, _ZBufferParams);
        float waterViewDepth = RawToViewDepth(waterDepth, _ZBufferParams);
    
        float causticSourceSpectrumSlice = 9.0;
        float causticSampleOffsetDelta = 2.0 / (float) _SpectrumTextureResolution;
    
        DirectionalLightData L = _DirectionalLightDatas[0];
        float3x3 lightRotationMatrix =
        {
            L.right,
            L.up,
            L.forward
        };
    
        // Try and get distant color (where view depth would be > camera far plane) to match close light ray color.
        float distantLightRayValue = 0.3 + 0.7 / ((_LightRayDefinition + _Turbulence) / _PatchHighestWaveCount[0] + 1.0);
    
        float heightDelta = GetLightRayHeightFade(_WorldSpaceCameraPos_Internal.xyz, _WaterHeight, _CausticFadeDepth);
    
        float startDepth = underwaterMask ? max(_MinSliceDepth, _ProjectionParams.y) : waterViewDepth;
    
        CoordinateData cd;
        cd.viewDepth = startDepth;
        cd.rawDepth = ViewToRawDepth(cd.viewDepth, _ZBufferParams);
        cd.positionNDC = (float2) coord / _ScreenSize.xy;
        cd.positionCS = float4(cd.positionNDC * 2.0 - 1.0, cd.rawDepth, 1.0);
#ifdef UNITY_UV_STARTS_AT_TOP
        cd.positionCS.y = -cd.positionCS.y;
#endif
        cd.positionRWS = mul(_InvViewProjMatrix, cd.positionCS);
        cd.positionRWS /= cd.positionRWS.w;
    
        float startDistance = length(cd.positionRWS.xyz);
    
        // for some reason _CascadeShadowCount is one less than count shown in inspector, so equal to number of cascade splits
        uint shadowIndex;
        [loop]
        for (shadowIndex = 0; shadowIndex <= _CascadeShadowCount; shadowIndex++)
        {
            if (startDistance < _CascadeShadowSplits[shadowIndex])
            {
                break;
            }
        }
    
        float sum = 0.0;
        for (uint i = 0; i < slices; i++)
        {
            float slice = (float) i;
            float normalizedSlice = slice / (float) slices;
        
            cd.viewDepth = Random(cd.positionNDC + slice);
            cd.viewDepth *= sliceStep;
            cd.viewDepth += normalizedSlice;
            cd.viewDepth *= cd.viewDepth;
            cd.viewDepth *= _MaxSliceDepth;
        
            cd.rawDepth = ViewToRawDepth(cd.viewDepth, _ZBufferParams);
            cd.rawDepth = saturate(cd.rawDepth);
        
            cd.positionCS.z = cd.rawDepth;
            cd.positionRWS = mul(_InvViewProjMatrix, cd.positionCS);
            cd.positionRWS /= cd.positionRWS.w;
            cd.positionWS = cd.positionRWS.xyz + _WorldSpaceCameraPos_Internal.xyz;
            cd.positionWSRot = mul(lightRotationMatrix, cd.positionWS).xyz;
        
            float2 causticUV = cd.positionWSRot.xy * _LightRayTiling / _PatchSize[0];
        
            float3 c  = _SpectrumTexture.SampleLevel(s_linear_repeat_sampler, float3(causticUV, causticSourceSpectrumSlice), 0.0).xyz;
            float3 cR = _SpectrumTexture.SampleLevel(s_linear_repeat_sampler, float3(causticUV.x + causticSampleOffsetDelta, causticUV.y, causticSourceSpectrumSlice), 0.0).xyz;
            float3 cU = _SpectrumTexture.SampleLevel(s_linear_repeat_sampler, float3(causticUV.x, causticUV.y + causticSampleOffsetDelta, causticSourceSpectrumSlice), 0.0).xyz;
    
            float caustic = abs(c.x - cR.x) + abs(c.y - cR.y) + abs(c.x - cU.x) + abs(c.y - cU.y);
            caustic = 1.0 / (caustic + 1.0);
        
            bool waterDepthTest = cd.viewDepth < waterViewDepth; // in front of water surface
            waterDepthTest = underwaterMask ? waterDepthTest : !waterDepthTest; // flip if out of water
            bool depthTest = waterDepthTest && (cd.viewDepth < viewDepth); // true if in water and not occluded by objects
        
            float fadeIn = GetLightRayFadeIn(startDepth, cd.viewDepth, _LightRayFadeInDistance);
        
            float distance = length(cd.positionRWS.xyz);
            shadowIndex = (distance > _CascadeShadowSplits[shadowIndex]) && (shadowIndex < _CascadeShadowCount) ? shadowIndex + 1 : shadowIndex;
            float3 shadowSamplingCoords = GetDirectionalShadowSamplingCoords(_HDShadowDatas[shadowIndex], _CascadeShadowAtlasSize, cd.positionRWS.xyz);
            float shadowSample = _ShadowmapCascadeAtlas.SampleLevel(s_point_clamp_sampler, shadowSamplingCoords.xy, 0.0).x;
            float shadowTest = (distance > _CascadeShadowSplits[shadowIndex]) || shadowSamplingCoords.z > shadowSample ? 1.0 : 0.0;
        
            caustic = lerp(_LightRayShadowMultiplier, caustic, shadowTest);
            caustic = lerp(1.0, caustic, min(min(fadeIn, heightDelta), depthTest));
            caustic = lerp(caustic, distantLightRayValue, saturate(cd.viewDepth / _ProjectionParams.z));
        
            sum += caustic;
        }
    
        sum /= (float) slices;
        sum = lerp(_LightRayStrengthInverse, sum, saturate(-dot(L.forward, float3(0.0, 1.0, 0.0))));
        sum = pow(saturate(sum), _LightRayDefinition);
    
        float screenWater = CalculateScreenWater(cd.positionCS.xy, coord, oceanScreenTextureSample);
    
        // move underwater mask to bit 0 and water surface mask to bit 1 of screen texture R channel, then encode as a float
        oceanScreenTextureSample.x = float((oceanScreenTextureSample.x > 0.0 ? 0x1 : 0x0) | (oceanScreenTextureSample.y > 0.0 ? 0x2 : 0x0)) / 255.0;
        
        return float4(oceanScreenTextureSample.x, sum, screenWater, 1.0);
    }

    float2 GetScreenWaterDisplacement(float2 coord, Texture2D t, float4 oceanScreenTextureSample)
    {
        float offsetX = min(coord.x + 4.0, _ScreenSize.x - 1.0);
        float offsetY = min(coord.y + 4.0, _ScreenSize.y - 1.0);
    
        float s0 = t[uint2(offsetX, coord.y)].w;
        float s1 = t[uint2(coord.x, offsetY)].w;

        return float2(oceanScreenTextureSample.w - s0, oceanScreenTextureSample.w - s1) * -400.0;
    }

    float4 UnderwaterTint(Varyings varyings
#ifdef WATER_WRITES_TO_DEPTH        
        , out float outputDepth: SV_Depth
#endif
        ) : SV_Target
    {
        UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(varyings);
        
        float opaqueDepth = LoadCameraDepth(varyings.positionCS.xy);
    
        float2 positionNDC = varyings.positionCS.xy / _ScreenSize.xy;
        float4 positionCS = float4(positionNDC * 2.0 - 1.0, opaqueDepth, 1.0);
#if UNITY_UV_STARTS_AT_TOP
        positionCS.y = -positionCS.y;
#endif
        float4 positionRWS = mul(_InvViewProjMatrix, positionCS);
        positionRWS.xyz /= positionRWS.w;
        float3 positionAbsWS = positionRWS.xyz + _WorldSpaceCameraPos;
        float3 viewDirection = normalize(positionRWS.xyz);
    
        float4 oceanScreenTextureSample = _OceanScreenTexture[varyings.positionCS.xy]; // x: underwater mask (above: 0, below: 1), y: light rays, z: screen water, w: blurred screen water
        bool underwaterMask = GetUnderwaterMask(oceanScreenTextureSample);
    
        float2 displacedSampleCoords = GetScreenWaterDisplacement(varyings.positionCS.xy, _OceanScreenTexture, oceanScreenTextureSample);
    
        float2 colorCoords = clamp(varyings.positionCS.xy + displacedSampleCoords, float2(0.0, 0.0), _ScreenSize.xy - 1.0);
        colorCoords = GetUnderwaterMask(_OceanScreenTexture[colorCoords]) ? varyings.positionCS.xy : colorCoords;

        float3 color = CustomPassLoadCameraColor(colorCoords, 0.0);

        float lightRays = oceanScreenTextureSample.y;
        lightRays *= _LightRayStrength;

        color *= underwaterMask ? lightRays : 1.0;
        color *= underwaterMask ? _UnderwaterFogColor.xyz : 1.0;
    
#ifdef WATER_WRITES_TO_DEPTH
        float waterDepth = _WaterDepthTexture[varyings.positionCS.xy];
#if UNITY_REVERSED_Z
        float screenWaterAlpha = 1.0;
        float depth = max(opaqueDepth, waterDepth);
#else
        float screenWaterAlpha = 0.0;
        float depth = min(opaqueDepth, waterDepth);
#endif
        bool screenWaterAlphaMask = !underwaterMask && (oceanScreenTextureSample.w > 0.0);
        outputDepth = screenWaterAlphaMask ? screenWaterAlpha : depth;
#endif // WATER_WRITES_TO_DEPTH

        color *= 1.0 - oceanScreenTextureSample.w * !underwaterMask * 0.1;
    
        return float4(color, 1.0);
}

    float4 TransferFinal(Varyings varyings
#ifdef WATER_WRITES_TO_DEPTH
        , out float depth: SV_Depth
#endif
        ) : SV_Target
    {
        UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(varyings);

        float4 color = _TemporaryColorTexture[varyings.positionCS.xy];
    
#ifdef WATER_WRITES_TO_DEPTH
        depth = _TemporaryDepthTexture[varyings.positionCS.xy].x;
#endif    
    
        return color;
    }

    ENDHLSL
    
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "HDRenderPipeline"
        }

        Pass
        {
            Name "OpaqueCaustic"

            ZWrite Off
            ZTest Off
            Cull Back
            Blend One One

            HLSLPROGRAM
                #pragma fragment OpaqueCaustic
            ENDHLSL
        }

        Pass
        {
            Name "OpaqueUnderwaterFog"

            ZWrite Off
            ZTest Off
            Cull Back
            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM
                #pragma fragment OpaqueUnderwaterFog
            ENDHLSL
        }

        Pass
        {
            Name "ComputeLightRaysScreenWater"

            ZWrite Off
            ZTest Off
            Cull Back
            Blend Off

            HLSLPROGRAM
                #pragma fragment ComputeLightRaysScreenWater
            ENDHLSL
        }

        Pass
        {
            Name "UnderwaterTintWriteDepth"

            ZWrite On
            ZTest Off
            Cull Back
            Blend Off

            HLSLPROGRAM
                #pragma fragment UnderwaterTint
            ENDHLSL
        }

        Pass
        {
            Name "UnderwaterTint"

            ZWrite Off
            ZTest Off
            Cull Back
            Blend Off

            HLSLPROGRAM
                #pragma fragment UnderwaterTint
            ENDHLSL
        }

        Pass
        {
            Name "TransferFinalWriteDepth"

            ZWrite On
            ZTest Off
            Cull Back
            Blend Off

            HLSLPROGRAM
                #pragma fragment TransferFinal
            ENDHLSL
        }

        Pass
        {
            Name "TransferFinal"

            ZWrite Off
            ZTest Off
            Cull Back
            Blend Off

            HLSLPROGRAM
                #pragma fragment TransferFinal
            ENDHLSL
        }
    }
    Fallback Off
}