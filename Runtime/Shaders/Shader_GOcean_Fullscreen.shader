Shader "GOcean/Fullscreen"
{
    Properties
    {
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
    
        if (IsFarPlane(depth))
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
        uint oceanScreenTextureSample = _OceanScreenTexture[varyings.positionCS.xy];
        bool underwaterMask = GetUnderwaterMask(oceanScreenTextureSample);
    
        float2 ndc = varyings.positionCS.xy / _ScreenSize.xy;
        float4 positionCS = float4(ndc * 2.0 - 1.0, depth, 1.0);
#if UNITY_UV_STARTS_AT_TOP
        positionCS.y = -positionCS.y;
#endif
        float4 positionWS = mul(_InvViewProjMatrix, positionCS);
        positionWS /= positionWS.w;
        float3 positionAbsWS = positionWS.xyz + _WorldSpaceCameraPos;

#if UNITY_REVERSED_Z
        bool waterMask = waterDepth >= depth;
#else
        bool waterMask = waterDepth <= depth;
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
    
        uint oceanScreenTextureSample = _OceanScreenTexture[varyings.positionCS.xy];
        bool underwaterMask = GetUnderwaterMask(oceanScreenTextureSample);
        bool waterSurfaceMask = GetWaterSurfaceMask(oceanScreenTextureSample);
    
        if (!(underwaterMask || waterSurfaceMask))
        {
            discard;
        }
    
        float depth = LoadCameraDepth(varyings.positionCS.xy); // opaque depth
        float linearEyeDepth = LinearEyeDepth(depth, _ZBufferParams);
        float waterDepth = _WaterDepthTexture[varyings.positionCS.xy];
        float linearEyeWaterDepth = LinearEyeDepth(waterDepth, _ZBufferParams);

#if UNITY_REVERSED_Z
        bool waterMask = waterDepth >= depth;
#else
        bool waterMask = waterDepth <= depth;
#endif
    
        if (!((underwaterMask != waterSurfaceMask) || !waterMask))
        {
            discard;
        }
    
        float2 ndc = varyings.positionCS.xy / _ScreenSize.xy;
        float4 positionCS = float4(ndc * 2.0 - 1.0, depth, 1.0);

#if UNITY_UV_STARTS_AT_TOP
        positionCS.y = -positionCS.y;
#endif

        float4 positionWS = mul(_InvViewProjMatrix, positionCS);
        positionWS.xyz /= positionWS.w;
        float3 V = normalize(positionWS.xyz);

        bool isFarPlane = IsFarPlane(depth);

        float fogMask = linearEyeDepth - linearEyeWaterDepth * (!(isFarPlane && (underwaterMask != waterSurfaceMask)) && !underwaterMask);
        fogMask = GetUnderwaterDistanceFade(fogMask, _UnderwaterFogFadeDistance);
        fogMask *= underwaterMask ? 1.0 : fogMask * fogMask;
        fogMask = (1.0 - fogMask);// * ((underwaterMask != waterSurfaceMask) || !waterMask);
    
        float mipLevelDepth = min(linearEyeDepth, _UnderwaterFogFadeDistance);
        float mipLevel = (1.0 - _MipFogMaxMip * saturate((mipLevelDepth - _MipFogNear) / (_MipFogFar - _MipFogNear))) * (ENVCONSTANTS_CONVOLUTION_MIP_COUNT - 1);
        float3 skyColor = SampleSkyTexture(V, mipLevel, 0).xyz;
        
        float3 fogColor = CalculateUnderwaterFogColor(_UnderwaterFogColor.xyz, skyColor, GetCurrentExposureMultiplier());
        fogColor = lerp(_WaterColor.xyz * skyColor * GetCurrentExposureMultiplier(), fogColor, underwaterMask);
    
        return float4(fogColor, fogMask);
    }

    float2 GetScreenWaterDisplacement(float2 coord, Texture2D<float2> t, float2 temporaryBlurTextureSample)
    {
        float offsetX = min(coord.x + 4.0, _ScreenSize.x - 1.0);
        float offsetY = min(coord.y + 4.0, _ScreenSize.y - 1.0);
    
        float s0 = t[uint2(offsetX, coord.y)].y;
        float s1 = t[uint2(coord.x, offsetY)].y;

        return float2(temporaryBlurTextureSample.y - s0, temporaryBlurTextureSample.y - s1) * -600.0;
    }

    float4 UnderwaterTint(Varyings varyings
#ifdef WATER_WRITES_TO_DEPTH        
        , out float outputDepth: SV_Depth
#endif
        ) : SV_Target
    {
        UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(varyings);
        
        float2 temporaryBlurTextureSample = _TemporaryBlurTexture[varyings.positionCS.xy];
        uint oceanScreenTextureSample = _OceanScreenTexture[varyings.positionCS.xy];
        bool underwaterMask = GetUnderwaterMask(oceanScreenTextureSample);
    
        float2 displacedSampleCoords = GetScreenWaterDisplacement(varyings.positionCS.xy, _TemporaryBlurTexture, temporaryBlurTextureSample);
    
        float2 colorCoords = clamp(varyings.positionCS.xy + displacedSampleCoords, float2(0.0, 0.0), _ScreenSize.xy - 1.0);
        colorCoords = GetUnderwaterMask(_OceanScreenTexture[colorCoords]) ? varyings.positionCS.xy : colorCoords;

        float3 color = CustomPassLoadCameraColor(colorCoords, 0.0);

        float lightRays = temporaryBlurTextureSample.x;
        lightRays *= _LightRayStrength;

        color *= underwaterMask ? lightRays : 1.0;
        color *= underwaterMask ? _UnderwaterFogColor.xyz : 1.0;
    
#ifdef WATER_WRITES_TO_DEPTH
        float depth = LoadCameraDepth(varyings.positionCS.xy);
        bool screenWaterAlphaMask = !underwaterMask && (temporaryBlurTextureSample.y > 0.0);
        float screenWaterDepth = screenWaterAlphaMask ? UNITY_NEAR_CLIP_VALUE : 1.0 - UNITY_NEAR_CLIP_VALUE;
#if UNITY_REVERSED_Z
        outputDepth = max(screenWaterDepth, depth);
#else
        outputDepth = min(screenWaterDepth, depth);
#endif
#endif // WATER_WRITES_TO_DEPTH

        color *= 1.0 - temporaryBlurTextureSample.y * !underwaterMask * 0.1;
    
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
        depth = _WaterDepthTexture[varyings.positionCS.xy].x;
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
            Name "UnderwaterTintWriteDepth"

            ZWrite On
            ZTest LEqual
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