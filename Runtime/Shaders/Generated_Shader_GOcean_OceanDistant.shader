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
            // GraphKeywords: <None>
        
            // Defines
            #define SHADERPASS SHADERPASS_FORWARD
        #define SUPPORT_BLENDMODE_PRESERVE_SPECULAR_LIGHTING 1
        #define HAS_LIGHTLOOP 1
        #define RAYTRACING_SHADER_GRAPH_DEFAULT
        #define SHADER_LIT 1
        #define SUPPORT_GLOBAL_MIP_BIAS 1
        #define REQUIRE_DEPTH_TEXTURE
        
            // For custom interpolators to inject a substruct definition before FragInputs definition,
            // allowing for FragInputs to capture CI's intended for ShaderGraph's SDI.
            struct CustomInterpolators
        {
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
        
            #ifndef SHADER_UNLIT
            // We need isFrontFace when using double sided - it is not required for unlit as in case of unlit double sided only drive the cullmode
            // VARYINGS_NEED_CULLFACE can be define by VaryingsMeshToPS.FaceSign input if a IsFrontFace Node is included in the shader graph.
            #if defined(_DOUBLESIDED_ON) && !defined(VARYINGS_NEED_CULLFACE)
                #define VARYINGS_NEED_CULLFACE
            #endif
            #endif
        
            // Specific Material Define
        #define _SPECULAR_OCCLUSION_FROM_AO 1
        #define _ENERGY_CONSERVING_SPECULAR 1
        
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
        SAMPLER(SamplerState_Point_Clamp);
        SAMPLER(SamplerState_Trilinear_Repeat);
        TEXTURE2D(_FoamTexture);
        SAMPLER(sampler_FoamTexture);
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
            #include_with_pragmas "ShaderInclude/GOcean_UnderwaterSampling.hlsl"
        #include_with_pragmas "ShaderInclude/GOcean_Constants.hlsl"
        #include_with_pragmas "ShaderInclude/GOcean_StochasticSampling.hlsl"
        #include_with_pragmas "ShaderInclude/GOcean_HelperFunctions.hlsl"
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct AttributesMesh
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct VaryingsMeshToPS
        {
            SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
             float3 positionRWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float3 AbsoluteWorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
             float FaceSign;
        };
        struct PackedVaryingsMeshToPS
        {
            SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
             float3 positionRWS : INTERP3;
             float3 normalWS : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
        };
        
            PackedVaryingsMeshToPS PackVaryingsMeshToPS (VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            ZERO_INITIALIZE(PackedVaryingsMeshToPS, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionRWS.xyz = input.positionRWS;
            output.normalWS.xyz = input.normalWS;
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
            output.positionRWS = input.positionRWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            return output;
        }
        
        
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
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
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
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
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
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        // unity-custom-func-begin
        void GetRTHandleScale_float(out float4 RTHandleScale){
            RTHandleScale = _RTHandleScale;
        }
        // unity-custom-func-end
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Lerp_float2(float2 A, float2 B, float2 T, out float2 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
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
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
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
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
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
            float3 _GetUnderwaterFogColorCustomFunction_7ef7b58fa5334e96a8400c70cc91c1a3_underwaterFogColor_0_Vector3;
            GetUnderwaterFogColor_float(_GetUnderwaterFogColorCustomFunction_7ef7b58fa5334e96a8400c70cc91c1a3_underwaterFogColor_0_Vector3);
            float _Float_8207d3c4e4cf4209971d59c33eb54efc_Out_0_Float = float(0.3);
            float3 _Multiply_1bdbc0db56f142a1904df133a6eb900c_Out_2_Vector3;
            Unity_Multiply_float3_float3(_GetUnderwaterFogColorCustomFunction_7ef7b58fa5334e96a8400c70cc91c1a3_underwaterFogColor_0_Vector3, (_Float_8207d3c4e4cf4209971d59c33eb54efc_Out_0_Float.xxx), _Multiply_1bdbc0db56f142a1904df133a6eb900c_Out_2_Vector3);
            float2 _Vector2_017a259bf69c49f580eac4c03a9d4dbc_Out_0_Vector2 = float2(_ScreenParams.x, _ScreenParams.y);
            float4 _ScreenPosition_1cabb43338c04f7685a601b7cacfa141_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float _Property_3d7db3ace764482e939a39ce7f15ebd0_Out_0_Float = _RefractionStrength;
            float _Negate_8b3bac230ff944d2aa076ce76c61fa9a_Out_1_Float;
            Unity_Negate_float(_Property_3d7db3ace764482e939a39ce7f15ebd0_Out_0_Float, _Negate_8b3bac230ff944d2aa076ce76c61fa9a_Out_1_Float);
            UnityTexture2DArray _Property_cc46be5107094579bad23ddf0752bc5f_Out_0_Texture2DArray = UnityBuildTexture2DArrayStruct(_SpectrumTexture);
            float2 _Swizzle_81fc3cc121914324a9a04a4b4a9011ff_Out_1_Vector2 = IN.AbsoluteWorldSpacePosition.xz;
            float4 _GetPatchSizeCustomFunction_3d2cc90a35b2494db582765eb30bfefd_patchSize_0_Vector4;
            GetPatchSize_float(_GetPatchSizeCustomFunction_3d2cc90a35b2494db582765eb30bfefd_patchSize_0_Vector4);
            float _Split_22daf027e91748a4bf57fa97f7af9910_R_1_Float = _GetPatchSizeCustomFunction_3d2cc90a35b2494db582765eb30bfefd_patchSize_0_Vector4[0];
            float _Split_22daf027e91748a4bf57fa97f7af9910_G_2_Float = _GetPatchSizeCustomFunction_3d2cc90a35b2494db582765eb30bfefd_patchSize_0_Vector4[1];
            float _Split_22daf027e91748a4bf57fa97f7af9910_B_3_Float = _GetPatchSizeCustomFunction_3d2cc90a35b2494db582765eb30bfefd_patchSize_0_Vector4[2];
            float _Split_22daf027e91748a4bf57fa97f7af9910_A_4_Float = _GetPatchSizeCustomFunction_3d2cc90a35b2494db582765eb30bfefd_patchSize_0_Vector4[3];
            float2 _Divide_3bd6bc0225a548f3b6cc1eafd1e21698_Out_2_Vector2;
            Unity_Divide_float2(_Swizzle_81fc3cc121914324a9a04a4b4a9011ff_Out_1_Vector2, (_Split_22daf027e91748a4bf57fa97f7af9910_R_1_Float.xx), _Divide_3bd6bc0225a548f3b6cc1eafd1e21698_Out_2_Vector2);
            float4 _StochasticSampleTex2DArrayCustomFunction_77110cd072004e9cb005a4cac13c4a61_output_4_Vector4;
            StochasticSampleTex2DArray_float(_Property_cc46be5107094579bad23ddf0752bc5f_Out_0_Texture2DArray.tex, UnityBuildSamplerStateStruct(SamplerState_Trilinear_Repeat).samplerstate, _Divide_3bd6bc0225a548f3b6cc1eafd1e21698_Out_2_Vector2, float(9), _StochasticSampleTex2DArrayCustomFunction_77110cd072004e9cb005a4cac13c4a61_output_4_Vector4);
            float _Split_fd14af37199d45da895e57cb0006655f_R_1_Float = _StochasticSampleTex2DArrayCustomFunction_77110cd072004e9cb005a4cac13c4a61_output_4_Vector4[0];
            float _Split_fd14af37199d45da895e57cb0006655f_G_2_Float = _StochasticSampleTex2DArrayCustomFunction_77110cd072004e9cb005a4cac13c4a61_output_4_Vector4[1];
            float _Split_fd14af37199d45da895e57cb0006655f_B_3_Float = _StochasticSampleTex2DArrayCustomFunction_77110cd072004e9cb005a4cac13c4a61_output_4_Vector4[2];
            float _Split_fd14af37199d45da895e57cb0006655f_A_4_Float = _StochasticSampleTex2DArrayCustomFunction_77110cd072004e9cb005a4cac13c4a61_output_4_Vector4[3];
            float2 _Vector2_ab97968dbfb241f69ff93a76afa0f20a_Out_0_Vector2 = float2(_Split_fd14af37199d45da895e57cb0006655f_R_1_Float, _Split_fd14af37199d45da895e57cb0006655f_G_2_Float);
            float2 _Multiply_53a282da74c747e3b242f179ebeea68b_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Negate_8b3bac230ff944d2aa076ce76c61fa9a_Out_1_Float.xx), _Vector2_ab97968dbfb241f69ff93a76afa0f20a_Out_0_Vector2, _Multiply_53a282da74c747e3b242f179ebeea68b_Out_2_Vector2);
            float _Split_0ad19d68ee584f99b5a906065a3dbb24_R_1_Float = _Multiply_53a282da74c747e3b242f179ebeea68b_Out_2_Vector2[0];
            float _Split_0ad19d68ee584f99b5a906065a3dbb24_G_2_Float = _Multiply_53a282da74c747e3b242f179ebeea68b_Out_2_Vector2[1];
            float _Split_0ad19d68ee584f99b5a906065a3dbb24_B_3_Float = 0;
            float _Split_0ad19d68ee584f99b5a906065a3dbb24_A_4_Float = 0;
            float3 _Vector3_ed56c44007034456a63e620d56e82b7f_Out_0_Vector3 = float3(_Split_0ad19d68ee584f99b5a906065a3dbb24_R_1_Float, float(0), _Split_0ad19d68ee584f99b5a906065a3dbb24_G_2_Float);
            float3 _Add_50e1956cfdf7419eb781eb48670f3313_Out_2_Vector3;
            Unity_Add_float3(_Vector3_ed56c44007034456a63e620d56e82b7f_Out_0_Vector3, IN.WorldSpacePosition, _Add_50e1956cfdf7419eb781eb48670f3313_Out_2_Vector3);
            float4 _TransformWorldPosToClipPosCustomFunction_a9ca380e55b64bf38573aec51b48795a_posCS_1_Vector4;
            TransformWorldPosToClipPos_float(_Add_50e1956cfdf7419eb781eb48670f3313_Out_2_Vector3, _TransformWorldPosToClipPosCustomFunction_a9ca380e55b64bf38573aec51b48795a_posCS_1_Vector4);
            float _Split_a83fd47751ca4401bdbb367b1305dd08_R_1_Float = _TransformWorldPosToClipPosCustomFunction_a9ca380e55b64bf38573aec51b48795a_posCS_1_Vector4[0];
            float _Split_a83fd47751ca4401bdbb367b1305dd08_G_2_Float = _TransformWorldPosToClipPosCustomFunction_a9ca380e55b64bf38573aec51b48795a_posCS_1_Vector4[1];
            float _Split_a83fd47751ca4401bdbb367b1305dd08_B_3_Float = _TransformWorldPosToClipPosCustomFunction_a9ca380e55b64bf38573aec51b48795a_posCS_1_Vector4[2];
            float _Split_a83fd47751ca4401bdbb367b1305dd08_A_4_Float = _TransformWorldPosToClipPosCustomFunction_a9ca380e55b64bf38573aec51b48795a_posCS_1_Vector4[3];
            float2 _Vector2_e416a6c2600a42119ef6c7cdb0deb567_Out_0_Vector2 = float2(_Split_a83fd47751ca4401bdbb367b1305dd08_R_1_Float, _Split_a83fd47751ca4401bdbb367b1305dd08_G_2_Float);
            float _Float_8944cf15fe394d4d9be01b9abdcc6220_Out_0_Float = float(0.5);
            float2 _Multiply_23bf4ae237184d1caafe8d609c47a145_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_e416a6c2600a42119ef6c7cdb0deb567_Out_0_Vector2, (_Float_8944cf15fe394d4d9be01b9abdcc6220_Out_0_Float.xx), _Multiply_23bf4ae237184d1caafe8d609c47a145_Out_2_Vector2);
            float2 _Add_dfd68ddbe8ce4b749037aa939a1526e5_Out_2_Vector2;
            Unity_Add_float2(_Multiply_23bf4ae237184d1caafe8d609c47a145_Out_2_Vector2, (_Float_8944cf15fe394d4d9be01b9abdcc6220_Out_0_Float.xx), _Add_dfd68ddbe8ce4b749037aa939a1526e5_Out_2_Vector2);
            float _HDSceneDepth_a5c1fa4cfc394e8f9e87915d82a5f519_Output_2_Float = LinearEyeDepth(Unity_HDRP_SampleSceneDepth_float((float4(_Add_dfd68ddbe8ce4b749037aa939a1526e5_Out_2_Vector2, 0.0, 1.0)).xy, float(0)), _ZBufferParams);
            float4 _GetZBufferParamsCustomFunction_298bc398242149e5974d7c274c090ba7_zBufferParams_0_Vector4;
            GetZBufferParams_float(_GetZBufferParamsCustomFunction_298bc398242149e5974d7c274c090ba7_zBufferParams_0_Vector4);
            float _RawToViewDepthCustomFunction_496075975f1f4562b61a64e82b6613d0_viewDepth_2_Float;
            RawToViewDepth_float(_Split_a83fd47751ca4401bdbb367b1305dd08_B_3_Float, _GetZBufferParamsCustomFunction_298bc398242149e5974d7c274c090ba7_zBufferParams_0_Vector4, _RawToViewDepthCustomFunction_496075975f1f4562b61a64e82b6613d0_viewDepth_2_Float);
            float _Subtract_1a76f1f3d70941de873f36a58260c42a_Out_2_Float;
            Unity_Subtract_float(_HDSceneDepth_a5c1fa4cfc394e8f9e87915d82a5f519_Output_2_Float, _RawToViewDepthCustomFunction_496075975f1f4562b61a64e82b6613d0_viewDepth_2_Float, _Subtract_1a76f1f3d70941de873f36a58260c42a_Out_2_Float);
            float _Saturate_0705802465c3413eb3216120ef15e860_Out_1_Float;
            Unity_Saturate_float(_Subtract_1a76f1f3d70941de873f36a58260c42a_Out_2_Float, _Saturate_0705802465c3413eb3216120ef15e860_Out_1_Float);
            UnityTexture2D _Property_d9258f2048684c05ae4d0ffdf337085f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_OceanScreenTexture);
            float4 _GetRTHandleScaleCustomFunction_094d961ec562450aa878e06145da73a3_RTHandleScale_0_Vector4;
            GetRTHandleScale_float(_GetRTHandleScaleCustomFunction_094d961ec562450aa878e06145da73a3_RTHandleScale_0_Vector4);
            float2 _Multiply_80dbc60cc75947f69e2bed24ffff4991_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_dfd68ddbe8ce4b749037aa939a1526e5_Out_2_Vector2, (_GetRTHandleScaleCustomFunction_094d961ec562450aa878e06145da73a3_RTHandleScale_0_Vector4.xy), _Multiply_80dbc60cc75947f69e2bed24ffff4991_Out_2_Vector2);
            float4 _SampleTexture2D_af2fcd8026794ab889595ac7c85b5bde_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d9258f2048684c05ae4d0ffdf337085f_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Point_Clamp).samplerstate, _Property_d9258f2048684c05ae4d0ffdf337085f_Out_0_Texture2D.GetTransformedUV(_Multiply_80dbc60cc75947f69e2bed24ffff4991_Out_2_Vector2) );
            float _SampleTexture2D_af2fcd8026794ab889595ac7c85b5bde_R_4_Float = _SampleTexture2D_af2fcd8026794ab889595ac7c85b5bde_RGBA_0_Vector4.r;
            float _SampleTexture2D_af2fcd8026794ab889595ac7c85b5bde_G_5_Float = _SampleTexture2D_af2fcd8026794ab889595ac7c85b5bde_RGBA_0_Vector4.g;
            float _SampleTexture2D_af2fcd8026794ab889595ac7c85b5bde_B_6_Float = _SampleTexture2D_af2fcd8026794ab889595ac7c85b5bde_RGBA_0_Vector4.b;
            float _SampleTexture2D_af2fcd8026794ab889595ac7c85b5bde_A_7_Float = _SampleTexture2D_af2fcd8026794ab889595ac7c85b5bde_RGBA_0_Vector4.a;
            float _GetWaterSurfaceMaskCustomFunction_fd270492667f4e8588ee6745e804daa6_waterSurfaceMask_2_Boolean;
            GetWaterSurfaceMask_float(_SampleTexture2D_af2fcd8026794ab889595ac7c85b5bde_RGBA_0_Vector4, _GetWaterSurfaceMaskCustomFunction_fd270492667f4e8588ee6745e804daa6_waterSurfaceMask_2_Boolean);
            float _Multiply_d5cdd6e6754b41fbaf4720e87fcf6fb6_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_0705802465c3413eb3216120ef15e860_Out_1_Float, ((float) _GetWaterSurfaceMaskCustomFunction_fd270492667f4e8588ee6745e804daa6_waterSurfaceMask_2_Boolean), _Multiply_d5cdd6e6754b41fbaf4720e87fcf6fb6_Out_2_Float);
            float2 _Lerp_39574cc138934c6bb864c6a99b55776c_Out_3_Vector2;
            Unity_Lerp_float2((_ScreenPosition_1cabb43338c04f7685a601b7cacfa141_Out_0_Vector4.xy), _Add_dfd68ddbe8ce4b749037aa939a1526e5_Out_2_Vector2, (_Multiply_d5cdd6e6754b41fbaf4720e87fcf6fb6_Out_2_Float.xx), _Lerp_39574cc138934c6bb864c6a99b55776c_Out_3_Vector2);
            float2 _Multiply_f79d542a8dd14f5eb96e955a3e6500cc_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_017a259bf69c49f580eac4c03a9d4dbc_Out_0_Vector2, _Lerp_39574cc138934c6bb864c6a99b55776c_Out_3_Vector2, _Multiply_f79d542a8dd14f5eb96e955a3e6500cc_Out_2_Vector2);
            float2 _Vector2_45fb1f8542654b16a5c81c4f980198bc_Out_0_Vector2 = float2(_ScreenParams.x, _ScreenParams.y);
            float2 _Subtract_ff08498b300f4d908ee01e9ae7b17112_Out_2_Vector2;
            Unity_Subtract_float2(_Vector2_45fb1f8542654b16a5c81c4f980198bc_Out_0_Vector2, float2(1, 1), _Subtract_ff08498b300f4d908ee01e9ae7b17112_Out_2_Vector2);
            float2 _Clamp_ab1a5e6cb5614b17934b2d729e531a50_Out_3_Vector2;
            Unity_Clamp_float2(_Multiply_f79d542a8dd14f5eb96e955a3e6500cc_Out_2_Vector2, float2(0, 0), _Subtract_ff08498b300f4d908ee01e9ae7b17112_Out_2_Vector2, _Clamp_ab1a5e6cb5614b17934b2d729e531a50_Out_3_Vector2);
            float3 _LoadSceneColorCustomFunction_480ee51922d6442c9f3e71ab5bd9b08d_sceneColor_2_Vector3;
            LoadSceneColor_float(_Clamp_ab1a5e6cb5614b17934b2d729e531a50_Out_3_Vector2, float(0), _LoadSceneColorCustomFunction_480ee51922d6442c9f3e71ab5bd9b08d_sceneColor_2_Vector3);
            float _Property_c9fa301b719d406e9d9fd4952ca4240d_Out_0_Float = _UnderwaterSurfaceEmissionStrength;
            float3 _Multiply_1d8ed51b3d3c49b1be1e3578761ab70f_Out_2_Vector3;
            Unity_Multiply_float3_float3(_LoadSceneColorCustomFunction_480ee51922d6442c9f3e71ab5bd9b08d_sceneColor_2_Vector3, (_Property_c9fa301b719d406e9d9fd4952ca4240d_Out_0_Float.xxx), _Multiply_1d8ed51b3d3c49b1be1e3578761ab70f_Out_2_Vector3);
            float3 _Vector3_37e08b064c5c48fbbcac853645548258_Out_0_Vector3 = float3(_Split_fd14af37199d45da895e57cb0006655f_R_1_Float, float(1), _Split_fd14af37199d45da895e57cb0006655f_G_2_Float);
            float3 _Normalize_a42634cff39a45fa9d3b352aa9729e38_Out_1_Vector3;
            Unity_Normalize_float3(_Vector3_37e08b064c5c48fbbcac853645548258_Out_0_Vector3, _Normalize_a42634cff39a45fa9d3b352aa9729e38_Out_1_Vector3);
            float _DotProduct_5699bd5e26dd4c958929c3d6479679b4_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceViewDirection, _Normalize_a42634cff39a45fa9d3b352aa9729e38_Out_1_Vector3, _DotProduct_5699bd5e26dd4c958929c3d6479679b4_Out_2_Float);
            float _Multiply_282f1e9e65bd4cd8a87185b9a93afd4a_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_5699bd5e26dd4c958929c3d6479679b4_Out_2_Float, _DotProduct_5699bd5e26dd4c958929c3d6479679b4_Out_2_Float, _Multiply_282f1e9e65bd4cd8a87185b9a93afd4a_Out_2_Float);
            float _Comparison_39930a6b6aa8406a94c389d14da341c3_Out_2_Boolean;
            Unity_Comparison_Greater_float(_Multiply_282f1e9e65bd4cd8a87185b9a93afd4a_Out_2_Float, float(0.5), _Comparison_39930a6b6aa8406a94c389d14da341c3_Out_2_Boolean);
            float3 _Lerp_c06c95a829ad40a8a3c0df7963622bc0_Out_3_Vector3;
            Unity_Lerp_float3(_Multiply_1bdbc0db56f142a1904df133a6eb900c_Out_2_Vector3, _Multiply_1d8ed51b3d3c49b1be1e3578761ab70f_Out_2_Vector3, (((float) _Comparison_39930a6b6aa8406a94c389d14da341c3_Out_2_Boolean).xxx), _Lerp_c06c95a829ad40a8a3c0df7963622bc0_Out_3_Vector3);
            float3 _Multiply_3242f5afd6f64a6abd6fbf411581909a_Out_2_Vector3;
            Unity_Multiply_float3_float3(_LoadSceneColorCustomFunction_480ee51922d6442c9f3e71ab5bd9b08d_sceneColor_2_Vector3, _GetUnderwaterFogColorCustomFunction_7ef7b58fa5334e96a8400c70cc91c1a3_underwaterFogColor_0_Vector3, _Multiply_3242f5afd6f64a6abd6fbf411581909a_Out_2_Vector3);
            float _IsFrontFace_a9f616bad0ec48f99dd9cec5f68f5858_Out_0_Boolean = max(0, IN.FaceSign.x);
            float3 _Lerp_01a0b842f094403a853f69248d6585b2_Out_3_Vector3;
            Unity_Lerp_float3(_Lerp_c06c95a829ad40a8a3c0df7963622bc0_Out_3_Vector3, _Multiply_3242f5afd6f64a6abd6fbf411581909a_Out_2_Vector3, (((float) _IsFrontFace_a9f616bad0ec48f99dd9cec5f68f5858_Out_0_Boolean).xxx), _Lerp_01a0b842f094403a853f69248d6585b2_Out_3_Vector3);
            float _IsFrontFace_769a1fdfdb1f421e8c267313c19f5d55_Out_0_Boolean = max(0, IN.FaceSign.x);
            float _Multiply_2eac927ef6d84d358da9897d2a899c08_Out_2_Float;
            Unity_Multiply_float_float(((float) _IsFrontFace_769a1fdfdb1f421e8c267313c19f5d55_Out_0_Boolean), _SampleTexture2D_af2fcd8026794ab889595ac7c85b5bde_G_5_Float, _Multiply_2eac927ef6d84d358da9897d2a899c08_Out_2_Float);
            float _GetLightRayStrengthCustomFunction_3286cd222f0641879392892fda478380_lightRayStrength_0_Float;
            GetLightRayStrength_float(_GetLightRayStrengthCustomFunction_3286cd222f0641879392892fda478380_lightRayStrength_0_Float);
            float _Multiply_222a65760345483d843511a9defd3e22_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_2eac927ef6d84d358da9897d2a899c08_Out_2_Float, _GetLightRayStrengthCustomFunction_3286cd222f0641879392892fda478380_lightRayStrength_0_Float, _Multiply_222a65760345483d843511a9defd3e22_Out_2_Float);
            float _Multiply_3949383f718c4920943570e595be5555_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_222a65760345483d843511a9defd3e22_Out_2_Float, 0.5, _Multiply_3949383f718c4920943570e595be5555_Out_2_Float);
            float _Add_8ce9100052004f8e97177f2091e90760_Out_2_Float;
            Unity_Add_float(_Multiply_3949383f718c4920943570e595be5555_Out_2_Float, float(0.5), _Add_8ce9100052004f8e97177f2091e90760_Out_2_Float);
            float3 _Multiply_810579dfaebf463d8cf4ecfc2af8449d_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Lerp_01a0b842f094403a853f69248d6585b2_Out_3_Vector3, (_Add_8ce9100052004f8e97177f2091e90760_Out_2_Float.xxx), _Multiply_810579dfaebf463d8cf4ecfc2af8449d_Out_2_Vector3);
            float4 _Property_e499fcbad06444f1bfc22a659ead6c9b_Out_0_Vector4 = _FoamColor;
            float _Multiply_f293626da7174d878fa82fd028ffd2a3_Out_2_Float;
            Unity_Multiply_float_float(_Split_fd14af37199d45da895e57cb0006655f_A_4_Float, 0.25, _Multiply_f293626da7174d878fa82fd028ffd2a3_Out_2_Float);
            UnityTexture2D _Property_b5156cff547047d1b550aed135ffcb7a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FoamTexture);
            float _Property_28091815fb914da2b24d54004f8a84d7_Out_0_Float = _FoamOffsetSpeed;
            float _Multiply_432cffccae9f4b06ba8940ad1cf69a5f_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_28091815fb914da2b24d54004f8a84d7_Out_0_Float, _Multiply_432cffccae9f4b06ba8940ad1cf69a5f_Out_2_Float);
            float2 _Subtract_102f6bc8e078443980432340e732200c_Out_2_Vector2;
            Unity_Subtract_float2(_Swizzle_81fc3cc121914324a9a04a4b4a9011ff_Out_1_Vector2, (_Multiply_432cffccae9f4b06ba8940ad1cf69a5f_Out_2_Float.xx), _Subtract_102f6bc8e078443980432340e732200c_Out_2_Vector2);
            float _Property_3a53d0235cac4738a7cfe9b08b564102_Out_0_Float = _FoamTiling;
            float2 _Multiply_f723225d2aa742708ab4c0e22d0c0821_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Subtract_102f6bc8e078443980432340e732200c_Out_2_Vector2, (_Property_3a53d0235cac4738a7cfe9b08b564102_Out_0_Float.xx), _Multiply_f723225d2aa742708ab4c0e22d0c0821_Out_2_Vector2);
            float4 _SampleTexture2D_392108ddcb37494cb1954d3a944c4185_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b5156cff547047d1b550aed135ffcb7a_Out_0_Texture2D.tex, _Property_b5156cff547047d1b550aed135ffcb7a_Out_0_Texture2D.samplerstate, _Property_b5156cff547047d1b550aed135ffcb7a_Out_0_Texture2D.GetTransformedUV(_Multiply_f723225d2aa742708ab4c0e22d0c0821_Out_2_Vector2) );
            float _SampleTexture2D_392108ddcb37494cb1954d3a944c4185_R_4_Float = _SampleTexture2D_392108ddcb37494cb1954d3a944c4185_RGBA_0_Vector4.r;
            float _SampleTexture2D_392108ddcb37494cb1954d3a944c4185_G_5_Float = _SampleTexture2D_392108ddcb37494cb1954d3a944c4185_RGBA_0_Vector4.g;
            float _SampleTexture2D_392108ddcb37494cb1954d3a944c4185_B_6_Float = _SampleTexture2D_392108ddcb37494cb1954d3a944c4185_RGBA_0_Vector4.b;
            float _SampleTexture2D_392108ddcb37494cb1954d3a944c4185_A_7_Float = _SampleTexture2D_392108ddcb37494cb1954d3a944c4185_RGBA_0_Vector4.a;
            float2 _Add_ab0addb353d249f79539812ef19207d0_Out_2_Vector2;
            Unity_Add_float2(_Swizzle_81fc3cc121914324a9a04a4b4a9011ff_Out_1_Vector2, (_Multiply_432cffccae9f4b06ba8940ad1cf69a5f_Out_2_Float.xx), _Add_ab0addb353d249f79539812ef19207d0_Out_2_Vector2);
            float _Property_3792ceae650042d2beddaa769a4f3e99_Out_0_Float = _SecondaryFoamTiling;
            float2 _Multiply_966ea47dbd054c518e649df4c0736934_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_ab0addb353d249f79539812ef19207d0_Out_2_Vector2, (_Property_3792ceae650042d2beddaa769a4f3e99_Out_0_Float.xx), _Multiply_966ea47dbd054c518e649df4c0736934_Out_2_Vector2);
            float4 _SampleTexture2D_c9c8886f873646af9f5bbc49368d25f3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b5156cff547047d1b550aed135ffcb7a_Out_0_Texture2D.tex, _Property_b5156cff547047d1b550aed135ffcb7a_Out_0_Texture2D.samplerstate, _Property_b5156cff547047d1b550aed135ffcb7a_Out_0_Texture2D.GetTransformedUV(_Multiply_966ea47dbd054c518e649df4c0736934_Out_2_Vector2) );
            float _SampleTexture2D_c9c8886f873646af9f5bbc49368d25f3_R_4_Float = _SampleTexture2D_c9c8886f873646af9f5bbc49368d25f3_RGBA_0_Vector4.r;
            float _SampleTexture2D_c9c8886f873646af9f5bbc49368d25f3_G_5_Float = _SampleTexture2D_c9c8886f873646af9f5bbc49368d25f3_RGBA_0_Vector4.g;
            float _SampleTexture2D_c9c8886f873646af9f5bbc49368d25f3_B_6_Float = _SampleTexture2D_c9c8886f873646af9f5bbc49368d25f3_RGBA_0_Vector4.b;
            float _SampleTexture2D_c9c8886f873646af9f5bbc49368d25f3_A_7_Float = _SampleTexture2D_c9c8886f873646af9f5bbc49368d25f3_RGBA_0_Vector4.a;
            float _Multiply_d0f5076fa2134f72a6d40aa89be3d5ae_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_392108ddcb37494cb1954d3a944c4185_R_4_Float, _SampleTexture2D_c9c8886f873646af9f5bbc49368d25f3_R_4_Float, _Multiply_d0f5076fa2134f72a6d40aa89be3d5ae_Out_2_Float);
            float _Length_417f54ef7cba4eb6a55ee2f431640399_Out_1_Float;
            Unity_Length_float3(IN.WorldSpacePosition, _Length_417f54ef7cba4eb6a55ee2f431640399_Out_1_Float);
            float _Property_54294d90ca3949f08e603e33497e56d0_Out_0_Float = _FoamTextureFadeDistance;
            float _Divide_c84e235e0af84b44b2e89eab71556e92_Out_2_Float;
            Unity_Divide_float(_Length_417f54ef7cba4eb6a55ee2f431640399_Out_1_Float, _Property_54294d90ca3949f08e603e33497e56d0_Out_0_Float, _Divide_c84e235e0af84b44b2e89eab71556e92_Out_2_Float);
            float _Saturate_e1aac86fb76e4a18ac431d0851dfad9b_Out_1_Float;
            Unity_Saturate_float(_Divide_c84e235e0af84b44b2e89eab71556e92_Out_2_Float, _Saturate_e1aac86fb76e4a18ac431d0851dfad9b_Out_1_Float);
            float _OneMinus_1aed6eaea5794d818654465b535b7beb_Out_1_Float;
            Unity_OneMinus_float(_Saturate_e1aac86fb76e4a18ac431d0851dfad9b_Out_1_Float, _OneMinus_1aed6eaea5794d818654465b535b7beb_Out_1_Float);
            float _Multiply_7020cbe3bd7c448e961a76bcd3113f4e_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_d0f5076fa2134f72a6d40aa89be3d5ae_Out_2_Float, _OneMinus_1aed6eaea5794d818654465b535b7beb_Out_1_Float, _Multiply_7020cbe3bd7c448e961a76bcd3113f4e_Out_2_Float);
            float _Subtract_aff5a53c2ab24605866bd0070b916969_Out_2_Float;
            Unity_Subtract_float(_Multiply_f293626da7174d878fa82fd028ffd2a3_Out_2_Float, _Multiply_7020cbe3bd7c448e961a76bcd3113f4e_Out_2_Float, _Subtract_aff5a53c2ab24605866bd0070b916969_Out_2_Float);
            float _Property_fa549704f52247c49f276b4826dd723a_Out_0_Float = _DistantFoam;
            float _Multiply_0ede3b0519044f74a5f02dff22eb8cd9_Out_2_Float;
            Unity_Multiply_float_float(_Property_fa549704f52247c49f276b4826dd723a_Out_0_Float, _Saturate_e1aac86fb76e4a18ac431d0851dfad9b_Out_1_Float, _Multiply_0ede3b0519044f74a5f02dff22eb8cd9_Out_2_Float);
            float _Subtract_6c9c117901d346d3bb574ef32c03bb85_Out_2_Float;
            Unity_Subtract_float(_Subtract_aff5a53c2ab24605866bd0070b916969_Out_2_Float, _Multiply_0ede3b0519044f74a5f02dff22eb8cd9_Out_2_Float, _Subtract_6c9c117901d346d3bb574ef32c03bb85_Out_2_Float);
            float _Saturate_8f46f47b262441fbbc91b3aabb9acb01_Out_1_Float;
            Unity_Saturate_float(_Subtract_6c9c117901d346d3bb574ef32c03bb85_Out_2_Float, _Saturate_8f46f47b262441fbbc91b3aabb9acb01_Out_1_Float);
            float3 _Lerp_d2eb24f7702f4c4ebab7624b516c0fe7_Out_3_Vector3;
            Unity_Lerp_float3(_Multiply_810579dfaebf463d8cf4ecfc2af8449d_Out_2_Vector3, (_Property_e499fcbad06444f1bfc22a659ead6c9b_Out_0_Vector4.xyz), (_Saturate_8f46f47b262441fbbc91b3aabb9acb01_Out_1_Float.xxx), _Lerp_d2eb24f7702f4c4ebab7624b516c0fe7_Out_3_Vector3);
            float _IsFrontFace_70ee964821e141bb8d16a040813fbad6_Out_0_Boolean = max(0, IN.FaceSign.x);
            float _Property_b6ecf90bf2b242da85c97c120a0ef041_Out_0_Float = _DistantSmoothness;
            float _Property_74692d0d83f744a3b8af508581cbba36_Out_0_Float = _Smoothness;
            float _Property_192b0538c4394981b46eec7daabba54f_Out_0_Float = _SmoothnessTransitionDistance;
            float _Divide_55373225fde24bc5aa8f8313b0494bdf_Out_2_Float;
            Unity_Divide_float(_Length_417f54ef7cba4eb6a55ee2f431640399_Out_1_Float, _Property_192b0538c4394981b46eec7daabba54f_Out_0_Float, _Divide_55373225fde24bc5aa8f8313b0494bdf_Out_2_Float);
            float _OneMinus_dd8cd792cfa94b57a96ce78fecee7e7a_Out_1_Float;
            Unity_OneMinus_float(_Divide_55373225fde24bc5aa8f8313b0494bdf_Out_2_Float, _OneMinus_dd8cd792cfa94b57a96ce78fecee7e7a_Out_1_Float);
            float _Saturate_09804e3fa5c34d3ca8ef1d90aa183433_Out_1_Float;
            Unity_Saturate_float(_OneMinus_dd8cd792cfa94b57a96ce78fecee7e7a_Out_1_Float, _Saturate_09804e3fa5c34d3ca8ef1d90aa183433_Out_1_Float);
            float _Multiply_842a424b242a48878056cd3ccd85819b_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_09804e3fa5c34d3ca8ef1d90aa183433_Out_1_Float, _Saturate_09804e3fa5c34d3ca8ef1d90aa183433_Out_1_Float, _Multiply_842a424b242a48878056cd3ccd85819b_Out_2_Float);
            float _Lerp_ee9215c239fb448faf389acdfa533bc7_Out_3_Float;
            Unity_Lerp_float(_Property_b6ecf90bf2b242da85c97c120a0ef041_Out_0_Float, _Property_74692d0d83f744a3b8af508581cbba36_Out_0_Float, _Multiply_842a424b242a48878056cd3ccd85819b_Out_2_Float, _Lerp_ee9215c239fb448faf389acdfa533bc7_Out_3_Float);
            float _OneMinus_85fdbf8e5e1a4847a4140bfcec7d7410_Out_1_Float;
            Unity_OneMinus_float(_Saturate_8f46f47b262441fbbc91b3aabb9acb01_Out_1_Float, _OneMinus_85fdbf8e5e1a4847a4140bfcec7d7410_Out_1_Float);
            float _Multiply_cd2328c6c4584323a1a066254ea11f44_Out_2_Float;
            Unity_Multiply_float_float(_Lerp_ee9215c239fb448faf389acdfa533bc7_Out_3_Float, _OneMinus_85fdbf8e5e1a4847a4140bfcec7d7410_Out_1_Float, _Multiply_cd2328c6c4584323a1a066254ea11f44_Out_2_Float);
            float _Multiply_d439d92969d9456b9b7b3438d3123de1_Out_2_Float;
            Unity_Multiply_float_float(((float) _IsFrontFace_70ee964821e141bb8d16a040813fbad6_Out_0_Boolean), _Multiply_cd2328c6c4584323a1a066254ea11f44_Out_2_Float, _Multiply_d439d92969d9456b9b7b3438d3123de1_Out_2_Float);
            float _Property_b693b1ff08624104acc62ce2c462b780_Out_0_Float = _ScatteringFalloff;
            float _Divide_f333126a585e4cb4b0e404f4d6e74c42_Out_2_Float;
            Unity_Divide_float(_Split_fd14af37199d45da895e57cb0006655f_B_3_Float, _Property_b693b1ff08624104acc62ce2c462b780_Out_0_Float, _Divide_f333126a585e4cb4b0e404f4d6e74c42_Out_2_Float);
            float _Saturate_be593f2883ee458b8d54c27ae0e06f32_Out_1_Float;
            Unity_Saturate_float(_Divide_f333126a585e4cb4b0e404f4d6e74c42_Out_2_Float, _Saturate_be593f2883ee458b8d54c27ae0e06f32_Out_1_Float);
            float _OneMinus_f01dd0fa31554e0782fdc8275f20a3c9_Out_1_Float;
            Unity_OneMinus_float(_Saturate_be593f2883ee458b8d54c27ae0e06f32_Out_1_Float, _OneMinus_f01dd0fa31554e0782fdc8275f20a3c9_Out_1_Float);
            float _Add_01c4ce43e2e745a5a368f8387de313a3_Out_2_Float;
            Unity_Add_float(_OneMinus_f01dd0fa31554e0782fdc8275f20a3c9_Out_1_Float, _Saturate_8f46f47b262441fbbc91b3aabb9acb01_Out_1_Float, _Add_01c4ce43e2e745a5a368f8387de313a3_Out_2_Float);
            float _Property_031d49afba4148e08743118aad206cb2_Out_0_Float = _DiffusionProfile;
            surface.BaseColor = _Lerp_d2eb24f7702f4c4ebab7624b516c0fe7_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = float(1);
            surface.BentNormal = IN.TangentSpaceNormal;
            surface.Smoothness = _Multiply_d439d92969d9456b9b7b3438d3123de1_Out_2_Float;
            surface.Occlusion = float(1);
            surface.NormalWS = _Normalize_a42634cff39a45fa9d3b352aa9729e38_Out_1_Vector3;
            surface.TransmissionMask = _OneMinus_85fdbf8e5e1a4847a4140bfcec7d7410_Out_1_Float;
            surface.Thickness = _Add_01c4ce43e2e745a5a368f8387de313a3_Out_2_Float;
            surface.DiffusionProfileHash = _Property_031d49afba4148e08743118aad206cb2_Out_0_Float;
            {
                surface.VTPackedFeedback = float4(1.0f,1.0f,1.0f,1.0f);
            }
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
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
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
            input.positionOS = vertexDescription.Position;
            input.normalOS = vertexDescription.Normal;
            input.tangentOS.xyz = vertexDescription.Tangent;
        
            
        
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
        
            output.positionRWS =                input.positionRWS;
            output.positionPixel =              input.positionCS.xy; // NOTE: this is not actually in clip space, it is the VPOS pixel coordinate value
            output.tangentToWorld =             BuildTangentToWorld(input.tangentWS, input.normalWS);
            output.texCoord1 =                  input.texCoord1;
            output.texCoord2 =                  input.texCoord2;
        
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
        
            output.WorldSpaceNormal =                           normalize(input.tangentToWorld[2].xyz);
            #if defined(SHADER_STAGE_RAY_TRACING)
            #else
            #endif
            output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
            output.WorldSpaceViewDirection =                    normalize(viewWS);
            output.WorldSpacePosition =                         input.positionRWS;
            output.AbsoluteWorldSpacePosition =                 GetAbsolutePositionWS(input.positionRWS);
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
        
        #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionPixel.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionPixel.y) : input.positionPixel.y);
        #else
            output.PixelPosition = float2(input.positionPixel.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionPixel.y) : input.positionPixel.y);
        #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.FaceSign =                                   input.isFrontFace;
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        
            // splice point to copy frag inputs custom interpolator pack into the SDI
            
        
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
                    surfaceDescription.Alpha = 1.0f;
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
                alpha = surfaceDescription.Alpha;
        
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
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
                // Note this will not fully work on transparent surfaces (can check with _SURFACE_TYPE_TRANSPARENT define)
                // We will always overwrite vt feeback with the nearest. So behind transparent surfaces vt will not be resolved
                // This is a limitation of the current MRT approach.
                #ifdef UNITY_VIRTUAL_TEXTURING
                builtinData.vtPackedFeedback = surfaceDescription.VTPackedFeedback;
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
        
            #include "ShaderInclude/GOcean_Distant_Pass_Forward.hlsl"
        
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