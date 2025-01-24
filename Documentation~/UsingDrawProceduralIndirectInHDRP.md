We need to modify the vertex program. It accepts an "AttributesMesh" as input. This is a struct defined in the generated shader. It looks something like this:

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

This is the struct that we need to imitate / fill in the vertex program. Any draw procedural calls WILL NOT RENDER if the input to the vertex program contains
anything other than "vertexID" and "instanceID" apparently (https://discussions.unity.com/t/drawproceduralindirect-broken-in-2021-2-with-dx12-vulkan/847985/17).
This info may or may not still be relevant. Assuming it is... to fix this, we duplicate the .hlsl file for the pass we want (ShaderPassForward,
ShaderPassDepthOnly,ShaderPassGBuffer, etc) and modify the vertex program.

These files are located in "./Library/PackageCache/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass".

We can then modify the method signature from:

    PackedVaryingsType Vert(AttributesMesh inputMesh)

To:

    PackedVaryingsType Vert(uint vertexID : SV_VertexID
    #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
    , uint instanceID : SV_InstanceID
    #endif
    )

Then, do your actual vertex program logic. Example:

    float2 preDisplacedPositionXZ;
    float3 displacedPosition;
    GetVertexFromBuffer(vertexID, preDisplacedPositionXZ, displacedPosition);

Next, declare and fill the "AttributesMesh" struct with the data you need:

        AttributesMesh inputMesh;
        inputMesh.positionOS = displacedPosition;
    
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

Finally, paste in the code that was initially in the function:

        VaryingsType varyingsType;

    #if defined(HAVE_RECURSIVE_RENDERING)
        if (_EnableRecursiveRayTracing && _RayTracing > 0.0)
        {
            ZERO_INITIALIZE(VaryingsType, varyingsType);
        }
        else
    #endif
        {
            varyingsType.vmesh = VertMesh(inputMesh);
        }

        return PackVaryingsType(varyingsType);

If you have custom interpolators, you can set them like so:

    varyingsType.vmesh.[YOUR CUSTOM INTERPOLATOR] = ...

Example:

    #ifdef USE_CUSTOMINTERP_SUBSTRUCT // Unity generated keyword when you have custom interpolators
        varyingsType.vmesh.PreDisplacedPositionXZ = preDisplacedPositionXZ;
    #endif

Alternatively, you can keep the vertex program logic in the shader graph, and just pass through vertexID / instanceID here, which is probably simpler... since
you have to input dummy values into your custom interpolators to make Unity put them in the generated struct.