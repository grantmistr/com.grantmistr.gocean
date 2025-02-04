Shader "GOcean/WaterScreenMask"
{
    Properties
    {
        _ChunkGridResolution("_ChunkGridResolution", Int) = 3
        _ChunkSize("_ChunkSize", Int) = 1
    }

    HLSLINCLUDE

    #include "ShaderInclude/GOcean_WaterScreenMask_Properties.hlsl"

    ENDHLSL

    SubShader
    {
        Pass
        {
            Name "Clear"

            Tags
            {
            }

            Stencil
            {
                Ref 0
                WriteMask 255
                Comp Always
                Pass Replace
            }

            ZWrite On
            ZTest Off
            Cull Back
            Blend Off

            HLSLPROGRAM

            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _ UNITY_REVERSED_Z

            #include "ShaderInclude/GOcean_WaterScreenMask_Pass_Clear.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "ScreenMask"

            Tags
            {
            }

            Stencil
            {
                Ref 3
                WriteMask 3
                Comp Always
                Pass Replace
            }

            ZWrite On
            ZTest LEqual
            Cull Off
            Blend Off

            HLSLPROGRAM
            
            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag

            #include "ShaderInclude/GOcean_WaterScreenMask_Pass_ScreenMask.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "UnderwaterPyramid"

            Tags
            {
            }

            Stencil
            {
                Ref 1
                ReadMask 1
                WriteMask 1
                Comp Greater
                Pass Replace
            }

            ZWrite Off
            ZTest Less
            Cull Back
            Blend Off
            ColorMask B

            HLSLPROGRAM
            
            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag

            #include "ShaderInclude/GOcean_WaterScreenMask_Pass_UnderwaterPyramid.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "ClearMasks"

            Tags
            {
            }

            ZWrite Off
            ZTest Off
            Cull Back
            BlendOp LogicalAnd
            ColorMask R

            HLSLPROGRAM

            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _ UNITY_REVERSED_Z

            #include "ShaderInclude/GOcean_WaterScreenMask_Pass_ClearMasks.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "EncodeMasks"

            Tags
            {
            }

            ZWrite Off
            ZTest Off
            Cull Back
            BlendOp LogicalOr
            ColorMask R

            HLSLPROGRAM

            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _ UNITY_REVERSED_Z

            #include "ShaderInclude/GOcean_WaterScreenMask_Pass_EncodeMasks.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "HorizontalBlur"

            Tags
            {
            }

            ZWrite Off
            ZTest Off
            Cull Back
            Blend Off
            ColorMask BA            

            HLSLPROGRAM

            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _ UNITY_REVERSED_Z

            #include "ShaderInclude/GOcean_WaterScreenMask_Pass_HorizontalBlur.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "VerticalBlur"

            Tags
            {
            }

            ZWrite Off
            ZTest Off
            Cull Back
            Blend Off
            ColorMask RG

            HLSLPROGRAM

            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _ UNITY_REVERSED_Z

            #include "ShaderInclude/GOcean_WaterScreenMask_Pass_VerticalBlur.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "DepthOnlyOcean"

            Tags
            {
            }

            Stencil
            {
                Ref 2
                WriteMask 2
                Comp Always
                Pass Replace
            }

            ZWrite On
            ZTest LEqual
            Cull Off
            Blend Off
            ColorMask RGA

            HLSLPROGRAM
            
            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag

            #include "ShaderInclude/GOcean_WaterScreenMask_Pass_ScreenMask.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "DepthOnlyDistantOcean"

            Tags
            {
            }

            Stencil
            {
                Ref 4
                WriteMask 4
                Comp Always
                Pass Replace
            }

            ZWrite On
            ZTest Off
            Cull Back
            Blend Off
            ColorMask A

            HLSLPROGRAM
            
            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _ UNITY_REVERSED_Z
            #pragma multi_compile_fragment _ UNITY_UV_STARTS_AT_TOP

            #include "ShaderInclude/GOcean_WaterScreenMask_Pass_DepthOnlyDistantOcean.hlsl"

            ENDHLSL
        }
    }
}