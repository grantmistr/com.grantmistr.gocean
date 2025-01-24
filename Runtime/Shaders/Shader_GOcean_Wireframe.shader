Shader "GOcean/Wireframe"
{
    Properties
    {
    }

    HLSLINCLUDE

    #include "ShaderInclude/GOcean_Wireframe_Properties.hlsl"

    ENDHLSL

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "HDRenderPipeline"
            "ForceNoShadowCasting" = "True"
            "Queue" = "Transparent+100"
        }

        Pass
        {
            Name "Wireframe"
        
            Tags
            {
            }
        
            ZWrite Off
            ZTest Off
            Cull Off
            Blend SrcAlpha OneMinusSrcAlpha
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag
        
            #include "ShaderInclude/GOcean_Wireframe_Vertex.hlsl"
            #include "ShaderInclude/GOcean_Wireframe_Fragment.hlsl"
        
            ENDHLSL
        }
    }
}