Shader "GOcean/OceanDistant"
{
    Properties
    {
        [NoScaleOffset]_FoamTexture("_FoamTexture", 2D) = "white" {}
        _Smoothness("_Smoothness", Range(0, 1)) = 0
        _DistantSmoothness("_DistantSmoothness", Range(0, 1)) = 0
        _DistantFoam("_DistantFoam", Range(0, 1)) = 0
        _WaterColor("_WaterColor", Color) = (0.256586, 0.4585838, 0.5849056, 0)
        _FoamColor("_FoamColor", Color) = (1, 1, 1, 0)
        _FoamTiling("_FoamTiling", Float) = 0
        _ScatteringFalloff("_ScatteringFalloff", Float) = 0
        _SecondaryFoamTiling("_SecondaryFoamTiling", Float) = 0
        _RefractionStrength("_RefractionStrength", Float) = 0
        _UnderwaterSurfaceEmissionStrength("_UnderwaterSurfaceEmissionStrength", Float) = 0
        _FoamOffsetSpeed("_FoamOffsetSpeed", Float) = 0
        _FoamHardness("_FoamHardness", Range(0, 1)) = 0.8
        _ChunkGridResolution("_ChunkGridResolution", Int) = 0
        _ChunkSize("_ChunkSize", Int) = 0
        _FoamTextureFadeDistance("_FoamTextureFadeDistance", Float) = 0
        _SmoothnessTransitionDistance("_SmoothnessTransitionDistance", Float) = 0
        [DiffusionProfile]_DiffusionProfile("_DiffusionProfile", Float) = 0
        [HideInInspector]_DiffusionProfile_Asset("_DiffusionProfile", Vector) = (0, 0, 0, 0)
        [HideInInspector]_EmissionColor("Color", Color) = (1, 1, 1, 1)
        [HideInInspector]_RenderQueueType("Float", Float) = 4
        [HideInInspector][ToggleUI]_AddPrecomputedVelocity("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_DepthOffsetEnable("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_ConservativeDepthOffsetEnable("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_TransparentWritingMotionVec("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_AlphaCutoffEnable("Boolean", Float) = 0
        [HideInInspector]_TransparentSortPriority("_TransparentSortPriority", Float) = 0
        [HideInInspector][ToggleUI]_UseShadowThreshold("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_DoubleSidedEnable("Boolean", Float) = 0
        [HideInInspector][Enum(Flip, 0, Mirror, 1, None, 2)]_DoubleSidedNormalMode("Float", Float) = 2
        [HideInInspector]_DoubleSidedConstants("Vector4", Vector) = (1, 1, -1, 0)
        [HideInInspector][Enum(Auto, 0, On, 1, Off, 2)]_DoubleSidedGIMode("Float", Float) = 0
        [HideInInspector][ToggleUI]_TransparentDepthPrepassEnable("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_TransparentDepthPostpassEnable("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_PerPixelSorting("Boolean", Float) = 0
        [HideInInspector]_SurfaceType("Float", Float) = 1
        [HideInInspector]_BlendMode("Float", Float) = 0
        [HideInInspector]_SrcBlend("Float", Float) = 1
        [HideInInspector]_DstBlend("Float", Float) = 0
        [HideInInspector]_DstBlend2("Float", Float) = 0
        [HideInInspector]_AlphaSrcBlend("Float", Float) = 1
        [HideInInspector]_AlphaDstBlend("Float", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_TransparentZWrite("Boolean", Float) = 0
        [HideInInspector]_CullMode("Float", Float) = 2
        [HideInInspector][ToggleUI]_EnableFogOnTransparent("Boolean", Float) = 1
        [HideInInspector]_CullModeForward("Float", Float) = 2
        [HideInInspector][Enum(Front, 1, Back, 2)]_TransparentCullMode("Float", Float) = 2
        [HideInInspector][Enum(UnityEngine.Rendering.HighDefinition.OpaqueCullMode)]_OpaqueCullMode("Float", Float) = 2
        [HideInInspector]_ZTestDepthEqualForOpaque("Float", Int) = 0
        [HideInInspector][Enum(UnityEngine.Rendering.CompareFunction)]_ZTestTransparent("Float", Float) = 0
        [HideInInspector][ToggleUI]_TransparentBackfaceEnable("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_RequireSplitLighting("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_ReceivesSSR("Boolean", Float) = 1
        [HideInInspector][ToggleUI]_ReceivesSSRTransparent("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_EnableBlendModePreserveSpecularLighting("Boolean", Float) = 1
        [HideInInspector][ToggleUI]_SupportDecals("Boolean", Float) = 1
        [HideInInspector][ToggleUI]_ExcludeFromTUAndAA("Boolean", Float) = 0
        [HideInInspector]_StencilRef("Float", Int) = 0
        [HideInInspector]_StencilWriteMask("Float", Int) = 6
        [HideInInspector]_StencilRefDepth("Float", Int) = 0
        [HideInInspector]_StencilWriteMaskDepth("Float", Int) = 9
        [HideInInspector]_StencilRefMV("Float", Int) = 32
        [HideInInspector]_StencilWriteMaskMV("Float", Int) = 41
        [HideInInspector]_StencilRefDistortionVec("Float", Int) = 4
        [HideInInspector]_StencilWriteMaskDistortionVec("Float", Int) = 4
        [HideInInspector]_StencilWriteMaskGBuffer("Float", Int) = 15
        [HideInInspector]_StencilRefGBuffer("Float", Int) = 2
        [HideInInspector]_ZTestGBuffer("Float", Int) = 4
        [HideInInspector][ToggleUI]_RayTracing("Boolean", Float) = 0
        [HideInInspector][Enum(None, 0, Planar, 1, Sphere, 2, Thin, 3)]_RefractionModel("Float", Float) = 0
        [HideInInspector][Enum(Translucent, 5)]_MaterialID("_MaterialID", Float) = 5
        [HideInInspector]_MaterialTypeMask("_MaterialTypeMask", Float) = 32
        [HideInInspector][ToggleUI]_TransmissionEnable("Boolean", Float) = 1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="HDRenderPipeline"
            "RenderType"="HDLitShader"
            "Queue"="Transparent+0"
            //"DisableBatching"="False"
            //"ShaderGraphShader"="true"
            //"ShaderGraphTargetId"="HDLitSubTarget"
        }
        
        Pass
        {
            Name "Forward"
            Tags
            {
                "LightMode" = "Forward"
            }
        
            Cull Back
            Blend Off
            ZTest LEqual
            ZWrite Off

            Stencil
            {
            }
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 4.5
            #pragma vertex Vert
            #pragma fragment Frag
            #pragma only_renderers d3d11 playstation xboxone xboxseries vulkan metal switch
        
            // Keywords
            #define _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ _ADD_PRECOMPUTED_VELOCITY
            #pragma shader_feature_local _ _TRANSPARENT_WRITES_MOTION_VEC _TRANSPARENT_REFRACTIVE_SORT
            #pragma shader_feature_local_fragment _ _ENABLE_FOG_ON_TRANSPARENT
            #pragma multi_compile _ DEBUG_DISPLAY
            #pragma shader_feature_local_fragment _ _DISABLE_DECALS
            #pragma shader_feature_local_fragment _ _DISABLE_SSR
            #pragma shader_feature_local_fragment _ _DISABLE_SSR_TRANSPARENT
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile_fragment _ PROBE_VOLUMES_L1 PROBE_VOLUMES_L2
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fragment _ SHADOWS_SHADOWMASK
            #pragma multi_compile_fragment DECALS_OFF DECALS_3RT DECALS_4RT
            #pragma multi_compile_fragment _ DECAL_SURFACE_GRADIENT
            #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
            #pragma multi_compile_fragment PUNCTUAL_SHADOW_LOW PUNCTUAL_SHADOW_MEDIUM PUNCTUAL_SHADOW_HIGH
            #pragma multi_compile_fragment DIRECTIONAL_SHADOW_LOW DIRECTIONAL_SHADOW_MEDIUM DIRECTIONAL_SHADOW_HIGH
            #pragma multi_compile_fragment AREA_SHADOW_MEDIUM AREA_SHADOW_HIGH
            #pragma multi_compile_fragment SCREEN_SPACE_SHADOWS_OFF SCREEN_SPACE_SHADOWS_ON
            #pragma multi_compile_fragment USE_FPTL_LIGHTLIST USE_CLUSTERED_LIGHTLIST
            #define _MATERIAL_FEATURE_TRANSMISSION
        
            // Defines
            #define SHADERPASS SHADERPASS_FORWARD
            #define SUPPORT_BLENDMODE_PRESERVE_SPECULAR_LIGHTING 1
            #define HAS_LIGHTLOOP 1
            #define RAYTRACING_SHADER_GRAPH_DEFAULT
            #define SHADER_LIT 1
            #define SUPPORT_GLOBAL_MIP_BIAS 1
            #define REQUIRE_DEPTH_TEXTURE
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/GeometricTools.hlsl" // Required by Tessellation.hlsl
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Tessellation.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl" // Required to be include before we include properties as it define DECLARE_STACK_CB
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl" // Required before including properties as it defines UNITY_TEXTURE_STREAMING_DEBUG_VARS
            // Always include Shader Graph version
            // Always include last to avoid double macros
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl" // Need to be here for Gradient struct definition
        
            // --------------------------------------------------
            // Defines
        
            // Attribute
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define HAVE_MESH_MODIFICATION
        
            //Strip down the FragInputs.hlsl (on graphics), so we can only optimize the interpolators we use.
            //if by accident something requests contents of FragInputs.hlsl, it will be caught as a compiler error
            //Frag inputs stripping is only enabled when FRAG_INPUTS_ENABLE_STRIPPING is set
            #if !defined(SHADER_STAGE_RAY_TRACING) && SHADERPASS != SHADERPASS_RAYTRACING_GBUFFER && SHADERPASS != SHADERPASS_FULL_SCREEN_DEBUG
            #define FRAG_INPUTS_ENABLE_STRIPPING
            #endif
            #define FRAG_INPUTS_USE_TEXCOORD1
            #define FRAG_INPUTS_USE_TEXCOORD2
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
        
            // Define when IsFontFaceNode is included in ShaderGraph
            #define VARYINGS_NEED_CULLFACE
        
            // Following two define are a workaround introduce in 10.1.x for RaytracingQualityNode
            // The ShaderGraph don't support correctly migration of this node as it serialize all the node data
            // in the json file making it impossible to uprgrade. Until we get a fix, we do a workaround here
            // to still allow us to rename the field and keyword of this node without breaking existing code.
            #ifdef RAYTRACING_SHADER_GRAPH_DEFAULT
            #define RAYTRACING_SHADER_GRAPH_HIGH
            #endif
        
            #ifdef RAYTRACING_SHADER_GRAPH_RAYTRACED
            #define RAYTRACING_SHADER_GRAPH_LOW
            #endif
            // end
        
            // We need isFrontFace when using double sided - it is not required for unlit as in case of unlit double sided only drive the cullmode
            // VARYINGS_NEED_CULLFACE can be define by VaryingsMeshToPS.FaceSign input if a IsFrontFace Node is included in the shader graph.
            #if defined(_DOUBLESIDED_ON) && !defined(VARYINGS_NEED_CULLFACE)
                #define VARYINGS_NEED_CULLFACE
            #endif
        
            // Specific Material Define
            #define _SPECULAR_OCCLUSION_FROM_AO 1
            #define _ENERGY_CONSERVING_SPECULAR 1
        
            // This shader support recursive rendering for raytracing
            #define HAVE_RECURSIVE_RENDERING
        
            // To handle SSR on transparent correctly with a possibility to enable/disable it per framesettings
            // we should have a code like this:
            // if !defined(_DISABLE_SSR_TRANSPARENT)
            // pragma multi_compile _ WRITE_NORMAL_BUFFER
            // endif
            // i.e we enable the multicompile only if we can receive SSR or not, and then C# code drive
            // it based on if SSR transparent in frame settings and not (and stripper can strip it).
            // this is currently not possible with our current preprocessor as _DISABLE_SSR_TRANSPARENT is a keyword not a define
            // so instead we used this and chose to pay the extra cost of normal write even if SSR transaprent is disabled.
            // Ideally the shader graph generator should handle it but condition below can't be handle correctly for now.
            #if SHADERPASS == SHADERPASS_TRANSPARENT_DEPTH_PREPASS
            #if !defined(_DISABLE_SSR_TRANSPARENT) && !defined(SHADER_UNLIT)
                #define WRITE_NORMAL_BUFFER
            #endif
            #endif
        
            // -- Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float _Smoothness;
            float4 _WaterColor;
            float4 _FoamColor;
            float4 _FoamTexture_TexelSize;
            float _FoamTiling;
            float _ScatteringFalloff;
            float _SecondaryFoamTiling;
            float _RefractionStrength;
            float _UnderwaterSurfaceEmissionStrength;
            float _FoamOffsetSpeed;
            float _FoamHardness;
            float _ChunkGridResolution;
            float _ChunkSize;
            float _DistantSmoothness;
            float _DistantFoam;
            float _FoamTextureFadeDistance;
            float _SmoothnessTransitionDistance;
            float _DiffusionProfile;
            float4 _EmissionColor;
            float _UseShadowThreshold;
            float4 _DoubleSidedConstants;
            UNITY_TEXTURE_STREAMING_DEBUG_VARS;
            float _BlendMode;
            float _EnableBlendModePreserveSpecularLighting;
            float _RayTracing;
            float _RefractionModel;
            float _MaterialID;
            float _MaterialTypeMask;
            CBUFFER_END
        
        
            // Object and Global properties
            SAMPLER(SamplerState_Linear_Repeat);
            SAMPLER(SamplerState_Trilinear_Repeat);
            TEXTURE2D(_FoamTexture);
            SAMPLER(sampler_FoamTexture);
        
            // Includes
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "ShaderInclude/GOcean_UnderwaterSampling.hlsl"
            #include "ShaderInclude/GOcean_Constants.hlsl"
            #include "ShaderInclude/GOcean_StochasticSampling.hlsl"
            #include "ShaderInclude/GOcean_HelperFunctions.hlsl"
            #include "ShaderInclude/GOcean_GlobalTextures.hlsl"
        
            StructuredBuffer<int2> _DepthPyramidMipLevelOffsets;

            struct SurfaceDescription
            {
                float3 BaseColor;
                float3 Emission;
                float Alpha;
                float3 BentNormal;
                float Smoothness;
                float Occlusion;
                float3 NormalWS;
                float TransmissionMask;
                float Thickness;
                float DiffusionProfileHash;
                float4 VTPackedFeedback;
            };
        
            SurfaceDescription SurfaceDescriptionFunction(FragInputs input, float3 viewDirection)
            {
                SurfaceDescription surface = (SurfaceDescription) 0;
    
                float distanceMask = length(input.positionRWS);
                float2 posNDC = input.positionSS.xy * _ScreenSize.zw;
                float3 positionAbsWS = input.positionRWS + _WorldSpaceCameraPos_Internal.xyz;
    
                float4 spectrumSample = StochasticSample(_SpectrumTexture, SamplerState_Trilinear_Repeat, positionAbsWS.xz / _PatchSize.x, 9.0);
    
                // normal
    
                float3 normal = float3(spectrumSample.x, 1.0, spectrumSample.y);
                normal = normalize(normal);
                normal = input.isFrontFace ? normal : -normal;
    
                // foam
    
                float foamTextureFadeDistance = saturate(distanceMask / _FoamTextureFadeDistance);
                float2 foamTextureCoord0 = (positionAbsWS.xz - _Time.x * _FoamOffsetSpeed) * _FoamTiling;
                float2 foamTextureCoord1 = (positionAbsWS.xz + _Time.x * _FoamOffsetSpeed) * _SecondaryFoamTiling;
                float foamTextureSample = _FoamTexture.Sample(SamplerState_Linear_Repeat, foamTextureCoord0).x;
                foamTextureSample *= _FoamTexture.Sample(SamplerState_Linear_Repeat, foamTextureCoord1).x * _FoamHardness * (1.0 - foamTextureFadeDistance);
                foamTextureSample += foamTextureFadeDistance * _DistantFoam;
    
                float foam = saturate(spectrumSample.w * 0.25 - foamTextureSample);
    
                // transmission
    
                float thickness = saturate(1.0 - spectrumSample.z / _ScatteringFalloff) + foam;
                float transmissionMask = 1.0 - foam;
    
                // smoothness
    
                float smoothness = saturate(1.0 - distanceMask / _SmoothnessTransitionDistance);
                smoothness *= smoothness;
                smoothness = lerp(_DistantSmoothness, _Smoothness, smoothness) * (1.0 - foam);
    
                // refraction
    
                float3 refractionCoord = float3(_RefractionStrength * normal.x, 0.0, _RefractionStrength * normal.z) + input.positionRWS;
                float4 refractionProj = mul(_ViewProjMatrix, float4(refractionCoord, 1.0));
                refractionCoord = refractionProj.xyz / refractionProj.w;
            #if UNITY_UV_STARTS_AT_TOP
                refractionCoord.y = -refractionCoord.y;
            #endif
                refractionCoord.xy = refractionCoord.xy * 0.5 + 0.5;
                float2 refractionCoordSS = clamp(refractionCoord.xy * _ScreenSize.xy, float2(0.0, 0.0), _ScreenSize.xy - 1.0);
                float2 refractionCoordRTScale = refractionCoord.xy * _RTHandleScale.xy;
    
                float refractedDepth = RawToViewDepth(refractionCoord.z, _ZBufferParams);
                float refractedSceneDepth = RawToViewDepth(LoadCameraDepth(refractionCoordSS), _ZBufferParams);
                float refractedDepthDelta = saturate(refractedSceneDepth - refractedDepth);
                refractedDepthDelta *= GetWaterSurfaceMask(_OceanScreenTexture[refractionCoordSS].x);

                refractionCoord.xy = lerp(posNDC, refractionCoord.xy, refractedDepthDelta);
                float3 refractedColor = LoadCameraColor(clamp(refractionCoord.xy * _ScreenSize.xy, float2(0.0, 0.0), _ScreenSize.xy - 1.0), 0.0);
    
                // water color
    
                float underwaterEmissionMask = dot(viewDirection, normal);
                underwaterEmissionMask *= underwaterEmissionMask;
    
                float3 underwaterEmission = clamp(refractedColor, 0.0, 100.0) * _UnderwaterSurfaceEmissionStrength * underwaterEmissionMask;
    
                float3 waterColor = _UnderwaterFogColor.xyz * 0.25;
                waterColor = (underwaterEmissionMask > 0.5) ? underwaterEmission : waterColor;
                waterColor = input.isFrontFace ? _UnderwaterFogColor.xyz * refractedColor : waterColor;
                waterColor *= _TemporaryBlurTexture[refractionCoordSS].x * input.isFrontFace * _LightRayStrength * 0.5 + 0.5;

                waterColor = lerp(waterColor, _FoamColor.xyz, foam);
    
                surface.BaseColor = waterColor;
                surface.Emission = float3(0.0, 0.0, 0.0);
                surface.Alpha = 1.0;
                surface.BentNormal = float3(1.0, 0.0, 0.0);
                surface.Smoothness = smoothness;
                surface.Occlusion = 1.0;
                surface.NormalWS = normal;
                surface.TransmissionMask = transmissionMask;
                surface.Thickness = thickness;
                surface.DiffusionProfileHash = _DiffusionProfile;
                surface.VTPackedFeedback = float4(1.0, 1.0, 1.0, 1.0);
    
                return surface;
            }
        
            // --------------------------------------------------
            // Build Surface Data (Specific Material)
        
            void ApplyDecalToSurfaceDataNoNormal(DecalSurfaceData decalSurfaceData, inout SurfaceData surfaceData);
        
            void ApplyDecalAndGetNormal(FragInputs fragInputs, PositionInputs posInput, SurfaceDescription surfaceDescription, inout SurfaceData surfaceData)
            {
                float3 doubleSidedConstants = float3(-1.0, -1.0, -1.0);
        
                #ifdef DECAL_NORMAL_BLENDING
                    // SG nodes don't ouptut surface gradients, so if decals require surf grad blending, we have to convert
                    // the normal to gradient before applying the decal. We then have to resolve the gradient back to world space
                    float3 normalTS;
        
        
                    normalTS = SurfaceGradientFromPerturbedNormal(fragInputs.tangentToWorld[2],
                    surfaceDescription.NormalWS);
        
                    #if HAVE_DECALS
                    if (_EnableDecals)
                    {
                        float alpha = 1.0;
                        alpha = surfaceDescription.Alpha;
        
                        DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, fragInputs, alpha);
                        ApplyDecalToSurfaceNormal(decalSurfaceData, fragInputs.tangentToWorld[2], normalTS);
                        ApplyDecalToSurfaceDataNoNormal(decalSurfaceData, surfaceData);
                    }
                    #endif
        
                    GetNormalWS_SG(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
                #else
                    // normal delivered to master node
                    GetNormalWS_SrcWS(fragInputs, surfaceDescription.NormalWS, surfaceData.normalWS, doubleSidedConstants);
        
                    #if HAVE_DECALS
                    if (_EnableDecals)
                    {
                        float alpha = 1.0;
                        alpha = surfaceDescription.Alpha;
        
                        // Both uses and modifies 'surfaceData.normalWS'.
                        DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, fragInputs, alpha);
                        ApplyDecalToSurfaceNormal(decalSurfaceData, surfaceData.normalWS.xyz);
                        ApplyDecalToSurfaceDataNoNormal(decalSurfaceData, surfaceData);
                    }
                    #endif
                #endif
            }

            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // specularOcclusion need to be init ahead of decal to quiet the compiler that modify the SurfaceData struct
                // however specularOcclusion can come from the graph, so need to be init here so it can be override.
                surfaceData.specularOcclusion = 1.0;
                surfaceData.thickness = 0.0;
        
                surfaceData.baseColor =                 surfaceDescription.BaseColor;
                surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
                surfaceData.ambientOcclusion =          surfaceDescription.Occlusion;
                surfaceData.transmissionMask =          surfaceDescription.TransmissionMask.xxx;
                surfaceData.thickness =                 surfaceDescription.Thickness;
                surfaceData.diffusionProfileHash =      asuint(surfaceDescription.DiffusionProfileHash);

                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        
                // These static material feature allow compile time optimization
                surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
        
                ApplyDecalAndGetNormal(fragInputs, posInput, surfaceDescription, surfaceData);
        
                surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
        
                surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
        
                bentNormalWS = surfaceData.normalWS;
        
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
                #ifdef DEBUG_DISPLAY
                #if !defined(SHADER_STAGE_RAY_TRACING)
                    // Mipmap mode debugging isn't supported with ray tracing as it relies on derivatives
                    if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                    {
                        #ifdef FRAG_INPUTS_USE_TEXCOORD0
                            surfaceData.baseColor = GET_TEXTURE_STREAMING_DEBUG(posInput.positionSS, fragInputs.texCoord0);
                        #else
                            surfaceData.baseColor = GET_TEXTURE_STREAMING_DEBUG_NO_UV(posInput.positionSS);
                        #endif
                        surfaceData.metallic = 0;
                    }
                #endif
        
                    // We need to call ApplyDebugToSurfaceData after filling the surfaceData and before filling builtinData
                    // as it can modify attribute use for static lighting
                    ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
                #endif
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
                #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                    // Just use the value passed through via the slot (not active otherwise)
                #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                    // If we have bent normal and ambient occlusion, process a specular occlusion
                    surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
                #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                    surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
                #endif
        
                #if defined(_ENABLE_GEOMETRIC_SPECULAR_AA) && !defined(SHADER_STAGE_RAY_TRACING)
                    surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
                #endif
            }
        
            // --------------------------------------------------
            // Get Surface And BuiltinData
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData RAY_TRACING_OPTIONAL_PARAMETERS)
            {
                // Don't dither if displaced tessellation (we're fading out the displacement instead to match the next LOD)
                #if !defined(SHADER_STAGE_RAY_TRACING) && !defined(_TESSELLATION_DISPLACEMENT)
                #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
                #endif
                #endif
        
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(fragInputs, V);

                #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    surfaceDescription.Alpha = 1.0f;
                }
                #endif

                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                #ifdef FRAG_INPUTS_USE_TEXCOORD1
                    float4 lightmapTexCoord1 = fragInputs.texCoord1;
                #else
                    float4 lightmapTexCoord1 = float4(0,0,0,0);
                #endif
        
                #ifdef FRAG_INPUTS_USE_TEXCOORD2
                    float4 lightmapTexCoord2 = fragInputs.texCoord2;
                #else
                    float4 lightmapTexCoord2 = float4(0,0,0,0);
                #endif
        
                float alpha = 1.0;
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal
                InitBuiltinData(posInput, alpha, bentNormalWS, -fragInputs.tangentToWorld[2], lightmapTexCoord1, lightmapTexCoord2, builtinData);
        
                // override sampleBakedGI - not used by Unlit
        		// When overriding GI, we need to force the isLightmap flag to make sure we don't add APV (sampled in the lightloop) on top of the overridden value (set at GBuffer stage)
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
                // Note this will not fully work on transparent surfaces (can check with _SURFACE_TYPE_TRANSPARENT define)
                // We will always overwrite vt feeback with the nearest. So behind transparent surfaces vt will not be resolved
                // This is a limitation of the current MRT approach.
                #ifdef UNITY_VIRTUAL_TEXTURING
                builtinData.vtPackedFeedback = surfaceDescription.VTPackedFeedback;
                #endif
        
                // TODO: We should generate distortion / distortionBlur for non distortion pass
                #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
                #endif
        
                // PostInitBuiltinData call ApplyDebugToBuiltinData
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
        
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            // --------------------------------------------------
            // Main
        
            #include "ShaderInclude/GOcean_Distant_Pass_Forward.hlsl"
        
            ENDHLSL
        }
    }
    
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "Rendering.HighDefinition.LitShaderGraphGUI" "UnityEngine.Rendering.HighDefinition.HDRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}