Shader "GOcean/Ocean"
{
    Properties
    {
        [NoScaleOffset]_TerrainHeightmapArrayTexture("_TerrainHeightmapArrayTexture", 2DArray) = "" {}
        [NoScaleOffset]_TerrainShoreWaveArrayTexture("_TerrainShoreWaveArrayTexture", 2DArray) = "" {}
        [NoScaleOffset]_FoamTexture("_FoamTexture", 2D) = "white" {}
        _Smoothness("_Smoothness", Range(0, 1)) = 0
        _WaterColor("_WaterColor", Color) = (0.256586, 0.4585838, 0.5849056, 0)
        _FoamColor("_FoamColor", Color) = (1, 1, 1, 0)
        _FoamTiling("_FoamTiling", Float) = 0
        _ScatteringFalloff("_ScatteringFalloff", Float) = 0
        _SecondaryFoamTiling("_SecondaryFoamTiling", Float) = 0
        _ShoreWaveFoamAmount("_ShoreWaveFoamAmount", Float) = 1
        _TerrainSize("_TerrainSize", Vector) = (0, 0, 0, 0)
        _TerrainPosScaledBounds("_TerrainPosScaledBounds", Vector) = (0, 0, 0, 0)
        _TerrainLookupResolution("_TerrainLookupResolution", Int) = 0
        _TerrainOffset("_TerrainOffset", Float) = 0
        _UVMultiplier("_UVMultiplier", Float) = 0
        _WaveDisplacementFade("_WaveDisplacementFade", Float) = 0
        _RefractionStrength("_RefractionStrength", Float) = 0
        _EdgeFoamStrength("_EdgeFoamStrength", Float) = 0
        _UnderwaterSurfaceEmissionStrength("_UnderwaterSurfaceEmissionStrength", Float) = 0
        _EdgeFoamFalloff("_EdgeFoamFalloff", Float) = 0
        _EdgeFoamWidth("_EdgeFoamWidth", Float) = 0
        _FoamOffsetSpeed("_FoamOffsetSpeed", Float) = 0
        _FoamHardness("_FoamHardness", Range(0, 1)) = 0.8
        _FoamTextureFadeDistance("_FoamTextureFadeDistance", Float) = 0
        _DistantFoam("_DistantFoam", Range(0, 1)) = 0
        _DisplacementMaxDistance("_DisplacementMaxDistance", Float) = 0
        [DiffusionProfile]_DiffusionProfile("_DiffusionProfile", Float) = 0
        [HideInInspector]_DiffusionProfile_Asset("_DiffusionProfile", Vector) = (0, 0, 0, 0)
        _SmoothnessTransitionDistance("_SmoothnessTransitionDistance", Float) = 0
        _DistantSmoothness("_DistantSmoothness", Float) = 0
        [HideInInspector]_EmissionColor("Color", Color) = (1, 1, 1, 1)
        [HideInInspector]_RenderQueueType("Float", Float) = 4
        [HideInInspector][ToggleUI]_AddPrecomputedVelocity("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_DepthOffsetEnable("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_ConservativeDepthOffsetEnable("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_TransparentWritingMotionVec("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_AlphaCutoffEnable("Boolean", Float) = 0
        [HideInInspector]_TransparentSortPriority("_TransparentSortPriority", Float) = 0
        [HideInInspector][ToggleUI]_UseShadowThreshold("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_DoubleSidedEnable("Boolean", Float) = 1
        [HideInInspector][Enum(Flip, 0, Mirror, 1, None, 2)]_DoubleSidedNormalMode("Float", Float) = 0
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
        [HideInInspector][ToggleUI]_ZWrite("Boolean", Float) = 1
        [HideInInspector][ToggleUI]_TransparentZWrite("Boolean", Float) = 1
        [HideInInspector]_CullMode("Float", Float) = 2
        [HideInInspector][ToggleUI]_EnableFogOnTransparent("Boolean", Float) = 1
        [HideInInspector]_CullModeForward("Float", Float) = 2
        [HideInInspector][Enum(Front, 1, Back, 2)]_TransparentCullMode("Float", Float) = 2
        [HideInInspector][Enum(UnityEngine.Rendering.HighDefinition.OpaqueCullMode)]_OpaqueCullMode("Float", Float) = 2
        [HideInInspector]_ZTestDepthEqualForOpaque("Float", Int) = 4
        [HideInInspector][Enum(UnityEngine.Rendering.CompareFunction)]_ZTestTransparent("Float", Float) = 4
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
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="HDLitSubTarget"
        }
        Pass
        {
            Name "Forward"
            Tags
            {
                "LightMode" = "Forward"
            }
        
            // Render State
            Cull [_CullModeForward]
        Blend [_SrcBlend] [_DstBlend], [_AlphaSrcBlend] [_AlphaDstBlend]
        Blend 1 One OneMinusSrcAlpha
        Blend 2 One [_DstBlend2]
        Blend 3 One [_DstBlend2]
        Blend 4 One OneMinusSrcAlpha
        ZTest [_ZTestDepthEqualForOpaque]
        ZWrite [_ZWrite]
        ColorMask [_ColorMaskTransparentVelOne] 1
        ColorMask [_ColorMaskTransparentVelTwo] 2
        Stencil
        {
        WriteMask [_StencilWriteMask]
        Ref [_StencilRef]
        CompFront Always
        PassFront Replace
        CompBack Always
        PassBack Replace
        }
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma instancing_options renderinglayer
        #pragma target 4.5
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma only_renderers d3d11 playstation xboxone xboxseries vulkan metal switch
        #pragma multi_compile_instancing
        
            // Keywords
            #pragma shader_feature _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local _ _DOUBLESIDED_ON
        #pragma shader_feature_local _ _ADD_PRECOMPUTED_VELOCITY
        #pragma shader_feature_local _ _TRANSPARENT_WRITES_MOTION_VEC _TRANSPARENT_REFRACTIVE_SORT
        #pragma shader_feature_local_fragment _ _ENABLE_FOG_ON_TRANSPARENT
        #pragma multi_compile _ DEBUG_DISPLAY
        #pragma shader_feature_local_fragment _ _DISABLE_DECALS
        #pragma shader_feature_local_raytracing _ _DISABLE_DECALS
        #pragma shader_feature_local_fragment _ _DISABLE_SSR
        #pragma shader_feature_local_raytracing _ _DISABLE_SSR
        #pragma shader_feature_local_fragment _ _DISABLE_SSR_TRANSPARENT
        #pragma shader_feature_local_raytracing _ _DISABLE_SSR_TRANSPARENT
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile_fragment _ PROBE_VOLUMES_L1 PROBE_VOLUMES_L2
        #pragma multi_compile_raytracing _ PROBE_VOLUMES_L1 PROBE_VOLUMES_L2
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile_fragment _ SHADOWS_SHADOWMASK
        #pragma multi_compile_raytracing _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment DECALS_OFF DECALS_3RT DECALS_4RT
        #pragma multi_compile_fragment _ DECAL_SURFACE_GRADIENT
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile_fragment PUNCTUAL_SHADOW_LOW PUNCTUAL_SHADOW_MEDIUM PUNCTUAL_SHADOW_HIGH
        #pragma multi_compile_fragment DIRECTIONAL_SHADOW_LOW DIRECTIONAL_SHADOW_MEDIUM DIRECTIONAL_SHADOW_HIGH
        #pragma multi_compile_fragment AREA_SHADOW_MEDIUM AREA_SHADOW_HIGH
        #pragma multi_compile_fragment SCREEN_SPACE_SHADOWS_OFF SCREEN_SPACE_SHADOWS_ON
        #pragma multi_compile_fragment USE_FPTL_LIGHTLIST USE_CLUSTERED_LIGHTLIST
        #pragma shader_feature_local _ _REFRACTION_PLANE _REFRACTION_SPHERE _REFRACTION_THIN
        #pragma shader_feature_local_fragment _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
        #pragma shader_feature_local_raytracing _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
        #pragma shader_feature_local_fragment _MATERIAL_FEATURE_TRANSMISSION
        #pragma shader_feature_local_raytracing _MATERIAL_FEATURE_TRANSMISSION
        #pragma shader_feature_local_fragment _MATERIAL_FEATURE_ANISOTROPY
        #pragma shader_feature_local_raytracing _MATERIAL_FEATURE_ANISOTROPY
        #pragma shader_feature_local_fragment _MATERIAL_FEATURE_IRIDESCENCE
        #pragma shader_feature_local_raytracing _MATERIAL_FEATURE_IRIDESCENCE
        #pragma shader_feature_local_fragment _MATERIAL_FEATURE_SPECULAR_COLOR
        #pragma shader_feature_local_raytracing _MATERIAL_FEATURE_SPECULAR_COLOR
        #pragma shader_feature_local_fragment _MATERIAL_FEATURE_COLORED_TRANSMISSION
        #pragma shader_feature_local_raytracing _MATERIAL_FEATURE_COLORED_TRANSMISSION
            #pragma multi_compile_fragment HAS_TERRAIN_OFF HAS_TERRAIN_ON
        
        #if defined(HAS_TERRAIN_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
            // Defines
            #define SHADERPASS SHADERPASS_FORWARD
        #define SUPPORT_BLENDMODE_PRESERVE_SPECULAR_LIGHTING 1
        #define HAS_LIGHTLOOP 1
        #define RAYTRACING_SHADER_GRAPH_DEFAULT
        #define SHADER_LIT 1
        #define SUPPORT_GLOBAL_MIP_BIAS 1
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define REQUIRE_DEPTH_TEXTURE
        #endif
        
            // For custom interpolators to inject a substruct definition before FragInputs definition,
            // allowing for FragInputs to capture CI's intended for ShaderGraph's SDI.
            struct CustomInterpolators
        {
        float2 UnmodPositionWSXZ;
        };
        #define USE_CUSTOMINTERP_SUBSTRUCT
        
        
        
            // TODO: Merge FragInputsVFX substruct with CustomInterpolators.
        	#ifdef HAVE_VFX_MODIFICATION
        	struct FragInputsVFX
            {
                /* WARNING: $splice Could not find named fragment 'FragInputsVFX' */
            };
            #endif
        
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
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_VERTEXID
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_TO_WORLD
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        
            #define HAVE_MESH_MODIFICATION
        
            //Strip down the FragInputs.hlsl (on graphics), so we can only optimize the interpolators we use.
            //if by accident something requests contents of FragInputs.hlsl, it will be caught as a compiler error
            //Frag inputs stripping is only enabled when FRAG_INPUTS_ENABLE_STRIPPING is set
            #if !defined(SHADER_STAGE_RAY_TRACING) && SHADERPASS != SHADERPASS_RAYTRACING_GBUFFER && SHADERPASS != SHADERPASS_FULL_SCREEN_DEBUG
            #define FRAG_INPUTS_ENABLE_STRIPPING
            #endif
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FRAG_INPUTS_USE_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FRAG_INPUTS_USE_TEXCOORD2
        #endif
        
        
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // Define when IsFontFaceNode is included in ShaderGraph
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_CULLFACE
        #endif
        
        
        
        
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
        
            #ifndef SHADER_UNLIT
            // We need isFrontFace when using double sided - it is not required for unlit as in case of unlit double sided only drive the cullmode
            // VARYINGS_NEED_CULLFACE can be define by VaryingsMeshToPS.FaceSign input if a IsFrontFace Node is included in the shader graph.
            #if defined(_DOUBLESIDED_ON) && !defined(VARYINGS_NEED_CULLFACE)
                #define VARYINGS_NEED_CULLFACE
            #endif
            #endif
        
            // Specific Material Define
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _SPECULAR_OCCLUSION_FROM_AO 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _ENERGY_CONSERVING_SPECULAR 1
        #endif
        
        
        #if _MATERIAL_FEATURE_COLORED_TRANSMISSION
            // Colored Transmission doesn't support clear coat
            #undef _MATERIAL_FEATURE_CLEAR_COAT
        #endif
        
        // If we use subsurface scattering, enable output split lighting (for forward pass)
        #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
        #endif
        
        // This shader support recursive rendering for raytracing
        #define HAVE_RECURSIVE_RENDERING
        
        // In Path Tracing, For all single-sided, refractive materials, we want to force a thin refraction model
        #if (SHADERPASS == SHADERPASS_PATH_TRACING) && !defined(_DOUBLESIDED_ON) && (defined(_REFRACTION_PLANE) || defined(_REFRACTION_SPHERE))
            #undef  _REFRACTION_PLANE
            #undef  _REFRACTION_SPHERE
            #define _REFRACTION_THIN
        #endif
            // Caution: we can use the define SHADER_UNLIT onlit after the above Material include as it is the Unlit template who define it
        
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
        
            // See Lit.shader
            #if SHADERPASS == SHADERPASS_MOTION_VECTORS && defined(WRITE_DECAL_BUFFER_AND_RENDERING_LAYER)
                #define WRITE_DECAL_BUFFER
            #endif
        
            #ifndef DEBUG_DISPLAY
                // In case of opaque we don't want to perform the alpha test, it is done in depth prepass and we use depth equal for ztest (setup from UI)
                // Don't do it with debug display mode as it is possible there is no depth prepass in this case
                #if !defined(_SURFACE_TYPE_TRANSPARENT)
                    #if SHADERPASS == SHADERPASS_FORWARD
                    #define SHADERPASS_FORWARD_BYPASS_ALPHA_TEST
                    #elif SHADERPASS == SHADERPASS_GBUFFER
                    #define SHADERPASS_GBUFFER_BYPASS_ALPHA_TEST
                    #endif
                #endif
            #endif
        
            // Define _DEFERRED_CAPABLE_MATERIAL for shader capable to run in deferred pass
            #if defined(SHADER_LIT) && !defined(_SURFACE_TYPE_TRANSPARENT)
                #define _DEFERRED_CAPABLE_MATERIAL
            #endif
        
            // Translate transparent motion vector define
            #if (defined(_TRANSPARENT_WRITES_MOTION_VEC) || defined(_TRANSPARENT_REFRACTIVE_SORT)) && defined(_SURFACE_TYPE_TRANSPARENT)
                #define _WRITE_TRANSPARENT_MOTION_VECTOR
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
        float _ShoreWaveFoamAmount;
        float3 _TerrainSize;
        float4 _TerrainPosScaledBounds;
        float _TerrainLookupResolution;
        float _TerrainOffset;
        float _UVMultiplier;
        float _WaveDisplacementFade;
        float _RefractionStrength;
        float _EdgeFoamStrength;
        float _UnderwaterSurfaceEmissionStrength;
        float _EdgeFoamFalloff;
        float _EdgeFoamWidth;
        float _FoamOffsetSpeed;
        float _FoamHardness;
        float _FoamTextureFadeDistance;
        float _DistantFoam;
        float _DisplacementMaxDistance;
        float _DiffusionProfile;
        float _SmoothnessTransitionDistance;
        float _DistantSmoothness;
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
        SAMPLER(SamplerState_Point_Clamp);
        SAMPLER(SamplerState_Trilinear_Repeat);
        TEXTURE2D_ARRAY(_TerrainShoreWaveArrayTexture);
        SAMPLER(sampler_TerrainShoreWaveArrayTexture);
        TEXTURE2D(_FoamTexture);
        SAMPLER(sampler_FoamTexture);
        TEXTURE2D_ARRAY(_TerrainHeightmapArrayTexture);
        SAMPLER(sampler_TerrainHeightmapArrayTexture);
        TEXTURE2D_ARRAY(_SpectrumTexture);
        SAMPLER(sampler_SpectrumTexture);
        TEXTURE2D(_OceanScreenTexture);
        SAMPLER(sampler_OceanScreenTexture);
        float4 _OceanScreenTexture_TexelSize;
        
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
        
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
        
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
            #include_with_pragmas "ShaderInclude/GOcean_GetTrisFromBuffer.hlsl"
        #include_with_pragmas "ShaderInclude/GOcean_Constants.hlsl"
        #include_with_pragmas "ShaderInclude/GOcean_StochasticSampling.hlsl"
        #include_with_pragmas "ShaderInclude/GOcean_TerrainHeightmapSampling.hlsl"
        #include_with_pragmas "ShaderInclude/GOcean_HelperFunctions.hlsl"
        #include_with_pragmas "ShaderInclude/GOcean_UnderwaterSampling.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct AttributesMesh
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint vertexID : VERTEXID_SEMANTIC;
            #endif
        };
        struct VaryingsMeshToPS
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionRWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float2 UnmodPositionWSXZ;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint VertexID;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceViewDirection;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float2 NDCPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float2 PixelPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 TimeParameters;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float FaceSign;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float2 UnmodPositionWSXZ;
            #endif
        };
        struct PackedVaryingsMeshToPS
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord1 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2 : INTERP2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 packed_positionRWS_UnmodPositionWSXZx : INTERP3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 packed_normalWS_UnmodPositionWSXZy : INTERP4;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
        };
        
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryingsMeshToPS PackVaryingsMeshToPS (VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            ZERO_INITIALIZE(PackedVaryingsMeshToPS, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.packed_positionRWS_UnmodPositionWSXZx.xyz = input.positionRWS;
            output.packed_positionRWS_UnmodPositionWSXZx.w = input.UnmodPositionWSXZ.x;
            output.packed_normalWS_UnmodPositionWSXZy.xyz = input.normalWS;
            output.packed_normalWS_UnmodPositionWSXZy.w = input.UnmodPositionWSXZ.y;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            return output;
        }
        
        VaryingsMeshToPS UnpackVaryingsMeshToPS (PackedVaryingsMeshToPS input)
        {
            VaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionRWS = input.packed_positionRWS_UnmodPositionWSXZx.xyz;
            output.UnmodPositionWSXZ.x = input.packed_positionRWS_UnmodPositionWSXZx.w;
            output.normalWS = input.packed_normalWS_UnmodPositionWSXZy.xyz;
            output.UnmodPositionWSXZ.y = input.packed_normalWS_UnmodPositionWSXZy.w;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            return output;
        }
        #endif
        
            // --------------------------------------------------
            // Graph
        
        
            // Graph Functions
            
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Negate_float(float In, out float Out)
        {
            Out = -1 * In;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_Add4Vec4SubGraph_07026c99c55e3a54cb1e77aca666fd51_float
        {
        };
        
        void SG_Add4Vec4SubGraph_07026c99c55e3a54cb1e77aca666fd51_float(float4 _a, float4 _b, float4 _c, float4 _d, Bindings_Add4Vec4SubGraph_07026c99c55e3a54cb1e77aca666fd51_float IN, out float4 output_0)
        {
        float4 _Property_ab94d689446e4b4ebfdb80027ecf00f0_Out_0_Vector4 = _a;
        float4 _Property_e4fb9d39609545ae94cdcfb486b44851_Out_0_Vector4 = _b;
        float4 _Add_5bd11e17b64240a79fdd99e3af999392_Out_2_Vector4;
        Unity_Add_float4(_Property_ab94d689446e4b4ebfdb80027ecf00f0_Out_0_Vector4, _Property_e4fb9d39609545ae94cdcfb486b44851_Out_0_Vector4, _Add_5bd11e17b64240a79fdd99e3af999392_Out_2_Vector4);
        float4 _Property_547e218e53d24afa994884085f7aa0ca_Out_0_Vector4 = _c;
        float4 _Add_132ec835641b4cfdb507c4212c36c714_Out_2_Vector4;
        Unity_Add_float4(_Add_5bd11e17b64240a79fdd99e3af999392_Out_2_Vector4, _Property_547e218e53d24afa994884085f7aa0ca_Out_0_Vector4, _Add_132ec835641b4cfdb507c4212c36c714_Out_2_Vector4);
        float4 _Property_0d6925c42a7142fbb1659382d1d3d0d6_Out_0_Vector4 = _d;
        float4 _Add_c5bc4daced0b4b3ba6eeb6481d9bd777_Out_2_Vector4;
        Unity_Add_float4(_Add_132ec835641b4cfdb507c4212c36c714_Out_2_Vector4, _Property_0d6925c42a7142fbb1659382d1d3d0d6_Out_0_Vector4, _Add_c5bc4daced0b4b3ba6eeb6481d9bd777_Out_2_Vector4);
        output_0 = _Add_c5bc4daced0b4b3ba6eeb6481d9bd777_Out_2_Vector4;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_LengthSquaredSubGraph_5fb6a36b61808c94a9029ab0b12558cc_float
        {
        };
        
        void SG_LengthSquaredSubGraph_5fb6a36b61808c94a9029ab0b12558cc_float(float2 _A, Bindings_LengthSquaredSubGraph_5fb6a36b61808c94a9029ab0b12558cc_float IN, out float output_0)
        {
        float2 _Property_c22349a2c2b04c5fbbf9e57701a996f5_Out_0_Vector2 = _A;
        float _Split_aabc601799e54e0ca36e187ee3f4c0c6_R_1_Float = _Property_c22349a2c2b04c5fbbf9e57701a996f5_Out_0_Vector2[0];
        float _Split_aabc601799e54e0ca36e187ee3f4c0c6_G_2_Float = _Property_c22349a2c2b04c5fbbf9e57701a996f5_Out_0_Vector2[1];
        float _Split_aabc601799e54e0ca36e187ee3f4c0c6_B_3_Float = 0;
        float _Split_aabc601799e54e0ca36e187ee3f4c0c6_A_4_Float = 0;
        float _Multiply_3af8544c00a845f99fa96dc1a341c176_Out_2_Float;
        Unity_Multiply_float_float(_Split_aabc601799e54e0ca36e187ee3f4c0c6_R_1_Float, _Split_aabc601799e54e0ca36e187ee3f4c0c6_R_1_Float, _Multiply_3af8544c00a845f99fa96dc1a341c176_Out_2_Float);
        float _Multiply_17f5c6e556714cbbafdd8a7606df0fcd_Out_2_Float;
        Unity_Multiply_float_float(_Split_aabc601799e54e0ca36e187ee3f4c0c6_G_2_Float, _Split_aabc601799e54e0ca36e187ee3f4c0c6_G_2_Float, _Multiply_17f5c6e556714cbbafdd8a7606df0fcd_Out_2_Float);
        float _Add_b6a43a22c2e94e469b57621c5bf3b562_Out_2_Float;
        Unity_Add_float(_Multiply_3af8544c00a845f99fa96dc1a341c176_Out_2_Float, _Multiply_17f5c6e556714cbbafdd8a7606df0fcd_Out_2_Float, _Add_b6a43a22c2e94e469b57621c5bf3b562_Out_2_Float);
        output_0 = _Add_b6a43a22c2e94e469b57621c5bf3b562_Out_2_Float;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Minimum_float(float A, float B, out float Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        // unity-custom-func-begin
        void RoundToZero_float(float2 input, out float2 output){
            input.x = abs(input.x) < 0.01 ? 0.0 : input.x;
            input.y = abs(input.y) < 0.01 ? 0.0 : input.y;
            output = input;
        }
        // unity-custom-func-end
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // unity-custom-func-begin
        void TransformWorldPosToClipPos_float(float3 posWS, out float4 posCS){
            posCS = mul(_ViewProjMatrix, float4(posWS, 1.0));
            posCS /= posCS.w;
            #if UNITY_UV_STARTS_AT_TOP
            posCS.y = -posCS.y;
            #endif
        }
        // unity-custom-func-end
        
        StructuredBuffer<int2> _DepthPyramidMipLevelOffsets;
        float Unity_HDRP_SampleSceneDepth_float(float2 uv, float lod)
        {
            #if defined(REQUIRE_DEPTH_TEXTURE) && defined(SHADERPASS) && (SHADERPASS != SHADERPASS_LIGHT_TRANSPORT)
            int2 coord = int2(uv * _ScreenSize.xy);
            int2 mipCoord  = coord.xy >> int(lod);
            int2 mipOffset = _DepthPyramidMipLevelOffsets[int(lod)];
            return LOAD_TEXTURE2D_X(_CameraDepthTexture, mipOffset + mipCoord).r;
            #endif
            return 0.0;
        }
        
        // unity-custom-func-begin
        void GetZBufferParams_float(out float4 zBufferParams){
            zBufferParams = _ZBufferParams;
        }
        // unity-custom-func-end
        
        // unity-custom-func-begin
        void GetRTHandleScale_float(out float4 RTHandleScale){
            RTHandleScale = _RTHandleScale;
        }
        // unity-custom-func-end
        
        void Unity_Lerp_float2(float2 A, float2 B, float2 T, out float2 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float2(float2 In, float2 Min, float2 Max, out float2 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // unity-custom-func-begin
        void LoadSceneColor_float(float2 coord, float lod, out float3 sceneColor){
            sceneColor = LoadCameraColor(coord, lod);
        }
        // unity-custom-func-end
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        // unity-custom-func-begin
        void IsNotFarPlane_float(float rawDepth, out float isNotFarPlane){
            #if UNITY_REVERSED_Z
            isNotFarPlane = rawDepth != 0.0;
            #else
            isNotFarPlane = rawDepth != 1.0;
            #endif
        }
        // unity-custom-func-end
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
            float2 UnmodPositionWSXZ;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _GetVertexFromTriCustomFunction_3356fec0bd1645709e751a1712f460e6_position_1_Vector2;
            float3 _GetVertexFromTriCustomFunction_3356fec0bd1645709e751a1712f460e6_displacedPosition_3_Vector3;
            GetVertexFromTri_float(IN.VertexID, _GetVertexFromTriCustomFunction_3356fec0bd1645709e751a1712f460e6_position_1_Vector2, _GetVertexFromTriCustomFunction_3356fec0bd1645709e751a1712f460e6_displacedPosition_3_Vector3);
            #endif
            description.Position = _GetVertexFromTriCustomFunction_3356fec0bd1645709e751a1712f460e6_displacedPosition_3_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            description.UnmodPositionWSXZ = _GetVertexFromTriCustomFunction_3356fec0bd1645709e751a1712f460e6_position_1_Vector2;
            return description;
        }
        
            // Graph Pixel
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
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _GetUnderwaterFogColorCustomFunction_f1cb1c8de8b74d258428f851e73117ab_underwaterFogColor_0_Vector3;
            GetUnderwaterFogColor_float(_GetUnderwaterFogColorCustomFunction_f1cb1c8de8b74d258428f851e73117ab_underwaterFogColor_0_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Float_7132071225d5490eb80c4a2ea6727b48_Out_0_Float = float(0.3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_8946ebc8bea54f92aefc81c3696d0b88_Out_2_Vector3;
            Unity_Multiply_float3_float3(_GetUnderwaterFogColorCustomFunction_f1cb1c8de8b74d258428f851e73117ab_underwaterFogColor_0_Vector3, (_Float_7132071225d5490eb80c4a2ea6727b48_Out_0_Float.xxx), _Multiply_8946ebc8bea54f92aefc81c3696d0b88_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_2765578c02ea45d2a96f032b8d86696f_Out_0_Vector2 = float2(_ScreenParams.x, _ScreenParams.y);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _ScreenPosition_6a8f60e839bd499789e4c0b9816015ef_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9a25ed7c99a74780869574c8f4ae6875_Out_0_Float = _RefractionStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Negate_87d37677ec3448d89d747262dd35142f_Out_1_Float;
            Unity_Negate_float(_Property_9a25ed7c99a74780869574c8f4ae6875_Out_0_Float, _Negate_87d37677ec3448d89d747262dd35142f_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2DArray _Property_bc82f7d702214e1094add6aabfccce3b_Out_0_Texture2DArray = UnityBuildTexture2DArrayStruct(_SpectrumTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _GetPatchSizeCustomFunction_fc4a900e219c4dc6baa9f088cb2f1d7e_patchSize_0_Vector4;
            GetPatchSize_float(_GetPatchSizeCustomFunction_fc4a900e219c4dc6baa9f088cb2f1d7e_patchSize_0_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_22daf027e91748a4bf57fa97f7af9910_R_1_Float = _GetPatchSizeCustomFunction_fc4a900e219c4dc6baa9f088cb2f1d7e_patchSize_0_Vector4[0];
            float _Split_22daf027e91748a4bf57fa97f7af9910_G_2_Float = _GetPatchSizeCustomFunction_fc4a900e219c4dc6baa9f088cb2f1d7e_patchSize_0_Vector4[1];
            float _Split_22daf027e91748a4bf57fa97f7af9910_B_3_Float = _GetPatchSizeCustomFunction_fc4a900e219c4dc6baa9f088cb2f1d7e_patchSize_0_Vector4[2];
            float _Split_22daf027e91748a4bf57fa97f7af9910_A_4_Float = _GetPatchSizeCustomFunction_fc4a900e219c4dc6baa9f088cb2f1d7e_patchSize_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Divide_3bd6bc0225a548f3b6cc1eafd1e21698_Out_2_Vector2;
            Unity_Divide_float2(IN.UnmodPositionWSXZ, (_Split_22daf027e91748a4bf57fa97f7af9910_R_1_Float.xx), _Divide_3bd6bc0225a548f3b6cc1eafd1e21698_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2DArray_fb1d6f3948584bf8b70a82d33ce4ac36_RGBA_0_Vector4 = PLATFORM_SAMPLE_TEXTURE2D_ARRAY(_Property_bc82f7d702214e1094add6aabfccce3b_Out_0_Texture2DArray.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Divide_3bd6bc0225a548f3b6cc1eafd1e21698_Out_2_Vector2, float(1) );
            float _SampleTexture2DArray_fb1d6f3948584bf8b70a82d33ce4ac36_R_4_Float = _SampleTexture2DArray_fb1d6f3948584bf8b70a82d33ce4ac36_RGBA_0_Vector4.r;
            float _SampleTexture2DArray_fb1d6f3948584bf8b70a82d33ce4ac36_G_5_Float = _SampleTexture2DArray_fb1d6f3948584bf8b70a82d33ce4ac36_RGBA_0_Vector4.g;
            float _SampleTexture2DArray_fb1d6f3948584bf8b70a82d33ce4ac36_B_6_Float = _SampleTexture2DArray_fb1d6f3948584bf8b70a82d33ce4ac36_RGBA_0_Vector4.b;
            float _SampleTexture2DArray_fb1d6f3948584bf8b70a82d33ce4ac36_A_7_Float = _SampleTexture2DArray_fb1d6f3948584bf8b70a82d33ce4ac36_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2DArray _Property_1032645637bd4253939ddd206158582d_Out_0_Texture2DArray = UnityBuildTexture2DArrayStruct(_SpectrumTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Divide_853d533f683947428a587e2f06eb034a_Out_2_Vector2;
            Unity_Divide_float2(IN.UnmodPositionWSXZ, (_Split_22daf027e91748a4bf57fa97f7af9910_G_2_Float.xx), _Divide_853d533f683947428a587e2f06eb034a_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2DArray_4eb7294f43fc4e6a9f2291b1b1afeff5_RGBA_0_Vector4 = PLATFORM_SAMPLE_TEXTURE2D_ARRAY(_Property_1032645637bd4253939ddd206158582d_Out_0_Texture2DArray.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Divide_853d533f683947428a587e2f06eb034a_Out_2_Vector2, float(3) );
            float _SampleTexture2DArray_4eb7294f43fc4e6a9f2291b1b1afeff5_R_4_Float = _SampleTexture2DArray_4eb7294f43fc4e6a9f2291b1b1afeff5_RGBA_0_Vector4.r;
            float _SampleTexture2DArray_4eb7294f43fc4e6a9f2291b1b1afeff5_G_5_Float = _SampleTexture2DArray_4eb7294f43fc4e6a9f2291b1b1afeff5_RGBA_0_Vector4.g;
            float _SampleTexture2DArray_4eb7294f43fc4e6a9f2291b1b1afeff5_B_6_Float = _SampleTexture2DArray_4eb7294f43fc4e6a9f2291b1b1afeff5_RGBA_0_Vector4.b;
            float _SampleTexture2DArray_4eb7294f43fc4e6a9f2291b1b1afeff5_A_7_Float = _SampleTexture2DArray_4eb7294f43fc4e6a9f2291b1b1afeff5_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2DArray _Property_0e7f096fa4c840f3a248f1d9947e5bc1_Out_0_Texture2DArray = UnityBuildTexture2DArrayStruct(_SpectrumTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Divide_40c9e27701724884a9277fe59939334c_Out_2_Vector2;
            Unity_Divide_float2(IN.UnmodPositionWSXZ, (_Split_22daf027e91748a4bf57fa97f7af9910_B_3_Float.xx), _Divide_40c9e27701724884a9277fe59939334c_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2DArray_aad4a78162734a4c8b0dfc479257b88e_RGBA_0_Vector4 = PLATFORM_SAMPLE_TEXTURE2D_ARRAY(_Property_0e7f096fa4c840f3a248f1d9947e5bc1_Out_0_Texture2DArray.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Divide_40c9e27701724884a9277fe59939334c_Out_2_Vector2, float(5) );
            float _SampleTexture2DArray_aad4a78162734a4c8b0dfc479257b88e_R_4_Float = _SampleTexture2DArray_aad4a78162734a4c8b0dfc479257b88e_RGBA_0_Vector4.r;
            float _SampleTexture2DArray_aad4a78162734a4c8b0dfc479257b88e_G_5_Float = _SampleTexture2DArray_aad4a78162734a4c8b0dfc479257b88e_RGBA_0_Vector4.g;
            float _SampleTexture2DArray_aad4a78162734a4c8b0dfc479257b88e_B_6_Float = _SampleTexture2DArray_aad4a78162734a4c8b0dfc479257b88e_RGBA_0_Vector4.b;
            float _SampleTexture2DArray_aad4a78162734a4c8b0dfc479257b88e_A_7_Float = _SampleTexture2DArray_aad4a78162734a4c8b0dfc479257b88e_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2DArray _Property_029d73c5f1714fcab66aece76faa698a_Out_0_Texture2DArray = UnityBuildTexture2DArrayStruct(_SpectrumTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Divide_3c992d1b3c04407ab3e7a37aaa1cf579_Out_2_Vector2;
            Unity_Divide_float2(IN.UnmodPositionWSXZ, (_Split_22daf027e91748a4bf57fa97f7af9910_A_4_Float.xx), _Divide_3c992d1b3c04407ab3e7a37aaa1cf579_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2DArray_7176089b8de74269b62eea2c7a3d14f0_RGBA_0_Vector4 = PLATFORM_SAMPLE_TEXTURE2D_ARRAY(_Property_029d73c5f1714fcab66aece76faa698a_Out_0_Texture2DArray.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Divide_3c992d1b3c04407ab3e7a37aaa1cf579_Out_2_Vector2, float(7) );
            float _SampleTexture2DArray_7176089b8de74269b62eea2c7a3d14f0_R_4_Float = _SampleTexture2DArray_7176089b8de74269b62eea2c7a3d14f0_RGBA_0_Vector4.r;
            float _SampleTexture2DArray_7176089b8de74269b62eea2c7a3d14f0_G_5_Float = _SampleTexture2DArray_7176089b8de74269b62eea2c7a3d14f0_RGBA_0_Vector4.g;
            float _SampleTexture2DArray_7176089b8de74269b62eea2c7a3d14f0_B_6_Float = _SampleTexture2DArray_7176089b8de74269b62eea2c7a3d14f0_RGBA_0_Vector4.b;
            float _SampleTexture2DArray_7176089b8de74269b62eea2c7a3d14f0_A_7_Float = _SampleTexture2DArray_7176089b8de74269b62eea2c7a3d14f0_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_Add4Vec4SubGraph_07026c99c55e3a54cb1e77aca666fd51_float _Add4Vec4SubGraph_352df0d4849a4cf3bb62a24bf8a3c826;
            float4 _Add4Vec4SubGraph_352df0d4849a4cf3bb62a24bf8a3c826_output_0_Vector4;
            SG_Add4Vec4SubGraph_07026c99c55e3a54cb1e77aca666fd51_float(_SampleTexture2DArray_fb1d6f3948584bf8b70a82d33ce4ac36_RGBA_0_Vector4, _SampleTexture2DArray_4eb7294f43fc4e6a9f2291b1b1afeff5_RGBA_0_Vector4, _SampleTexture2DArray_aad4a78162734a4c8b0dfc479257b88e_RGBA_0_Vector4, _SampleTexture2DArray_7176089b8de74269b62eea2c7a3d14f0_RGBA_0_Vector4, _Add4Vec4SubGraph_352df0d4849a4cf3bb62a24bf8a3c826, _Add4Vec4SubGraph_352df0d4849a4cf3bb62a24bf8a3c826_output_0_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2DArray _Property_eb773d486c9c40c4afa73456497c3027_Out_0_Texture2DArray = UnityBuildTexture2DArrayStruct(_SpectrumTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _StochasticSampleTex2DArrayCustomFunction_76561873c40c4f3483feb6ae793ebe92_output_4_Vector4;
            StochasticSampleTex2DArray_float(_Property_eb773d486c9c40c4afa73456497c3027_Out_0_Texture2DArray.tex, UnityBuildSamplerStateStruct(SamplerState_Trilinear_Repeat).samplerstate, _Divide_3bd6bc0225a548f3b6cc1eafd1e21698_Out_2_Vector2, float(9), _StochasticSampleTex2DArrayCustomFunction_76561873c40c4f3483feb6ae793ebe92_output_4_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _GetWaterHeightCustomFunction_37fc860bf874428e9bda94b1545a6d10_waterHeight_0_Float;
            GetWaterHeight_float(_GetWaterHeightCustomFunction_37fc860bf874428e9bda94b1545a6d10_waterHeight_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_96b6ae282aa14d95a6efaa9fc58ae045_R_1_Float = _WorldSpaceCameraPos[0];
            float _Split_96b6ae282aa14d95a6efaa9fc58ae045_G_2_Float = _WorldSpaceCameraPos[1];
            float _Split_96b6ae282aa14d95a6efaa9fc58ae045_B_3_Float = _WorldSpaceCameraPos[2];
            float _Split_96b6ae282aa14d95a6efaa9fc58ae045_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_0af98632f604438fa781d0674ecab9e1_Out_2_Float;
            Unity_Subtract_float(_GetWaterHeightCustomFunction_37fc860bf874428e9bda94b1545a6d10_waterHeight_0_Float, _Split_96b6ae282aa14d95a6efaa9fc58ae045_G_2_Float, _Subtract_0af98632f604438fa781d0674ecab9e1_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_9c9116dbda9b4e9b85cac8f7a2b652d0_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_0af98632f604438fa781d0674ecab9e1_Out_2_Float, _Subtract_0af98632f604438fa781d0674ecab9e1_Out_2_Float, _Multiply_9c9116dbda9b4e9b85cac8f7a2b652d0_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Swizzle_d2542c7862eb421d89d00ecbf7d1e2a7_Out_1_Vector2 = _WorldSpaceCameraPos.xz;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Subtract_0b2fc1d139e0449cae57b16128c148f1_Out_2_Vector2;
            Unity_Subtract_float2(_Swizzle_d2542c7862eb421d89d00ecbf7d1e2a7_Out_1_Vector2, IN.UnmodPositionWSXZ, _Subtract_0b2fc1d139e0449cae57b16128c148f1_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_LengthSquaredSubGraph_5fb6a36b61808c94a9029ab0b12558cc_float _LengthSquaredSubGraph_9b287be4f58e46198afb4137e2063740;
            float _LengthSquaredSubGraph_9b287be4f58e46198afb4137e2063740_output_0_Float;
            SG_LengthSquaredSubGraph_5fb6a36b61808c94a9029ab0b12558cc_float(_Subtract_0b2fc1d139e0449cae57b16128c148f1_Out_2_Vector2, _LengthSquaredSubGraph_9b287be4f58e46198afb4137e2063740, _LengthSquaredSubGraph_9b287be4f58e46198afb4137e2063740_output_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_63b0e1bc49774c4191dea158479163e2_Out_2_Float;
            Unity_Add_float(_Multiply_9c9116dbda9b4e9b85cac8f7a2b652d0_Out_2_Float, _LengthSquaredSubGraph_9b287be4f58e46198afb4137e2063740_output_0_Float, _Add_63b0e1bc49774c4191dea158479163e2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_9640851a34cd46888d84cd0fab3eae31_Out_1_Float;
            Unity_SquareRoot_float(_Add_63b0e1bc49774c4191dea158479163e2_Out_2_Float, _SquareRoot_9640851a34cd46888d84cd0fab3eae31_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9bde1fc2c7e54d789a631753475600e1_Out_0_Float = _DisplacementMaxDistance;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Minimum_987db9f75f8f46e083ef42e52c701621_Out_2_Float;
            Unity_Minimum_float(_Property_9bde1fc2c7e54d789a631753475600e1_Out_0_Float, _Split_22daf027e91748a4bf57fa97f7af9910_R_1_Float, _Minimum_987db9f75f8f46e083ef42e52c701621_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Minimum_fbebf95b7dde467ab0e5356ccf458fe7_Out_2_Float;
            Unity_Minimum_float(_Minimum_987db9f75f8f46e083ef42e52c701621_Out_2_Float, _ProjectionParams.z, _Minimum_fbebf95b7dde467ab0e5356ccf458fe7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_aa93661139b649c9928ddc69dbad0a28_Out_2_Float;
            Unity_Divide_float(_SquareRoot_9640851a34cd46888d84cd0fab3eae31_Out_1_Float, _Minimum_fbebf95b7dde467ab0e5356ccf458fe7_Out_2_Float, _Divide_aa93661139b649c9928ddc69dbad0a28_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_7d0ea79769fe46a49d43f78faebab1ee_Out_1_Float;
            Unity_Saturate_float(_Divide_aa93661139b649c9928ddc69dbad0a28_Out_2_Float, _Saturate_7d0ea79769fe46a49d43f78faebab1ee_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_511660c66f72420292cb5e799ffef931_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_7d0ea79769fe46a49d43f78faebab1ee_Out_1_Float, _Saturate_7d0ea79769fe46a49d43f78faebab1ee_Out_1_Float, _Multiply_511660c66f72420292cb5e799ffef931_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Lerp_0497e5e45c724f359b02db458bd81a91_Out_3_Vector4;
            Unity_Lerp_float4(_Add4Vec4SubGraph_352df0d4849a4cf3bb62a24bf8a3c826_output_0_Vector4, _StochasticSampleTex2DArrayCustomFunction_76561873c40c4f3483feb6ae793ebe92_output_4_Vector4, (_Multiply_511660c66f72420292cb5e799ffef931_Out_2_Float.xxxx), _Lerp_0497e5e45c724f359b02db458bd81a91_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_03a0a8a4354c481a8ebb5550b9562024_R_1_Float = _Lerp_0497e5e45c724f359b02db458bd81a91_Out_3_Vector4[0];
            float _Split_03a0a8a4354c481a8ebb5550b9562024_G_2_Float = _Lerp_0497e5e45c724f359b02db458bd81a91_Out_3_Vector4[1];
            float _Split_03a0a8a4354c481a8ebb5550b9562024_B_3_Float = _Lerp_0497e5e45c724f359b02db458bd81a91_Out_3_Vector4[2];
            float _Split_03a0a8a4354c481a8ebb5550b9562024_A_4_Float = _Lerp_0497e5e45c724f359b02db458bd81a91_Out_3_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_a51f89048e0b4325a8dd05096539c984_Out_0_Vector2 = float2(_Split_03a0a8a4354c481a8ebb5550b9562024_R_1_Float, _Split_03a0a8a4354c481a8ebb5550b9562024_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Property_d54eac6761a54c07b76579fc4deb738a_Out_0_Vector3 = _TerrainSize;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_ba66504d75854f228917e2119bf76b3b_R_1_Float = _Property_d54eac6761a54c07b76579fc4deb738a_Out_0_Vector3[0];
            float _Split_ba66504d75854f228917e2119bf76b3b_G_2_Float = _Property_d54eac6761a54c07b76579fc4deb738a_Out_0_Vector3[1];
            float _Split_ba66504d75854f228917e2119bf76b3b_B_3_Float = _Property_d54eac6761a54c07b76579fc4deb738a_Out_0_Vector3[2];
            float _Split_ba66504d75854f228917e2119bf76b3b_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_54b8041ee0c14dedb204b251e9203ccf_Out_2_Float;
            Unity_Multiply_float_float(_Split_ba66504d75854f228917e2119bf76b3b_R_1_Float, _Split_ba66504d75854f228917e2119bf76b3b_R_1_Float, _Multiply_54b8041ee0c14dedb204b251e9203ccf_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_cf9d7673e5694db7aefbfef87df2a4b0_Out_2_Float;
            Unity_Divide_float(_LengthSquaredSubGraph_9b287be4f58e46198afb4137e2063740_output_0_Float, _Multiply_54b8041ee0c14dedb204b251e9203ccf_Out_2_Float, _Divide_cf9d7673e5694db7aefbfef87df2a4b0_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Property_7753279ab58c4296a282d891cb4fb251_Out_0_Vector3 = _TerrainSize;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_faf1d98221ef44eeb235fe6b7b9bdae5_Out_0_Vector4 = _TerrainPosScaledBounds;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c2ae5fac7f1443b9b8ba2b218ab43bea_Out_0_Float = _TerrainOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_6b91455a917e4a54be00361275ea1b5d_Out_0_Float = _UVMultiplier;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _GetTerrainLookupCoordOffsetCustomFunction_07f844c1510d47a4a7a159b8cec7a820_terrainLookupCoordOffset_0_Vector2;
            GetTerrainLookupCoordOffset_float(_GetTerrainLookupCoordOffsetCustomFunction_07f844c1510d47a4a7a159b8cec7a820_terrainLookupCoordOffset_0_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_8fc23bc327d0456ba0cfbb4e1ce5d1c9_Out_0_Float = _TerrainLookupResolution;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _GetValidTerrainHeightmapMaskCustomFunction_eb6868c6e158499b84570f1b64af6f27_validTerrainHeightmapMask_0_Float;
            GetValidTerrainHeightmapMask_float(_GetValidTerrainHeightmapMaskCustomFunction_eb6868c6e158499b84570f1b64af6f27_validTerrainHeightmapMask_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_slice_7_Float;
            float2 _GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_uv_8_Vector2;
            float _GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_valid_9_Boolean;
            GetTerrainSamplingData_float(IN.UnmodPositionWSXZ, _Property_7753279ab58c4296a282d891cb4fb251_Out_0_Vector3, _Property_faf1d98221ef44eeb235fe6b7b9bdae5_Out_0_Vector4, (_Property_c2ae5fac7f1443b9b8ba2b218ab43bea_Out_0_Float.xx), _Property_6b91455a917e4a54be00361275ea1b5d_Out_0_Float, _GetTerrainLookupCoordOffsetCustomFunction_07f844c1510d47a4a7a159b8cec7a820_terrainLookupCoordOffset_0_Vector2, _Property_8fc23bc327d0456ba0cfbb4e1ce5d1c9_Out_0_Float, _GetValidTerrainHeightmapMaskCustomFunction_eb6868c6e158499b84570f1b64af6f27_validTerrainHeightmapMask_0_Float, _GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_slice_7_Float, _GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_uv_8_Vector2, _GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_valid_9_Boolean);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _GetWaterHeightCustomFunction_15a217bb0aba4acb832b7a2dec9f2fc7_waterHeight_0_Float;
            GetWaterHeight_float(_GetWaterHeightCustomFunction_15a217bb0aba4acb832b7a2dec9f2fc7_waterHeight_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2DArray _Property_2bde1a34a88e4076bc8c4b1f01447e47_Out_0_Texture2DArray = UnityBuildTexture2DArrayStruct(_TerrainHeightmapArrayTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2DArray_c8eb4e7af01b45f69d050e13d975e088_RGBA_0_Vector4 = PLATFORM_SAMPLE_TEXTURE2D_ARRAY(_Property_2bde1a34a88e4076bc8c4b1f01447e47_Out_0_Texture2DArray.tex, _Property_2bde1a34a88e4076bc8c4b1f01447e47_Out_0_Texture2DArray.samplerstate, _GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_uv_8_Vector2, _GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_slice_7_Float );
            float _SampleTexture2DArray_c8eb4e7af01b45f69d050e13d975e088_R_4_Float = _SampleTexture2DArray_c8eb4e7af01b45f69d050e13d975e088_RGBA_0_Vector4.r;
            float _SampleTexture2DArray_c8eb4e7af01b45f69d050e13d975e088_G_5_Float = _SampleTexture2DArray_c8eb4e7af01b45f69d050e13d975e088_RGBA_0_Vector4.g;
            float _SampleTexture2DArray_c8eb4e7af01b45f69d050e13d975e088_B_6_Float = _SampleTexture2DArray_c8eb4e7af01b45f69d050e13d975e088_RGBA_0_Vector4.b;
            float _SampleTexture2DArray_c8eb4e7af01b45f69d050e13d975e088_A_7_Float = _SampleTexture2DArray_c8eb4e7af01b45f69d050e13d975e088_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_fe72a521430440e3afd26e3bfcd75eaf_Out_2_Float;
            Unity_Multiply_float_float(_Split_ba66504d75854f228917e2119bf76b3b_G_2_Float, _SampleTexture2DArray_c8eb4e7af01b45f69d050e13d975e088_R_4_Float, _Multiply_fe72a521430440e3afd26e3bfcd75eaf_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_3066208cd8f148b98c0be5c2095950a5_Out_2_Float;
            Unity_Subtract_float(_GetWaterHeightCustomFunction_15a217bb0aba4acb832b7a2dec9f2fc7_waterHeight_0_Float, _Multiply_fe72a521430440e3afd26e3bfcd75eaf_Out_2_Float, _Subtract_3066208cd8f148b98c0be5c2095950a5_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_f840a289716442ad90910263e45c2a8c_Out_0_Float = _WaveDisplacementFade;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_7eb24e9129d7480e91087d037ae37023_Out_2_Float;
            Unity_Divide_float(_Subtract_3066208cd8f148b98c0be5c2095950a5_Out_2_Float, _Property_f840a289716442ad90910263e45c2a8c_Out_0_Float, _Divide_7eb24e9129d7480e91087d037ae37023_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_52cc62f624ea4cc0b173973c38f1ef96_Out_1_Float;
            Unity_Saturate_float(_Divide_7eb24e9129d7480e91087d037ae37023_Out_2_Float, _Saturate_52cc62f624ea4cc0b173973c38f1ef96_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Branch_97cebd944ce847b382f089c86cde2a5e_Out_3_Float;
            Unity_Branch_float(_GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_valid_9_Boolean, _Saturate_52cc62f624ea4cc0b173973c38f1ef96_Out_1_Float, float(1), _Branch_97cebd944ce847b382f089c86cde2a5e_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_ef46d811847f49ba9e1e533d723827de_Out_2_Float;
            Unity_Add_float(_Divide_cf9d7673e5694db7aefbfef87df2a4b0_Out_2_Float, _Branch_97cebd944ce847b382f089c86cde2a5e_Out_3_Float, _Add_ef46d811847f49ba9e1e533d723827de_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_4bd3ac578e94426f9e73f58c80c12622_Out_2_Float;
            Unity_Add_float(_Add_ef46d811847f49ba9e1e533d723827de_Out_2_Float, float(0.2), _Add_4bd3ac578e94426f9e73f58c80c12622_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_51f6399eb90c466e8c90a1dbce4e5c96_Out_1_Float;
            Unity_Saturate_float(_Add_4bd3ac578e94426f9e73f58c80c12622_Out_2_Float, _Saturate_51f6399eb90c466e8c90a1dbce4e5c96_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_4846206a195b4c9bb2b61853f9d19588_Out_2_Float;
            Unity_Multiply_float_float(_Split_03a0a8a4354c481a8ebb5550b9562024_R_1_Float, _Saturate_51f6399eb90c466e8c90a1dbce4e5c96_Out_1_Float, _Multiply_4846206a195b4c9bb2b61853f9d19588_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_404952f394544a0d98c8e0863a2bd51a_Out_2_Float;
            Unity_Multiply_float_float(_Split_03a0a8a4354c481a8ebb5550b9562024_G_2_Float, _Saturate_51f6399eb90c466e8c90a1dbce4e5c96_Out_1_Float, _Multiply_404952f394544a0d98c8e0863a2bd51a_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_3bcac1be76df4e75aff9f7f7927c16ee_Out_0_Vector2 = float2(_Multiply_4846206a195b4c9bb2b61853f9d19588_Out_2_Float, _Multiply_404952f394544a0d98c8e0863a2bd51a_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2DArray _Property_b461049ec24846e5aba20bc3a4a049bf_Out_0_Texture2DArray = UnityBuildTexture2DArrayStruct(_TerrainShoreWaveArrayTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_RGBA_0_Vector4 = PLATFORM_SAMPLE_TEXTURE2D_ARRAY(_Property_b461049ec24846e5aba20bc3a4a049bf_Out_0_Texture2DArray.tex, _Property_b461049ec24846e5aba20bc3a4a049bf_Out_0_Texture2DArray.samplerstate, _GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_uv_8_Vector2, _GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_slice_7_Float );
            float _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_R_4_Float = _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_RGBA_0_Vector4.r;
            float _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_G_5_Float = _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_RGBA_0_Vector4.g;
            float _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_B_6_Float = _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_RGBA_0_Vector4.b;
            float _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_A_7_Float = _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_219254610b674be9816f33c18d6e783f_R_1_Float = _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_RGBA_0_Vector4[0];
            float _Split_219254610b674be9816f33c18d6e783f_G_2_Float = _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_RGBA_0_Vector4[1];
            float _Split_219254610b674be9816f33c18d6e783f_B_3_Float = _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_RGBA_0_Vector4[2];
            float _Split_219254610b674be9816f33c18d6e783f_A_4_Float = _SampleTexture2DArray_3b458e9404314164818ce463f50b65cf_RGBA_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_2d8787e84f5142389efd09469991f491_Out_0_Vector2 = float2(_Split_219254610b674be9816f33c18d6e783f_G_2_Float, _Split_219254610b674be9816f33c18d6e783f_B_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_f984e38bf3294685a355c116702504b3_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_2d8787e84f5142389efd09469991f491_Out_0_Vector2, float2(2, 2), _Multiply_f984e38bf3294685a355c116702504b3_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Subtract_5ecc93ab7bf8440497e60d027467d070_Out_2_Vector2;
            Unity_Subtract_float2(_Multiply_f984e38bf3294685a355c116702504b3_Out_2_Vector2, float2(1, 1), _Subtract_5ecc93ab7bf8440497e60d027467d070_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_74f6c10d9ef94f07843ce7994a8e6f57_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Subtract_5ecc93ab7bf8440497e60d027467d070_Out_2_Vector2, (((float) _GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_valid_9_Boolean).xx), _Multiply_74f6c10d9ef94f07843ce7994a8e6f57_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _RoundToZeroCustomFunction_25c0660e406f496aa9bd6592b830e1f6_output_1_Vector2;
            RoundToZero_float(_Multiply_74f6c10d9ef94f07843ce7994a8e6f57_Out_2_Vector2, _RoundToZeroCustomFunction_25c0660e406f496aa9bd6592b830e1f6_output_1_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_7dc760bec82e4639a7ee8160a30c01ab_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3bcac1be76df4e75aff9f7f7927c16ee_Out_0_Vector2, _RoundToZeroCustomFunction_25c0660e406f496aa9bd6592b830e1f6_output_1_Vector2, _Add_7dc760bec82e4639a7ee8160a30c01ab_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(HAS_TERRAIN_OFF)
            float2 _HASTERRAIN_df2e006e49a5472fa7d23f03d8e9ce5f_Out_0_Vector2 = _Vector2_a51f89048e0b4325a8dd05096539c984_Out_0_Vector2;
            #else
            float2 _HASTERRAIN_df2e006e49a5472fa7d23f03d8e9ce5f_Out_0_Vector2 = _Add_7dc760bec82e4639a7ee8160a30c01ab_Out_2_Vector2;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_d01bc902b05a41d08815b78976d3c805_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Negate_87d37677ec3448d89d747262dd35142f_Out_1_Float.xx), _HASTERRAIN_df2e006e49a5472fa7d23f03d8e9ce5f_Out_0_Vector2, _Multiply_d01bc902b05a41d08815b78976d3c805_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_b69dc0677b1d4a719ad5921841566471_R_1_Float = _Multiply_d01bc902b05a41d08815b78976d3c805_Out_2_Vector2[0];
            float _Split_b69dc0677b1d4a719ad5921841566471_G_2_Float = _Multiply_d01bc902b05a41d08815b78976d3c805_Out_2_Vector2[1];
            float _Split_b69dc0677b1d4a719ad5921841566471_B_3_Float = 0;
            float _Split_b69dc0677b1d4a719ad5921841566471_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_af0b9867009b4ecea0e090500302ed52_Out_0_Vector3 = float3(_Split_b69dc0677b1d4a719ad5921841566471_R_1_Float, float(0), _Split_b69dc0677b1d4a719ad5921841566471_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Add_008de776383342dbb668adb2a2e01ff5_Out_2_Vector3;
            Unity_Add_float3(_Vector3_af0b9867009b4ecea0e090500302ed52_Out_0_Vector3, IN.WorldSpacePosition, _Add_008de776383342dbb668adb2a2e01ff5_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _TransformWorldPosToClipPosCustomFunction_4155f7467a1746bb9b206cec48967d70_posCS_1_Vector4;
            TransformWorldPosToClipPos_float(_Add_008de776383342dbb668adb2a2e01ff5_Out_2_Vector3, _TransformWorldPosToClipPosCustomFunction_4155f7467a1746bb9b206cec48967d70_posCS_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_d8d088bf660e45368b17a9bca6f47111_R_1_Float = _TransformWorldPosToClipPosCustomFunction_4155f7467a1746bb9b206cec48967d70_posCS_1_Vector4[0];
            float _Split_d8d088bf660e45368b17a9bca6f47111_G_2_Float = _TransformWorldPosToClipPosCustomFunction_4155f7467a1746bb9b206cec48967d70_posCS_1_Vector4[1];
            float _Split_d8d088bf660e45368b17a9bca6f47111_B_3_Float = _TransformWorldPosToClipPosCustomFunction_4155f7467a1746bb9b206cec48967d70_posCS_1_Vector4[2];
            float _Split_d8d088bf660e45368b17a9bca6f47111_A_4_Float = _TransformWorldPosToClipPosCustomFunction_4155f7467a1746bb9b206cec48967d70_posCS_1_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_cf1b138c68b34b5491dc73b58a67d0b3_Out_0_Vector2 = float2(_Split_d8d088bf660e45368b17a9bca6f47111_R_1_Float, _Split_d8d088bf660e45368b17a9bca6f47111_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Float_e068b51aded44f1ea45267a2bacbcdcb_Out_0_Float = float(0.5);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_29f76eb9ec7f483da0ebb801d586e644_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_cf1b138c68b34b5491dc73b58a67d0b3_Out_0_Vector2, (_Float_e068b51aded44f1ea45267a2bacbcdcb_Out_0_Float.xx), _Multiply_29f76eb9ec7f483da0ebb801d586e644_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_aa53125d544a43e986e6840048709dbc_Out_2_Vector2;
            Unity_Add_float2(_Multiply_29f76eb9ec7f483da0ebb801d586e644_Out_2_Vector2, (_Float_e068b51aded44f1ea45267a2bacbcdcb_Out_0_Float.xx), _Add_aa53125d544a43e986e6840048709dbc_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _HDSceneDepth_3f35b993107f4fd8a79f9078a9179cad_Output_2_Float = LinearEyeDepth(Unity_HDRP_SampleSceneDepth_float((float4(_Add_aa53125d544a43e986e6840048709dbc_Out_2_Vector2, 0.0, 1.0)).xy, float(0)), _ZBufferParams);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _GetZBufferParamsCustomFunction_4e4d82caa7834c3facd1a0966f6e452d_zBufferParams_0_Vector4;
            GetZBufferParams_float(_GetZBufferParamsCustomFunction_4e4d82caa7834c3facd1a0966f6e452d_zBufferParams_0_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _RawToViewDepthCustomFunction_4d494ed4b2c346878791a507596f74ff_viewDepth_2_Float;
            RawToViewDepth_float(_Split_d8d088bf660e45368b17a9bca6f47111_B_3_Float, _GetZBufferParamsCustomFunction_4e4d82caa7834c3facd1a0966f6e452d_zBufferParams_0_Vector4, _RawToViewDepthCustomFunction_4d494ed4b2c346878791a507596f74ff_viewDepth_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_26d4dfa5fd2f44ccba506873747fa871_Out_2_Float;
            Unity_Subtract_float(_HDSceneDepth_3f35b993107f4fd8a79f9078a9179cad_Output_2_Float, _RawToViewDepthCustomFunction_4d494ed4b2c346878791a507596f74ff_viewDepth_2_Float, _Subtract_26d4dfa5fd2f44ccba506873747fa871_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_6f036d6fcf914a9e9dd041ab90f95626_Out_1_Float;
            Unity_Saturate_float(_Subtract_26d4dfa5fd2f44ccba506873747fa871_Out_2_Float, _Saturate_6f036d6fcf914a9e9dd041ab90f95626_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c4f032dc6403421484e08420681740f6_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_OceanScreenTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _GetRTHandleScaleCustomFunction_f9dc745cd5754bc4892cc6037b3ecf6a_RTHandleScale_0_Vector4;
            GetRTHandleScale_float(_GetRTHandleScaleCustomFunction_f9dc745cd5754bc4892cc6037b3ecf6a_RTHandleScale_0_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_c19b39e6b64845b4a7d347e83051ca96_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_aa53125d544a43e986e6840048709dbc_Out_2_Vector2, (_GetRTHandleScaleCustomFunction_f9dc745cd5754bc4892cc6037b3ecf6a_RTHandleScale_0_Vector4.xy), _Multiply_c19b39e6b64845b4a7d347e83051ca96_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_467d7d066e544be6bc8152b50fd5ab8a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c4f032dc6403421484e08420681740f6_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Point_Clamp).samplerstate, _Property_c4f032dc6403421484e08420681740f6_Out_0_Texture2D.GetTransformedUV(_Multiply_c19b39e6b64845b4a7d347e83051ca96_Out_2_Vector2) );
            float _SampleTexture2D_467d7d066e544be6bc8152b50fd5ab8a_R_4_Float = _SampleTexture2D_467d7d066e544be6bc8152b50fd5ab8a_RGBA_0_Vector4.r;
            float _SampleTexture2D_467d7d066e544be6bc8152b50fd5ab8a_G_5_Float = _SampleTexture2D_467d7d066e544be6bc8152b50fd5ab8a_RGBA_0_Vector4.g;
            float _SampleTexture2D_467d7d066e544be6bc8152b50fd5ab8a_B_6_Float = _SampleTexture2D_467d7d066e544be6bc8152b50fd5ab8a_RGBA_0_Vector4.b;
            float _SampleTexture2D_467d7d066e544be6bc8152b50fd5ab8a_A_7_Float = _SampleTexture2D_467d7d066e544be6bc8152b50fd5ab8a_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _GetWaterSurfaceMaskCustomFunction_0787c7b403ca46c897eaaac50514991a_waterSurfaceMask_2_Boolean;
            GetWaterSurfaceMask_float(_SampleTexture2D_467d7d066e544be6bc8152b50fd5ab8a_RGBA_0_Vector4, _GetWaterSurfaceMaskCustomFunction_0787c7b403ca46c897eaaac50514991a_waterSurfaceMask_2_Boolean);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_14536074184f478ab818dd839045c8ab_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_6f036d6fcf914a9e9dd041ab90f95626_Out_1_Float, ((float) _GetWaterSurfaceMaskCustomFunction_0787c7b403ca46c897eaaac50514991a_waterSurfaceMask_2_Boolean), _Multiply_14536074184f478ab818dd839045c8ab_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Lerp_4bdabf5b9b9a4cd38744d912948129fe_Out_3_Vector2;
            Unity_Lerp_float2((_ScreenPosition_6a8f60e839bd499789e4c0b9816015ef_Out_0_Vector4.xy), _Add_aa53125d544a43e986e6840048709dbc_Out_2_Vector2, (_Multiply_14536074184f478ab818dd839045c8ab_Out_2_Float.xx), _Lerp_4bdabf5b9b9a4cd38744d912948129fe_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_9a2a5935d1b34b5791793377590a30d8_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_2765578c02ea45d2a96f032b8d86696f_Out_0_Vector2, _Lerp_4bdabf5b9b9a4cd38744d912948129fe_Out_3_Vector2, _Multiply_9a2a5935d1b34b5791793377590a30d8_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_b101154ddefc4d4d87a22d7a2bc47267_Out_0_Vector2 = float2(_ScreenParams.x, _ScreenParams.y);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Subtract_0ab92a08702d4a6e8b8847f66b716a6e_Out_2_Vector2;
            Unity_Subtract_float2(_Vector2_b101154ddefc4d4d87a22d7a2bc47267_Out_0_Vector2, float2(1, 1), _Subtract_0ab92a08702d4a6e8b8847f66b716a6e_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Clamp_58f522dee4804dd7a466b0a5211a5bab_Out_3_Vector2;
            Unity_Clamp_float2(_Multiply_9a2a5935d1b34b5791793377590a30d8_Out_2_Vector2, float2(0, 0), _Subtract_0ab92a08702d4a6e8b8847f66b716a6e_Out_2_Vector2, _Clamp_58f522dee4804dd7a466b0a5211a5bab_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _LoadSceneColorCustomFunction_c1a386bace20455d9b145790373340dc_sceneColor_2_Vector3;
            LoadSceneColor_float(_Clamp_58f522dee4804dd7a466b0a5211a5bab_Out_3_Vector2, float(0), _LoadSceneColorCustomFunction_c1a386bace20455d9b145790373340dc_sceneColor_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5ddcf623b5c2461ba7824fe306d4c7fe_Out_0_Float = _UnderwaterSurfaceEmissionStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_86638e56f067419cbb8c1b22a2051a5c_Out_2_Vector3;
            Unity_Multiply_float3_float3(_LoadSceneColorCustomFunction_c1a386bace20455d9b145790373340dc_sceneColor_2_Vector3, (_Property_5ddcf623b5c2461ba7824fe306d4c7fe_Out_0_Float.xxx), _Multiply_86638e56f067419cbb8c1b22a2051a5c_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5326dac78efd4aca93ee3d4af04f9ea1_R_1_Float = _Add_7dc760bec82e4639a7ee8160a30c01ab_Out_2_Vector2[0];
            float _Split_5326dac78efd4aca93ee3d4af04f9ea1_G_2_Float = _Add_7dc760bec82e4639a7ee8160a30c01ab_Out_2_Vector2[1];
            float _Split_5326dac78efd4aca93ee3d4af04f9ea1_B_3_Float = 0;
            float _Split_5326dac78efd4aca93ee3d4af04f9ea1_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(HAS_TERRAIN_OFF)
            float _HASTERRAIN_441d2d935efe4a8ba54470a87ed1e36d_Out_0_Float = _Split_03a0a8a4354c481a8ebb5550b9562024_R_1_Float;
            #else
            float _HASTERRAIN_441d2d935efe4a8ba54470a87ed1e36d_Out_0_Float = _Split_5326dac78efd4aca93ee3d4af04f9ea1_R_1_Float;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(HAS_TERRAIN_OFF)
            float _HASTERRAIN_9bf13bc9b67f45e997d3e3643daa0ecd_Out_0_Float = _Split_03a0a8a4354c481a8ebb5550b9562024_G_2_Float;
            #else
            float _HASTERRAIN_9bf13bc9b67f45e997d3e3643daa0ecd_Out_0_Float = _Split_5326dac78efd4aca93ee3d4af04f9ea1_G_2_Float;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_d13d9f6e027b4883b8bb3502fcbf760a_Out_0_Vector3 = float3(_HASTERRAIN_441d2d935efe4a8ba54470a87ed1e36d_Out_0_Float, float(1), _HASTERRAIN_9bf13bc9b67f45e997d3e3643daa0ecd_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Normalize_a42634cff39a45fa9d3b352aa9729e38_Out_1_Vector3;
            Unity_Normalize_float3(_Vector3_d13d9f6e027b4883b8bb3502fcbf760a_Out_0_Vector3, _Normalize_a42634cff39a45fa9d3b352aa9729e38_Out_1_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_e89c9483ecf54655839c8a045e283126_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceViewDirection, _Normalize_a42634cff39a45fa9d3b352aa9729e38_Out_1_Vector3, _DotProduct_e89c9483ecf54655839c8a045e283126_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_b988a8af7c0f4bc48b3b0e8f1ae1be82_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_e89c9483ecf54655839c8a045e283126_Out_2_Float, _DotProduct_e89c9483ecf54655839c8a045e283126_Out_2_Float, _Multiply_b988a8af7c0f4bc48b3b0e8f1ae1be82_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Comparison_3fb7561b95a04bb18a49d6b5c0546f6a_Out_2_Boolean;
            Unity_Comparison_Greater_float(_Multiply_b988a8af7c0f4bc48b3b0e8f1ae1be82_Out_2_Float, float(0.5), _Comparison_3fb7561b95a04bb18a49d6b5c0546f6a_Out_2_Boolean);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_119b242d8a574fd094193f4324a54f6f_Out_3_Vector3;
            Unity_Lerp_float3(_Multiply_8946ebc8bea54f92aefc81c3696d0b88_Out_2_Vector3, _Multiply_86638e56f067419cbb8c1b22a2051a5c_Out_2_Vector3, (((float) _Comparison_3fb7561b95a04bb18a49d6b5c0546f6a_Out_2_Boolean).xxx), _Lerp_119b242d8a574fd094193f4324a54f6f_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_4156a68181f144cb968ac0dec634de75_Out_2_Vector3;
            Unity_Multiply_float3_float3(_LoadSceneColorCustomFunction_c1a386bace20455d9b145790373340dc_sceneColor_2_Vector3, _GetUnderwaterFogColorCustomFunction_f1cb1c8de8b74d258428f851e73117ab_underwaterFogColor_0_Vector3, _Multiply_4156a68181f144cb968ac0dec634de75_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _IsFrontFace_130a3cd6dd754182a0a3231f238b07ab_Out_0_Boolean = max(0, IN.FaceSign.x);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_832e5534489344c1bdc92712580c7493_Out_3_Vector3;
            Unity_Lerp_float3(_Lerp_119b242d8a574fd094193f4324a54f6f_Out_3_Vector3, _Multiply_4156a68181f144cb968ac0dec634de75_Out_2_Vector3, (((float) _IsFrontFace_130a3cd6dd754182a0a3231f238b07ab_Out_0_Boolean).xxx), _Lerp_832e5534489344c1bdc92712580c7493_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _IsFrontFace_e7315b85963c48f0a5999000221ba2b7_Out_0_Boolean = max(0, IN.FaceSign.x);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_34006ed972b44d0d9540292fbc127bf2_Out_2_Float;
            Unity_Multiply_float_float(((float) _IsFrontFace_e7315b85963c48f0a5999000221ba2b7_Out_0_Boolean), _SampleTexture2D_467d7d066e544be6bc8152b50fd5ab8a_G_5_Float, _Multiply_34006ed972b44d0d9540292fbc127bf2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _GetLightRayStrengthCustomFunction_49dedf34709d4ced864a384032554ca8_lightRayStrength_0_Float;
            GetLightRayStrength_float(_GetLightRayStrengthCustomFunction_49dedf34709d4ced864a384032554ca8_lightRayStrength_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_556b08667de942d5ae85659b37b834c3_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_34006ed972b44d0d9540292fbc127bf2_Out_2_Float, _GetLightRayStrengthCustomFunction_49dedf34709d4ced864a384032554ca8_lightRayStrength_0_Float, _Multiply_556b08667de942d5ae85659b37b834c3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_c0daeb9f329a496c9f1d35f6c0d605b7_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_556b08667de942d5ae85659b37b834c3_Out_2_Float, 0.5, _Multiply_c0daeb9f329a496c9f1d35f6c0d605b7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_777cb0cfad4f48408be4548a90a76786_Out_2_Float;
            Unity_Add_float(_Multiply_c0daeb9f329a496c9f1d35f6c0d605b7_Out_2_Float, float(0.5), _Add_777cb0cfad4f48408be4548a90a76786_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_e52703fbc2e0436a82c18ecd7b215a88_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Lerp_832e5534489344c1bdc92712580c7493_Out_3_Vector3, (_Add_777cb0cfad4f48408be4548a90a76786_Out_2_Float.xxx), _Multiply_e52703fbc2e0436a82c18ecd7b215a88_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e499fcbad06444f1bfc22a659ead6c9b_Out_0_Vector4 = _FoamColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _HDSceneDepth_e42cb57a25934a909881c4a05b3c24fb_Output_2_Float = LinearEyeDepth(Unity_HDRP_SampleSceneDepth_float(float4(IN.NDCPosition.xy, 0, 0).xy, float(0)), _ZBufferParams);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _ScreenPosition_2e54195a818e49db96f54046ce2f37ec_Out_0_Vector4 = IN.ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_99e34e953c4d4f09877dd092d0db0f40_R_1_Float = _ScreenPosition_2e54195a818e49db96f54046ce2f37ec_Out_0_Vector4[0];
            float _Split_99e34e953c4d4f09877dd092d0db0f40_G_2_Float = _ScreenPosition_2e54195a818e49db96f54046ce2f37ec_Out_0_Vector4[1];
            float _Split_99e34e953c4d4f09877dd092d0db0f40_B_3_Float = _ScreenPosition_2e54195a818e49db96f54046ce2f37ec_Out_0_Vector4[2];
            float _Split_99e34e953c4d4f09877dd092d0db0f40_A_4_Float = _ScreenPosition_2e54195a818e49db96f54046ce2f37ec_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_0842544d3f894c848051eec2f872b369_Out_2_Float;
            Unity_Subtract_float(_HDSceneDepth_e42cb57a25934a909881c4a05b3c24fb_Output_2_Float, _Split_99e34e953c4d4f09877dd092d0db0f40_A_4_Float, _Subtract_0842544d3f894c848051eec2f872b369_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_68af3471eedc45928efe803a421cbb16_Out_0_Float = _EdgeFoamFalloff;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_9f53ef0e5fbe40378da24a487d02df9f_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_0842544d3f894c848051eec2f872b369_Out_2_Float, _Property_68af3471eedc45928efe803a421cbb16_Out_0_Float, _Multiply_9f53ef0e5fbe40378da24a487d02df9f_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_8ac689bacd30478c9b9cad1bb2c860dd_Out_1_Float;
            Unity_OneMinus_float(_Multiply_9f53ef0e5fbe40378da24a487d02df9f_Out_2_Float, _OneMinus_8ac689bacd30478c9b9cad1bb2c860dd_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_0f8b9948368849e083bb0e06e7b4f7ec_Out_0_Float = _EdgeFoamWidth;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_0a16ac8f7e874f09be61d14bcbd875a0_Out_2_Float;
            Unity_Add_float(_OneMinus_8ac689bacd30478c9b9cad1bb2c860dd_Out_1_Float, _Property_0f8b9948368849e083bb0e06e7b4f7ec_Out_0_Float, _Add_0a16ac8f7e874f09be61d14bcbd875a0_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _HDSceneDepth_bfd8b2b8454d4eee837a86b26c29d7ad_Output_2_Float = Unity_HDRP_SampleSceneDepth_float(float4(IN.NDCPosition.xy, 0, 0).xy, float(0));
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _IsNotFarPlaneCustomFunction_ba50579e64f549b2ae43247a2812ae59_isNotFarPlane_1_Boolean;
            IsNotFarPlane_float(_HDSceneDepth_bfd8b2b8454d4eee837a86b26c29d7ad_Output_2_Float, _IsNotFarPlaneCustomFunction_ba50579e64f549b2ae43247a2812ae59_isNotFarPlane_1_Boolean);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_1b169e71a2074c90b767ee97d8bd2ccc_Out_2_Float;
            Unity_Multiply_float_float(_Add_0a16ac8f7e874f09be61d14bcbd875a0_Out_2_Float, ((float) _IsNotFarPlaneCustomFunction_ba50579e64f549b2ae43247a2812ae59_isNotFarPlane_1_Boolean), _Multiply_1b169e71a2074c90b767ee97d8bd2ccc_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_71098a3274c64def9f39bb16e0894fdd_Out_1_Float;
            Unity_Saturate_float(_Multiply_1b169e71a2074c90b767ee97d8bd2ccc_Out_2_Float, _Saturate_71098a3274c64def9f39bb16e0894fdd_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_0ce22721b8fe418796b04553fbf0e212_Out_0_Float = _EdgeFoamStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_e1a786b8cd6d427ca70b86ff7b9fa43d_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_71098a3274c64def9f39bb16e0894fdd_Out_1_Float, _Property_0ce22721b8fe418796b04553fbf0e212_Out_0_Float, _Multiply_e1a786b8cd6d427ca70b86ff7b9fa43d_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_1c9483d7416641aeaadfe326889ad70d_Out_0_Float = _DisplacementMaxDistance;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3bd3a62d3582480a8cd75119a0d262e0_Out_2_Float;
            Unity_Multiply_float_float(_Property_1c9483d7416641aeaadfe326889ad70d_Out_0_Float, _Property_1c9483d7416641aeaadfe326889ad70d_Out_0_Float, _Multiply_3bd3a62d3582480a8cd75119a0d262e0_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_258231df6f664facb527b73b32bd4bf5_Out_2_Float;
            Unity_Divide_float(_LengthSquaredSubGraph_9b287be4f58e46198afb4137e2063740_output_0_Float, _Multiply_3bd3a62d3582480a8cd75119a0d262e0_Out_2_Float, _Divide_258231df6f664facb527b73b32bd4bf5_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_1d0c9521fa8149b9aef46be89951811e_Out_1_Float;
            Unity_OneMinus_float(_Divide_258231df6f664facb527b73b32bd4bf5_Out_2_Float, _OneMinus_1d0c9521fa8149b9aef46be89951811e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_4b67c26c54384b47aee20ebee99aff97_Out_1_Float;
            Unity_Saturate_float(_OneMinus_1d0c9521fa8149b9aef46be89951811e_Out_1_Float, _Saturate_4b67c26c54384b47aee20ebee99aff97_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_dba801361d7b46359bffb6b7418a4b30_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_e1a786b8cd6d427ca70b86ff7b9fa43d_Out_2_Float, _Saturate_4b67c26c54384b47aee20ebee99aff97_Out_1_Float, _Multiply_dba801361d7b46359bffb6b7418a4b30_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3790ee582d4244ab9cebfda3ed375c00_Out_2_Float;
            Unity_Multiply_float_float(((float) _GetTerrainSamplingDataCustomFunction_612e25846eba4295bed9425efdb90ce3_valid_9_Boolean), _Split_219254610b674be9816f33c18d6e783f_A_4_Float, _Multiply_3790ee582d4244ab9cebfda3ed375c00_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_1251ba055dbd4a3390ebc3ea2ed9dca2_Out_0_Float = _ShoreWaveFoamAmount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_ccdb69b0fa3c4a63a91951de4aa91912_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_3790ee582d4244ab9cebfda3ed375c00_Out_2_Float, _Property_1251ba055dbd4a3390ebc3ea2ed9dca2_Out_0_Float, _Multiply_ccdb69b0fa3c4a63a91951de4aa91912_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Maximum_6a6f8e0a5100469d8ef50032e370718c_Out_2_Float;
            Unity_Maximum_float(_Multiply_dba801361d7b46359bffb6b7418a4b30_Out_2_Float, _Multiply_ccdb69b0fa3c4a63a91951de4aa91912_Out_2_Float, _Maximum_6a6f8e0a5100469d8ef50032e370718c_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(HAS_TERRAIN_OFF)
            float _HASTERRAIN_45dfafb670554795b522f497dc99fb5b_Out_0_Float = _Multiply_e1a786b8cd6d427ca70b86ff7b9fa43d_Out_2_Float;
            #else
            float _HASTERRAIN_45dfafb670554795b522f497dc99fb5b_Out_0_Float = _Maximum_6a6f8e0a5100469d8ef50032e370718c_Out_2_Float;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_b2b8bcbe84bd45608aacb23ae5031889_Out_2_Float;
            Unity_Multiply_float_float(_Split_03a0a8a4354c481a8ebb5550b9562024_A_4_Float, _Saturate_51f6399eb90c466e8c90a1dbce4e5c96_Out_1_Float, _Multiply_b2b8bcbe84bd45608aacb23ae5031889_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(HAS_TERRAIN_OFF)
            float _HASTERRAIN_a57b28641b294dd3af1c9b8b44fc88a1_Out_0_Float = _Split_03a0a8a4354c481a8ebb5550b9562024_A_4_Float;
            #else
            float _HASTERRAIN_a57b28641b294dd3af1c9b8b44fc88a1_Out_0_Float = _Multiply_b2b8bcbe84bd45608aacb23ae5031889_Out_2_Float;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_f293626da7174d878fa82fd028ffd2a3_Out_2_Float;
            Unity_Multiply_float_float(_HASTERRAIN_a57b28641b294dd3af1c9b8b44fc88a1_Out_0_Float, 0.25, _Multiply_f293626da7174d878fa82fd028ffd2a3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Maximum_ea57f16be43b42a9ac2a2a4ee3e329b0_Out_2_Float;
            Unity_Maximum_float(_HASTERRAIN_45dfafb670554795b522f497dc99fb5b_Out_0_Float, _Multiply_f293626da7174d878fa82fd028ffd2a3_Out_2_Float, _Maximum_ea57f16be43b42a9ac2a2a4ee3e329b0_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_72030b9596d2471bade2f3e9624b90ad_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FoamTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_7a0f6ccb175e42b785846d623ade6b44_Out_0_Float = _FoamOffsetSpeed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_eda458c68d0a4b599e83d8221bf3a2de_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_7a0f6ccb175e42b785846d623ade6b44_Out_0_Float, _Multiply_eda458c68d0a4b599e83d8221bf3a2de_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Subtract_3fa69e1509144ca5884fa835932a4203_Out_2_Vector2;
            Unity_Subtract_float2(IN.UnmodPositionWSXZ, (_Multiply_eda458c68d0a4b599e83d8221bf3a2de_Out_2_Float.xx), _Subtract_3fa69e1509144ca5884fa835932a4203_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d6e69e0a54064e5082e271be3a418e34_Out_0_Float = _FoamTiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_296b8446b26043068ce7974d18e3bf38_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Subtract_3fa69e1509144ca5884fa835932a4203_Out_2_Vector2, (_Property_d6e69e0a54064e5082e271be3a418e34_Out_0_Float.xx), _Multiply_296b8446b26043068ce7974d18e3bf38_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_8dcba2d4a1134ef8836923cbe704b0df_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_72030b9596d2471bade2f3e9624b90ad_Out_0_Texture2D.tex, _Property_72030b9596d2471bade2f3e9624b90ad_Out_0_Texture2D.samplerstate, _Property_72030b9596d2471bade2f3e9624b90ad_Out_0_Texture2D.GetTransformedUV(_Multiply_296b8446b26043068ce7974d18e3bf38_Out_2_Vector2) );
            float _SampleTexture2D_8dcba2d4a1134ef8836923cbe704b0df_R_4_Float = _SampleTexture2D_8dcba2d4a1134ef8836923cbe704b0df_RGBA_0_Vector4.r;
            float _SampleTexture2D_8dcba2d4a1134ef8836923cbe704b0df_G_5_Float = _SampleTexture2D_8dcba2d4a1134ef8836923cbe704b0df_RGBA_0_Vector4.g;
            float _SampleTexture2D_8dcba2d4a1134ef8836923cbe704b0df_B_6_Float = _SampleTexture2D_8dcba2d4a1134ef8836923cbe704b0df_RGBA_0_Vector4.b;
            float _SampleTexture2D_8dcba2d4a1134ef8836923cbe704b0df_A_7_Float = _SampleTexture2D_8dcba2d4a1134ef8836923cbe704b0df_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_54d4c433e4714995becdb856acd65db5_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FoamTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_36e4fb831309433ca71f5f53f50a6c9f_Out_2_Vector2;
            Unity_Add_float2(IN.UnmodPositionWSXZ, (_Multiply_eda458c68d0a4b599e83d8221bf3a2de_Out_2_Float.xx), _Add_36e4fb831309433ca71f5f53f50a6c9f_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_50d81a433e9443baa45d5b9ceff96cfb_Out_0_Float = _SecondaryFoamTiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_33ba5de5cc50428e992b78b3e6b4c82f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_36e4fb831309433ca71f5f53f50a6c9f_Out_2_Vector2, (_Property_50d81a433e9443baa45d5b9ceff96cfb_Out_0_Float.xx), _Multiply_33ba5de5cc50428e992b78b3e6b4c82f_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_368d3291b9f7496c93f7b107c73f06ae_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_54d4c433e4714995becdb856acd65db5_Out_0_Texture2D.tex, _Property_54d4c433e4714995becdb856acd65db5_Out_0_Texture2D.samplerstate, _Property_54d4c433e4714995becdb856acd65db5_Out_0_Texture2D.GetTransformedUV(_Multiply_33ba5de5cc50428e992b78b3e6b4c82f_Out_2_Vector2) );
            float _SampleTexture2D_368d3291b9f7496c93f7b107c73f06ae_R_4_Float = _SampleTexture2D_368d3291b9f7496c93f7b107c73f06ae_RGBA_0_Vector4.r;
            float _SampleTexture2D_368d3291b9f7496c93f7b107c73f06ae_G_5_Float = _SampleTexture2D_368d3291b9f7496c93f7b107c73f06ae_RGBA_0_Vector4.g;
            float _SampleTexture2D_368d3291b9f7496c93f7b107c73f06ae_B_6_Float = _SampleTexture2D_368d3291b9f7496c93f7b107c73f06ae_RGBA_0_Vector4.b;
            float _SampleTexture2D_368d3291b9f7496c93f7b107c73f06ae_A_7_Float = _SampleTexture2D_368d3291b9f7496c93f7b107c73f06ae_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_c67e3e6ae93c42a5b1daa6459122a694_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_8dcba2d4a1134ef8836923cbe704b0df_R_4_Float, _SampleTexture2D_368d3291b9f7496c93f7b107c73f06ae_R_4_Float, _Multiply_c67e3e6ae93c42a5b1daa6459122a694_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9145307270404d06b7b422c51785462d_Out_0_Float = _FoamHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_2f6ac01b36af48c0b40987ce2e5b7c1f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_c67e3e6ae93c42a5b1daa6459122a694_Out_2_Float, _Property_9145307270404d06b7b422c51785462d_Out_0_Float, _Multiply_2f6ac01b36af48c0b40987ce2e5b7c1f_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_f5f0be9b2881423294303c0dcd8a4187_Out_0_Float = _FoamTextureFadeDistance;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_f12e807a5f01467db26381e3ce3f6583_Out_2_Float;
            Unity_Divide_float(_SquareRoot_9640851a34cd46888d84cd0fab3eae31_Out_1_Float, _Property_f5f0be9b2881423294303c0dcd8a4187_Out_0_Float, _Divide_f12e807a5f01467db26381e3ce3f6583_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_bda3980fc1a04dfd9b56526bd231ea76_Out_1_Float;
            Unity_Saturate_float(_Divide_f12e807a5f01467db26381e3ce3f6583_Out_2_Float, _Saturate_bda3980fc1a04dfd9b56526bd231ea76_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_e96e73dd5b154ddcac403b6e20bda879_Out_1_Float;
            Unity_OneMinus_float(_Saturate_bda3980fc1a04dfd9b56526bd231ea76_Out_1_Float, _OneMinus_e96e73dd5b154ddcac403b6e20bda879_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_18ebacb6dbb84f6f86227a518c571799_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_2f6ac01b36af48c0b40987ce2e5b7c1f_Out_2_Float, _OneMinus_e96e73dd5b154ddcac403b6e20bda879_Out_1_Float, _Multiply_18ebacb6dbb84f6f86227a518c571799_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_2a94fc8fdcd944fab1ecdbca3023638d_Out_2_Float;
            Unity_Subtract_float(_Maximum_ea57f16be43b42a9ac2a2a4ee3e329b0_Out_2_Float, _Multiply_18ebacb6dbb84f6f86227a518c571799_Out_2_Float, _Subtract_2a94fc8fdcd944fab1ecdbca3023638d_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_df2432226ab0461082e60ac757524aaf_Out_0_Float = _DistantFoam;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_23a66c47ea3f401a8f39a7ffeb186783_Out_2_Float;
            Unity_Multiply_float_float(_Property_df2432226ab0461082e60ac757524aaf_Out_0_Float, _Saturate_bda3980fc1a04dfd9b56526bd231ea76_Out_1_Float, _Multiply_23a66c47ea3f401a8f39a7ffeb186783_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_9412367159c848a2a1a33e34e877992a_Out_2_Float;
            Unity_Subtract_float(_Subtract_2a94fc8fdcd944fab1ecdbca3023638d_Out_2_Float, _Multiply_23a66c47ea3f401a8f39a7ffeb186783_Out_2_Float, _Subtract_9412367159c848a2a1a33e34e877992a_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_8f46f47b262441fbbc91b3aabb9acb01_Out_1_Float;
            Unity_Saturate_float(_Subtract_9412367159c848a2a1a33e34e877992a_Out_2_Float, _Saturate_8f46f47b262441fbbc91b3aabb9acb01_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_d2eb24f7702f4c4ebab7624b516c0fe7_Out_3_Vector3;
            Unity_Lerp_float3(_Multiply_e52703fbc2e0436a82c18ecd7b215a88_Out_2_Vector3, (_Property_e499fcbad06444f1bfc22a659ead6c9b_Out_0_Vector4.xyz), (_Saturate_8f46f47b262441fbbc91b3aabb9acb01_Out_1_Float.xxx), _Lerp_d2eb24f7702f4c4ebab7624b516c0fe7_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _IsFrontFace_5a44bbdb67944a0995f30edf88e8f989_Out_0_Boolean = max(0, IN.FaceSign.x);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c350992b06104881b5e827de9bd2dc9f_Out_0_Float = _DistantSmoothness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d1782e6a750a454b9c5e704dd3a58ba6_Out_0_Float = _Smoothness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_3f3a633a07514d62b28dd8c0a87d0451_Out_0_Float = _SmoothnessTransitionDistance;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_c73ce565ea604919a6ffaeeba39b066c_Out_2_Float;
            Unity_Divide_float(_SquareRoot_9640851a34cd46888d84cd0fab3eae31_Out_1_Float, _Property_3f3a633a07514d62b28dd8c0a87d0451_Out_0_Float, _Divide_c73ce565ea604919a6ffaeeba39b066c_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_701726d188fd4ba08006b7c4fc7b680e_Out_1_Float;
            Unity_OneMinus_float(_Divide_c73ce565ea604919a6ffaeeba39b066c_Out_2_Float, _OneMinus_701726d188fd4ba08006b7c4fc7b680e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_a7a7c473789d47148714b8f083d2f262_Out_1_Float;
            Unity_Saturate_float(_OneMinus_701726d188fd4ba08006b7c4fc7b680e_Out_1_Float, _Saturate_a7a7c473789d47148714b8f083d2f262_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_f42e6ff5c0fd4dd9a1df5a61d2a94e85_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_a7a7c473789d47148714b8f083d2f262_Out_1_Float, _Saturate_a7a7c473789d47148714b8f083d2f262_Out_1_Float, _Multiply_f42e6ff5c0fd4dd9a1df5a61d2a94e85_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Lerp_21dda1bfc1d54d758795b6d4bc5619d3_Out_3_Float;
            Unity_Lerp_float(_Property_c350992b06104881b5e827de9bd2dc9f_Out_0_Float, _Property_d1782e6a750a454b9c5e704dd3a58ba6_Out_0_Float, _Multiply_f42e6ff5c0fd4dd9a1df5a61d2a94e85_Out_2_Float, _Lerp_21dda1bfc1d54d758795b6d4bc5619d3_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_0780d6381e9d4099bb99ca699356c084_Out_1_Float;
            Unity_OneMinus_float(_Saturate_8f46f47b262441fbbc91b3aabb9acb01_Out_1_Float, _OneMinus_0780d6381e9d4099bb99ca699356c084_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_067b6f647def4c96bbdde321e4456cd8_Out_2_Float;
            Unity_Multiply_float_float(_Lerp_21dda1bfc1d54d758795b6d4bc5619d3_Out_3_Float, _OneMinus_0780d6381e9d4099bb99ca699356c084_Out_1_Float, _Multiply_067b6f647def4c96bbdde321e4456cd8_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_55697308ab6a42bc8e4c9777882971e4_Out_2_Float;
            Unity_Multiply_float_float(((float) _IsFrontFace_5a44bbdb67944a0995f30edf88e8f989_Out_0_Boolean), _Multiply_067b6f647def4c96bbdde321e4456cd8_Out_2_Float, _Multiply_55697308ab6a42bc8e4c9777882971e4_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_b693b1ff08624104acc62ce2c462b780_Out_0_Float = _ScatteringFalloff;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_f333126a585e4cb4b0e404f4d6e74c42_Out_2_Float;
            Unity_Divide_float(_Split_03a0a8a4354c481a8ebb5550b9562024_B_3_Float, _Property_b693b1ff08624104acc62ce2c462b780_Out_0_Float, _Divide_f333126a585e4cb4b0e404f4d6e74c42_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_be593f2883ee458b8d54c27ae0e06f32_Out_1_Float;
            Unity_Saturate_float(_Divide_f333126a585e4cb4b0e404f4d6e74c42_Out_2_Float, _Saturate_be593f2883ee458b8d54c27ae0e06f32_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_f01dd0fa31554e0782fdc8275f20a3c9_Out_1_Float;
            Unity_OneMinus_float(_Saturate_be593f2883ee458b8d54c27ae0e06f32_Out_1_Float, _OneMinus_f01dd0fa31554e0782fdc8275f20a3c9_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_7afea8d7a61b45c8908ce410deacb105_Out_2_Float;
            Unity_Add_float(_OneMinus_f01dd0fa31554e0782fdc8275f20a3c9_Out_1_Float, _Saturate_8f46f47b262441fbbc91b3aabb9acb01_Out_1_Float, _Add_7afea8d7a61b45c8908ce410deacb105_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_3978ccaf568f422ea3aa44bd20fce325_Out_0_Float = _DiffusionProfile;
            #endif
            surface.BaseColor = _Lerp_d2eb24f7702f4c4ebab7624b516c0fe7_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = float(1);
            surface.BentNormal = IN.TangentSpaceNormal;
            surface.Smoothness = _Multiply_55697308ab6a42bc8e4c9777882971e4_Out_2_Float;
            surface.Occlusion = float(1);
            surface.NormalWS = _Normalize_a42634cff39a45fa9d3b352aa9729e38_Out_1_Vector3;
            surface.TransmissionMask = _OneMinus_0780d6381e9d4099bb99ca699356c084_Out_1_Float;
            surface.Thickness = _Add_7afea8d7a61b45c8908ce410deacb105_Out_2_Float;
            surface.DiffusionProfileHash = _Property_3978ccaf568f422ea3aa44bd20fce325_Out_0_Float;
            #if defined(KEYWORD_PERMUTATION_0)
            {
                surface.VTPackedFeedback = float4(1.0f,1.0f,1.0f,1.0f);
            }
            #endif
            #if defined(KEYWORD_PERMUTATION_1)
            {
                surface.VTPackedFeedback = float4(1.0f,1.0f,1.0f,1.0f);
            }
            #endif
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES AttributesMesh
            #define VaryingsMeshType VaryingsMeshToPS
            #define VFX_SRP_VARYINGS VaryingsMeshType
            #define VFX_SRP_SURFACE_INPUTS FragInputs
            #endif
            
        VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexID =                                   input.vertexID;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else
        #endif
        
            return output;
        }
        
        VertexDescription GetVertexDescription(AttributesMesh input, float3 timeParameters
        #ifdef HAVE_VFX_MODIFICATION
            , AttributesElement element
        #endif
        )
        {
            // build graph inputs
            VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
            // Override time parameters with used one (This is required to correctly handle motion vectors for vertex animation based on time)
        
            // evaluate vertex graph
        #ifdef HAVE_VFX_MODIFICATION
            GraphProperties properties;
            ZERO_INITIALIZE(GraphProperties, properties);
        
            // Fetch the vertex graph properties for the particle instance.
            GetElementVertexProperties(element, properties);
        
            VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs, properties);
        #else
            VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
        #endif
            return vertexDescription;
        
        }
        
        AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters
        #ifdef USE_CUSTOMINTERP_SUBSTRUCT
            #ifdef TESSELLATION_ON
            , inout VaryingsMeshToDS varyings
            #else
            , inout VaryingsMeshToPS varyings
            #endif
        #endif
        #ifdef HAVE_VFX_MODIFICATION
                , AttributesElement element
        #endif
            )
        {
            VertexDescription vertexDescription = GetVertexDescription(input, timeParameters
        #ifdef HAVE_VFX_MODIFICATION
                , element
        #endif
            );
        
            // copy graph output to the results
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        input.positionOS = vertexDescription.Position;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        input.normalOS = vertexDescription.Normal;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        input.tangentOS.xyz = vertexDescription.Tangent;
        #endif
        
        
            varyings.UnmodPositionWSXZ = vertexDescription.UnmodPositionWSXZ;
        
            return input;
        }
        
        #if defined(_ADD_CUSTOM_VELOCITY) // For shader graph custom velocity
        // Return precomputed Velocity in object space
        float3 GetCustomVelocity(AttributesMesh input
        #ifdef HAVE_VFX_MODIFICATION
            , AttributesElement element
        #endif
        )
        {
            VertexDescription vertexDescription = GetVertexDescription(input, _TimeParameters.xyz
        #ifdef HAVE_VFX_MODIFICATION
                , element
        #endif
            );
            return vertexDescription.CustomVelocity;
        }
        #endif
        
        FragInputs BuildFragInputs(VaryingsMeshToPS input)
        {
            FragInputs output;
            ZERO_INITIALIZE(FragInputs, output);
        
            // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
            // TODO: this is a really poor workaround, but the variable is used in a bunch of places
            // to compute normals which are then passed on elsewhere to compute other values...
            output.tangentToWorld = k_identity3x3;
            output.positionSS = input.positionCS;       // input.positionCS is SV_Position
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.positionRWS =                input.positionRWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.positionPixel =              input.positionCS.xy; // NOTE: this is not actually in clip space, it is the VPOS pixel coordinate value
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.tangentToWorld =             BuildTangentToWorld(input.tangentWS, input.normalWS);
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.texCoord1 =                  input.texCoord1;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.texCoord2 =                  input.texCoord2;
        #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else
        #endif
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
        
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            // splice point to copy custom interpolator fields from varyings to frag inputs
            output.customInterpolators.UnmodPositionWSXZ = input.UnmodPositionWSXZ;
        
            return output;
        }
        
        // existing HDRP code uses the combined function to go directly from packed to frag inputs
        FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
        {
            UNITY_SETUP_INSTANCE_ID(input);
        #if defined(HAVE_VFX_MODIFICATION) && defined(UNITY_INSTANCING_ENABLED)
            unity_InstanceID = input.instanceID;
        #endif
            VaryingsMeshToPS unpacked = UnpackVaryingsMeshToPS(input);
            return BuildFragInputs(unpacked);
        }
            SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =                           normalize(input.tangentToWorld[2].xyz);
        #endif
        
            #if defined(SHADER_STAGE_RAY_TRACING)
            #else
            #endif
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceViewDirection =                    normalize(viewWS);
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpacePosition =                         input.positionRWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
        #endif
        
        
        #if UNITY_UV_STARTS_AT_TOP
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.PixelPosition = float2(input.positionPixel.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionPixel.y) : input.positionPixel.y);
        #endif
        
        #else
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.PixelPosition = float2(input.positionPixel.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionPixel.y) : input.positionPixel.y);
        #endif
        
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.FaceSign =                                   input.isFrontFace;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #endif
        
        
            // splice point to copy frag inputs custom interpolator pack into the SDI
            output.UnmodPositionWSXZ = input.customInterpolators.UnmodPositionWSXZ;
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data (Specific Material)
        
        void ApplyDecalToSurfaceDataNoNormal(DecalSurfaceData decalSurfaceData, inout SurfaceData surfaceData);
        
        void ApplyDecalAndGetNormal(FragInputs fragInputs, PositionInputs posInput, SurfaceDescription surfaceDescription,
            inout SurfaceData surfaceData)
        {
            float3 doubleSidedConstants = GetDoubleSidedConstants();
        
        #ifdef DECAL_NORMAL_BLENDING
            // SG nodes don't ouptut surface gradients, so if decals require surf grad blending, we have to convert
            // the normal to gradient before applying the decal. We then have to resolve the gradient back to world space
            float3 normalTS;
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        normalTS = SurfaceGradientFromPerturbedNormal(fragInputs.tangentToWorld[2],
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        surfaceDescription.NormalWS);
        #endif
        
        
            #if HAVE_DECALS
            if (_EnableDecals)
            {
                float alpha = 1.0;
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        alpha = surfaceDescription.Alpha;
        #endif
        
        
                DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, fragInputs, alpha);
                ApplyDecalToSurfaceNormal(decalSurfaceData, fragInputs.tangentToWorld[2], normalTS);
                ApplyDecalToSurfaceDataNoNormal(decalSurfaceData, surfaceData);
            }
            #endif
        
            GetNormalWS_SG(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        #else
            // normal delivered to master node
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        GetNormalWS_SrcWS(fragInputs, surfaceDescription.NormalWS, surfaceData.normalWS, doubleSidedConstants);
        #endif
        
        
            #if HAVE_DECALS
            if (_EnableDecals)
            {
                float alpha = 1.0;
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        alpha = surfaceDescription.Alpha;
        #endif
        
        
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        surfaceData.baseColor =                 surfaceDescription.BaseColor;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        surfaceData.ambientOcclusion =          surfaceDescription.Occlusion;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        surfaceData.transmissionMask =          surfaceDescription.TransmissionMask.xxx;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        surfaceData.thickness =                 surfaceDescription.Thickness;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        surfaceData.diffusionProfileHash =      asuint(surfaceDescription.DiffusionProfileHash);
        #endif
        
        
            #if defined(_REFRACTION_PLANE) || defined(_REFRACTION_SPHERE) || defined(_REFRACTION_THIN)
                if (_EnableSSRefraction)
                {
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
            #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
            #endif
        
            // These static material feature allow compile time optimization
            surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
            #ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
            #endif
        
            #ifdef _MATERIAL_FEATURE_TRANSMISSION
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
            #endif
        
            #ifdef _MATERIAL_FEATURE_COLORED_TRANSMISSION
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_COLORED_TRANSMISSION;
        
            #endif
        
            #ifdef _MATERIAL_FEATURE_ANISOTROPY
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
        
                // Initialize the normal to something non-zero to avoid a div-zero warning for anisotropy.
                surfaceData.normalWS = float3(0, 1, 0);
            #endif
        
            #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
            #endif
        
            #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
            #endif
        
            #ifdef _MATERIAL_FEATURE_CLEAR_COAT
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
            #endif
        
            #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
            #endif
        
            float3 doubleSidedConstants = GetDoubleSidedConstants();
        
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
        
                #ifndef SHADER_UNLIT
                #ifdef _DOUBLESIDED_ON
                    float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
                #else
                    float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
                #endif
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants); // Apply double sided flip on the vertex normal
                #endif // SHADER_UNLIT
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
        
                #if defined(HAVE_VFX_MODIFICATION)
                GraphProperties properties;
                ZERO_INITIALIZE(GraphProperties, properties);
        
                GetElementPixelProperties(fragInputs, properties);
        
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs, properties);
                #else
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
                #endif
        
                #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        surfaceDescription.Alpha = 1.0f;
        #endif
        
                }
                #endif
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                #ifdef _ALPHATEST_ON
                    float alphaCutoff = surfaceDescription.AlphaClipThreshold;
                    #if SHADERPASS == SHADERPASS_TRANSPARENT_DEPTH_PREPASS
                    // The TransparentDepthPrepass is also used with SSR transparent.
                    // If an artists enable transaprent SSR but not the TransparentDepthPrepass itself, then we use AlphaClipThreshold
                    // otherwise if TransparentDepthPrepass is enabled we use AlphaClipThresholdDepthPrepass
                    #elif SHADERPASS == SHADERPASS_TRANSPARENT_DEPTH_POSTPASS
                    // DepthPostpass always use its own alpha threshold
                    alphaCutoff = surfaceDescription.AlphaClipThresholdDepthPostpass;
                    #elif (SHADERPASS == SHADERPASS_SHADOWS) || (SHADERPASS == SHADERPASS_RAYTRACING_VISIBILITY)
                    // If use shadow threshold isn't enable we don't allow any test
                    #endif
        
                    GENERIC_ALPHA_TEST(surfaceDescription.Alpha, alphaCutoff);
                #endif
        
                #if !defined(SHADER_STAGE_RAY_TRACING) && _DEPTHOFFSET_ON
                ApplyDepthOffsetPositionInput(V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput);
                #endif
        
                #ifndef SHADER_UNLIT
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
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        alpha = surfaceDescription.Alpha;
        #endif
        
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal
                InitBuiltinData(posInput, alpha, bentNormalWS, -fragInputs.tangentToWorld[2], lightmapTexCoord1, lightmapTexCoord2, builtinData);
        
                #else
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                ZERO_BUILTIN_INITIALIZE(builtinData); // No call to InitBuiltinData as we don't have any lighting
                builtinData.opacity = surfaceDescription.Alpha;
        
                #if defined(DEBUG_DISPLAY)
                    // Light Layers are currently not used for the Unlit shader (because it is not lit)
                    // But Unlit objects do cast shadows according to their rendering layer mask, which is what we want to
                    // display in the light layers visualization mode, therefore we need the renderingLayers
                    builtinData.renderingLayers = GetMeshRenderingLayerMask();
                #endif
        
                #endif // SHADER_UNLIT
        
                #ifdef _ALPHATEST_ON
                    // Used for sharpening by alpha to mask - Alpha to covertage is only used with depth only and forward pass (no shadow pass, no transparent pass)
                    builtinData.alphaClipTreshold = alphaCutoff;
                #endif
        
                // override sampleBakedGI - not used by Unlit
        		// When overriding GI, we need to force the isLightmap flag to make sure we don't add APV (sampled in the lightloop) on top of the overridden value (set at GBuffer stage)
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        builtinData.emissiveColor = surfaceDescription.Emission;
        #endif
        
        
                // Note this will not fully work on transparent surfaces (can check with _SURFACE_TYPE_TRANSPARENT define)
                // We will always overwrite vt feeback with the nearest. So behind transparent surfaces vt will not be resolved
                // This is a limitation of the current MRT approach.
                #ifdef UNITY_VIRTUAL_TEXTURING
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        builtinData.vtPackedFeedback = surfaceDescription.VTPackedFeedback;
        #endif
        
                #endif
        
                #if _DEPTHOFFSET_ON
                builtinData.depthOffset = surfaceDescription.DepthOffset;
                #endif
        
                // TODO: We should generate distortion / distortionBlur for non distortion pass
                #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
                #endif
        
                #ifndef SHADER_UNLIT
                // PostInitBuiltinData call ApplyDebugToBuiltinData
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
                #else
                ApplyDebugToBuiltinData(builtinData);
                #endif
        
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            // --------------------------------------------------
            // Main
        
            #include "ShaderInclude/GOcean_Ocean_Pass_Forward.hlsl"
        
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
        
        	#ifdef HAVE_VFX_MODIFICATION
                #if !defined(SHADER_STAGE_RAY_TRACING)
        	    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/VisualEffectVertex.hlsl"
                #else
                #endif
        	#endif
        
            ENDHLSL
        }
    }
    
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "Rendering.HighDefinition.LitShaderGraphGUI" "UnityEngine.Rendering.HighDefinition.HDRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}