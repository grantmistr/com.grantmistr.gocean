#if SHADERPASS != SHADERPASS_GBUFFER
#error SHADERPASS_is_not_correctly_define
#endif

#include "GOcean_HelperFunctions.hlsl"
#include "GOcean_GetTrisFromBuffer.hlsl"

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

PackedVaryingsType Vert(uint vertexID : SV_VertexID
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
, uint instanceID : SV_InstanceID
#endif
)
{
    AttributesMesh inputMesh;
    inputMesh.positionOS = 0.0;

#ifdef ATTRIBUTES_NEED_VERTEXID
    inputMesh.vertexID = vertexID;
#endif
#ifdef ATTRIBUTES_NEED_TEXCOORD0
    inputMesh.uv0 = 0.0;
#endif
#ifdef ATTRIBUTES_NEED_TEXCOORD1
    inputMesh.uv1 = 0.0;
#endif
#ifdef ATTRIBUTES_NEED_TEXCOORD2
    inputMesh.uv2 = 0.0;
#endif
#ifdef ATTRIBUTES_NEED_TEXCOORD3
    inputMesh.uv3 = 0.0;
#endif
#ifdef ATTRIBUTES_NEED_NORMAL
    inputMesh.normalOS = 0.0;
#endif
#ifdef ATTRIBUTES_NEED_TANGENT
    inputMesh.tangentOS = 0.0;
#endif
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
    inputMesh.instanceID = instanceID;
#endif
    
    VaryingsType varyingsType;

#if defined(HAVE_RECURSIVE_RENDERING)
    // If we have a recursive raytrace object, we will not render it.
    // As we don't want to rely on renderqueue to exclude the object from the list,
    // we cull it by settings position to NaN value.
    // TODO: provide a solution to filter dyanmically recursive raytrace object in the DrawRenderer
    if (_EnableRecursiveRayTracing && _RayTracing > 0.0)
    {
        ZERO_INITIALIZE(VaryingsType, varyingsType); // Divide by 0 should produce a NaN and thus cull the primitive.
    }
    else
#endif
    {
        varyingsType.vmesh = VertMesh(inputMesh);
    }

    return PackVaryingsType(varyingsType);
}

#ifdef TESSELLATION_ON

PackedVaryingsToPS VertTesselation(VaryingsToDS input)
{
    VaryingsToPS output;
    output.vmesh = VertMeshTesselation(input.vmesh);
    return PackVaryingsToPS(output);
}

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/TessellationShare.hlsl"

#endif // TESSELLATION_ON

void Frag(  PackedVaryingsToPS packedInput,
            OUTPUT_GBUFFER(outGBuffer)
            #ifdef _DEPTHOFFSET_ON
            , out float outputDepth : DEPTH_OFFSET_SEMANTIC
            #endif
            )
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
    FragInputs input = UnpackVaryingsToFragInputs(packedInput);
    input.tangentToWorld = M_3x3_identity;

    // input.positionSS is SV_Position
    PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

#ifdef VARYINGS_NEED_POSITION_WS
    float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
#else
    // Unused
    float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0
#endif

    SurfaceData surfaceData;
    BuiltinData builtinData;
    GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

    //builtinData.renderingLayers = DEFAULT_LIGHT_LAYERS;

    ENCODE_INTO_GBUFFER(surfaceData, builtinData, posInput.positionSS, outGBuffer);

#ifdef _DEPTHOFFSET_ON
    outputDepth = posInput.deviceDepth;
#endif

}
