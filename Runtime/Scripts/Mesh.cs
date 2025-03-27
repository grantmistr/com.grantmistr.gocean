using UnityEngine;
using UnityEngine.Rendering;

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;
    using static Helper;
    using static MeshChunks;

    public class Mesh : Component
    {
        public const int MAX_SUPPORTED_TESSELLATION_LEVEL = 6;
        public const int INDIRECT_ARGS_LENGTH = 15;
        public const int UNDERWATER_MASK_VERTEX_COUNT = 12;

        [ShaderParam("_ChunkSize")]
        public int chunkSize;
        [ShaderParam("_ChunkGridResolution")]
        public int chunkGridResolution;
        [ShaderParam("_MaxTessellation")]
        public int maxTessellation;
        [ShaderParam("_TessellationFalloff")]
        public float tessellationFalloff;
        [ShaderParam("_TessellationOffset")]
        public float tessellationOffset;
        [ShaderParam("_CullPadding")]
        public float cullPadding;
        [ShaderParam("_DisplacementFalloff")]
        public float displacementFalloff;
        public bool drawWireframe;

        [ShaderParam("_DisplacementMaxDistance")]
        public float displacementMaxDistance;

        [ShaderParam("_SubChunkBuffer")]
        public ComputeBuffer subChunkBuffer;
        [ShaderParam("_VertexBuffer")]
        public ComputeBuffer vertexBuffer;
        [ShaderParam("_IndirectArgsBuffer")]
        public GraphicsBuffer indirectArgsBuffer;

        private ThreadGroups threadGroups;
        private KernelIDs kernelIDs;

        private RenderParams wireframeRenderParams;

        public Bounds MeshBounds { get { return meshBounds; } }
        private Bounds meshBounds = new Bounds(Vector3.zero, Vector3.one);

        public Bounds MeshBoundsHDRP { get { return meshBoundsHDRP; } }
        private Bounds meshBoundsHDRP = new Bounds(Vector3.zero, Vector3.one);

        public bool DrawMesh { get { return drawMesh; } }
        private bool drawMesh = true;

        /// <summary>
        /// Indirect args offsets in bytes
        /// </summary>
        public static class IndirectArgsOffsetsByte
        {
            public const uint
                VERTEX_COUNT = 0,
                TOTAL_VERTEX_COUNT = 16,
                TRIANGLE_FILL = 32,
                DISPLACE_VERTICES = 44;
        }

        /// <summary>
        /// Indirect args offsets
        /// </summary>
        public static class IndirectArgsOffsets
        {
            public const uint
                VERTEX_COUNT = 0,
                TOTAL_VERTEX_COUNT = 4,
                TRIANGLE_FILL = 8,
                DISPLACE_VERTICES = 11;
        }

        /// <summary>
        /// Start command index when using RenderPrimitves
        /// </summary>
        public static class IndirectStartCommand
        {
            public const uint
                VERTEX_COUNT = 0,
                TOTAL_VERTEX_COUNT = 1;
        }

        public struct KernelIDs
        {
            public int ResetIndirectArgsBuffer { get; private set; }
            public int FillSubChunkBuffer { get; private set; }
            public int FillVertexBuffer { get; private set; }
            public int FillUnderwaterMaskVertices { get; private set; }

            public KernelIDs(Mesh mesh)
            {
                ResetIndirectArgsBuffer = mesh.ocean.MeshCS.FindKernel("ResetIndirectArgsBuffer");
                FillSubChunkBuffer = mesh.ocean.MeshCS.FindKernel("FillSubChunkBuffer");
                FillVertexBuffer = mesh.ocean.MeshCS.FindKernel("FillVertexBuffer");
                FillUnderwaterMaskVertices = mesh.ocean.MeshCS.FindKernel("FillUnderwaterMaskVertices");
            }
        }

        public struct ThreadGroups
        {
            public Vector3Int FillSubChunkBuffer { get; private set; }

            public ThreadGroups(Mesh mesh)
            {
                Vector3Int v = new Vector3Int();
                v.x = 1;
                v.y = 1;
                v.z = mesh.chunkGridResolution * mesh.chunkGridResolution;

                FillSubChunkBuffer = v;
            }

            public void Initialize(Mesh mesh)
            {
                Vector3Int v = new Vector3Int();
                v.x = 1;
                v.y = 1;
                v.z = mesh.chunkGridResolution * mesh.chunkGridResolution;

                FillSubChunkBuffer = v;
            }
        }

        private struct Vertex
        {
            public Vector3 position;
            public Vector2 preDisplacedPositionXZ;

            public Vertex(Vector3 position, Vector2 preDisplacedPositionXZ)
            {
                this.position = position;
                this.preDisplacedPositionXZ = preDisplacedPositionXZ;
            }

            public static int SizeOf()
            {
                return sizeof(float) * 5;
            }
        }

        private struct Triangle_Vertex
        {
            public Vertex[] vertices;

            public Triangle_Vertex(Vertex a, Vertex b, Vertex c)
            {
                vertices = new Vertex[3]
                {
                    a, b, c
                };
            }

            public static int SizeOf()
            {
                return Vertex.SizeOf() * 3;
            }
        }

        private struct Chunk
        {
            public int tessellation;
            public uint type;
            public Vector2 position;

            public Chunk(int tessellation, uint type, Vector2 position)
            {
                this.tessellation = tessellation;
                this.type = type;
                this.position = position;
            }

            public static int SizeOf()
            {
                return sizeof(int) * 2 + sizeof(float) * 2;
            }
        }

        private struct SubChunk
        {
            public uint data;
            public Vector2 position;

            public SubChunk(uint data, Vector2 position)
            {
                this.data = data;
                this.position = position;
            }

            public void EncodeData(uint tessellation, uint type, uint scaleFactor)
            {
                uint o;

                o = scaleFactor;
                o <<= 4;
                o |= type;
                o <<= 4;
                o |= tessellation;

                data = o;
            }

            public void DecodeData(out uint tessellation, out uint type, out uint scaleFactor)
            {
                uint o = data;

                tessellation = o & 0xF;
                o >>= 4;
                type = o & 0xF;
                o >>= 4;
                scaleFactor = o;
            }

            public static int SizeOf()
            {
                return sizeof(int) + sizeof(float) * 2;
            }
        }

        public Mesh()
        {
        }

        public override void Initialize()
        {
            InitializeParams(ocean.parametersUser.mesh);

            kernelIDs = new KernelIDs(this);
            threadGroups = new ThreadGroups(this);

            MCSArrays.AddComputeShader(ocean.MeshCS, kernelIDs.FillSubChunkBuffer, kernelIDs.FillVertexBuffer,
                kernelIDs.ResetIndirectArgsBuffer, kernelIDs.FillUnderwaterMaskVertices);

            InitializeBounds(chunkSize, chunkGridResolution);
            InitializeSubChunkBuffer();
            InitializeVertexBuffer();
            InitializeIndirectArgsBuffer();
            InitializeRenderParams();
        }

        public override void ReleaseResources()
        {
            ReleaseBuffer(ref subChunkBuffer);
            ReleaseBuffer(ref vertexBuffer);
            ReleaseBuffer(ref indirectArgsBuffer);
        }

        public override void InitializeParams(BaseParamsUser userParams)
        {
            MeshParamsUser u = userParams as MeshParamsUser;

            chunkSize = u.chunkSize;
            maxTessellation = u.maxTessellation;
            tessellationFalloff = u.tessellationFalloff;
            tessellationOffset = u.tessellationOffset;
            cullPadding = u.cullPadding;
            displacementFalloff = u.displacementFalloff;
            chunkGridResolution = u.chunkGridResolution;
            displacementMaxDistance = CalculateDisplacementMaxDistance(chunkGridResolution, chunkSize);
            drawWireframe = u.drawWireframe;
        }

        public override void SetShaderParams()
        {
            SetKeyword(ocean.MeshCS, PropIDs.ShaderKeywords.UNITY_UV_STARTS_AT_TOP, SystemInfo.graphicsUVStartsAtTop);
            SetKeyword(ocean.MeshCS, PropIDs.ShaderKeywords.UNITY_REVERSED_Z, SystemInfo.usesReversedZBuffer);

            base.SetShaderParams();
        }

        public void UpdateMesh(CommandBuffer cmd, Plane[] frustumPlanes, RTHandle cameraDepthBuffer, Vector3 cameraPosition)
        {
            UpdateBounds(cameraPosition);
            
            drawMesh = GeometryUtility.TestPlanesAABB(frustumPlanes, meshBoundsHDRP);

            if (!drawMesh)
            {
                return;
            }

            // reset indirect args buffer counter values to 0
            cmd.DispatchCompute(ocean.MeshCS, kernelIDs.ResetIndirectArgsBuffer, 1, 1, 1);

            // set compute params
            cmd.SetComputeTextureParam(ocean.MeshCS, kernelIDs.FillVertexBuffer, PropIDs.cameraDepthTexture, cameraDepthBuffer);

            // dispatch fill sub chunk buffer kernel
            cmd.DispatchCompute(ocean.MeshCS, kernelIDs.FillSubChunkBuffer, threadGroups.FillSubChunkBuffer);

            // dispatch triangle fill kernel
            cmd.DispatchCompute(ocean.MeshCS, kernelIDs.FillVertexBuffer, indirectArgsBuffer, IndirectArgsOffsetsByte.TRIANGLE_FILL);

            // add vertices for underwater mask
            cmd.DispatchCompute(ocean.MeshCS, kernelIDs.FillUnderwaterMaskVertices, 1, 1, 1);
        }

        public void DrawWireframe(CommandBuffer cmd, RTHandle cameraColorBuffer)
        {
            if (drawMesh && drawWireframe)
            {
                CoreUtils.SetRenderTarget(cmd, cameraColorBuffer);
                cmd.DrawProceduralIndirect(Matrix4x4.identity, ocean.WireframeM, 0, MeshTopology.Triangles, indirectArgsBuffer, (int)IndirectArgsOffsetsByte.TOTAL_VERTEX_COUNT);
            }
        }

        public void DrawWireframe()
        {
            if (drawMesh && drawWireframe)
            {
                Graphics.RenderPrimitivesIndirect(wireframeRenderParams, MeshTopology.Triangles, indirectArgsBuffer, 1, (int)IndirectStartCommand.VERTEX_COUNT);
            }
        }

        private void UpdateBounds(Vector3 cameraPosition)
        {
            meshBounds.center = new Vector3(ocean.CameraPositionStepped.x, components.Generic.waterHeight, ocean.CameraPositionStepped.y);
            meshBoundsHDRP.center = meshBounds.center - cameraPosition;
        }

        public void UpdateBounds(float maxAmplitude)
        {
            meshBounds = new Bounds(Vector3.zero, new Vector3(meshBounds.size.x, maxAmplitude * 2f, meshBounds.size.z));
            meshBoundsHDRP = meshBounds;
        }

        public void InitializeBounds(int chunkSize, int chunkGridResolution)
        {
            int width = chunkSize * chunkGridResolution;

            meshBounds = new Bounds(Vector3.zero, new Vector3(width, meshBounds.size.y, width));
            meshBoundsHDRP = meshBounds;
        }

        private void InitializeRenderParams()
        {
            wireframeRenderParams = new RenderParams(ocean.WireframeM);
            wireframeRenderParams.shadowCastingMode = ShadowCastingMode.Off;
            wireframeRenderParams.receiveShadows = false;
            wireframeRenderParams.worldBounds = MAX_BOUNDS;
        }

        private void InitializeSubChunkBuffer()
        {
            int count = GetSubChunkCount();

            if (subChunkBuffer == null)
            {
                Create();
            }
            else if (!subChunkBuffer.IsValid() || subChunkBuffer.count != count || subChunkBuffer.stride != SubChunk.SizeOf())
            {
                subChunkBuffer.Release();
                Create();
            }

            void Create()
            {
                subChunkBuffer = new ComputeBuffer(count, SubChunk.SizeOf(), ComputeBufferType.Raw);
                subChunkBuffer.name = "Sub Chunk Buffer";
            }
        }

        private int GetSubChunkCount()
        {
            if (chunkGridResolution < 1)
            {
                throw new System.Exception("Chunk Grid Resolution must be greater than 0");
            }

            int count = 0;

            for (int chunkCoordX = 0; chunkCoordX < chunkGridResolution; chunkCoordX++)
            {
                for (int chunkCoordY = 0; chunkCoordY < chunkGridResolution; chunkCoordY++)
                {
                    Vector2Int chunkCoord = new Vector2Int(chunkCoordX, chunkCoordY);
                    int chunkTessellation = GetChunkTessellation(chunkCoord);
                    int subChunkGridResolution = GetSubChunkGridResolution(chunkTessellation);

                    count += subChunkGridResolution * subChunkGridResolution;
                }
            }

            return count;
        }

        private void InitializeVertexBuffer()
        {
            int count = GetVertexBufferCount();

            if (vertexBuffer == null)
            {
                Create();
            }
            else if (!vertexBuffer.IsValid() || vertexBuffer.count != count || vertexBuffer.stride != Triangle_Vertex.SizeOf())
            {
                vertexBuffer.Release();
                Create();
            }

            void Create()
            {
                vertexBuffer = new ComputeBuffer(count, Triangle_Vertex.SizeOf(), ComputeBufferType.Raw);
                vertexBuffer.name = "Vertex Buffer";
            }
        }

        /// <summary>
        /// 0-3: forward / depth draw args : reset 0                <br/>
        /// 4-7: screen mask draw args : reset 4                    <br/>
        /// 8-10: triangle fill dispatch args : reset 10            <br/>
        /// 11-13: displace vertex dispatch args : reset 11         <br/>
        /// 14: byte offset to read edge chunks in triangle buffer  <br/>
        /// </summary>
        private void InitializeIndirectArgsBuffer()
        {
            if (indirectArgsBuffer == null)
            {
                Create();
            }
            else if(!indirectArgsBuffer.IsValid() || indirectArgsBuffer.stride != sizeof(uint) * INDIRECT_ARGS_LENGTH)
            {
                indirectArgsBuffer.Release();
                Create();
            }

            void Create()
            {
                indirectArgsBuffer = new GraphicsBuffer(GraphicsBuffer.Target.IndirectArguments, 1, sizeof(uint) * INDIRECT_ARGS_LENGTH);
                uint[] args = new uint[INDIRECT_ARGS_LENGTH] {
                    0, 1, 0, 0, // water surface rendering
                    0, 1, 0, 0, // underwater mask pyramid
                    1, 1, 0,    // triangle fill dispatch args
                    0, 1, 1,    // displace vertex dispatch args
                    0           // byte offset to read edge chunks in triangle buffer
                };
                indirectArgsBuffer.SetData(args);
            }
        }

        /// <summary>
        /// Get the max number of vertices in the vertex buffer. Triangles do not share vertices,
        /// so one triangle always adds 3 new vertices.
        /// </summary>
        /// <returns></returns>
        private int GetVertexBufferCount()
        {
            MeshChunkArray meshChunkArray = new MeshChunkArray(false);

            int count = 0;

            for (int chunkCoordX = 0; chunkCoordX < chunkGridResolution; chunkCoordX++)
            {
                for (int chunkCoordY = 0; chunkCoordY < chunkGridResolution; chunkCoordY++)
                {
                    Vector2Int chunkCoord = new Vector2Int(chunkCoordX, chunkCoordY);
                    int chunkTessellation = GetChunkTessellation(chunkCoord);
                    int chunkType = GetChunkType(chunkCoord, chunkTessellation);

                    count += GetChunkTriCount(chunkType, chunkTessellation, meshChunkArray);
                }
            }

            return count * 3 + 12;
        }

        private int GetChunkTriCount(int chunkType, int chunkTessellation, MeshChunkArray meshChunkArray)
        {
            int count = 0;

            int subChunkGridResolution = GetSubChunkGridResolution(chunkTessellation);

            for (int subChunkCoordX = 0; subChunkCoordX < subChunkGridResolution; subChunkCoordX++)
            {
                for (int subChunkCoordY = 0; subChunkCoordY < subChunkGridResolution; subChunkCoordY++)
                {
                    Vector2Int subChunkCoord = new Vector2Int(subChunkCoordX, subChunkCoordY);
                    int subChunkType = GetSubChunkType(subChunkCoord, chunkType, subChunkGridResolution);
                    int subChunkTessellation = Mathf.Min(chunkTessellation, 3);

                    count += GetSubChunkTriCount(subChunkType, subChunkTessellation, meshChunkArray);
                }
            }

            return count;
        }

        private int GetSubChunkTriCount(int subChunkType, int subChunkTessellation, MeshChunkArray meshChunkArray)
        {
            int count = 0;

            int meshPatchGridResolution = 1 << subChunkTessellation;

            for (int meshPatchCoordX = 0; meshPatchCoordX < meshPatchGridResolution; meshPatchCoordX++)
            {
                for (int meshPatchCoordY = 0; meshPatchCoordY < meshPatchGridResolution; meshPatchCoordY++)
                {
                    Vector2Int meshPatchCoord = new Vector2Int(meshPatchCoordX, meshPatchCoordY);
                    int meshPatchType = GetMeshPatchType(meshPatchCoord, subChunkType, meshPatchGridResolution);

                    count += GetMeshPatchTriCount(meshPatchType, meshChunkArray);
                }
            }
            
            return count;
        }

        private int GetMeshPatchTriCount(int meshPatchType, MeshChunkArray meshChunkArray)
        {
            return (int)meshChunkArray[meshPatchType].triangleCount;
        }

        private int GetMeshPatchVertexCount(int meshPatchType, MeshChunkArray meshChunkArray)
        {
            return (int)meshChunkArray[meshPatchType].vertexCount;
        }

        private int GetChunkTessellation(Vector2Int id)
        {
            float center = (chunkGridResolution - 1) / 2f;

            float tessellation = Vector2.Distance((Vector2)id, new Vector2(center, center));
            tessellation = Mathf.Pow(tessellation, tessellationFalloff);
            tessellation += tessellationOffset;

            return Mathf.Max(maxTessellation - (int)tessellation, 0);
        }

        private int GetChunkType(Vector2Int id, int chunkTessellation)
        {
            int maxIndex = chunkGridResolution - 1;

            Vector2Int iL = new Vector2Int(id.x - (id.x > 0 ? 1 : 0), id.y);
            Vector2Int iR = new Vector2Int(id.x + (id.x < maxIndex ? 1 : 0), id.y);
            Vector2Int iD = new Vector2Int(id.x, id.y - (id.y > 0 ? 1 : 0));
            Vector2Int iU = new Vector2Int(id.x, id.y + (id.y < maxIndex ? 1 : 0));

            int L = GetChunkTessellation(iL);
            int R = GetChunkTessellation(iR);
            int D = GetChunkTessellation(iD);
            int U = GetChunkTessellation(iU);

            L = chunkTessellation < L ? 1 : 0;
            R = chunkTessellation < R ? 2 : 0;
            D = chunkTessellation < D ? 4 : 0;
            U = chunkTessellation < U ? 8 : 0;

            int chunkType = L | R | D | U;

            return chunkType;
        }

        private int GetSubChunkType(Vector2Int id, int chunkType, int subChunkGridResolution)
        {
            int maxIndex = subChunkGridResolution - 1;

            // if id.x == 0 , left edge
            // if id.y == 0 , down edge
            // if id.x == maxIndex , right edge
            // if id.y == maxIndex , top edge

            int eL = (id.x == 0 ? 1 : 0);        // 1 0001
            int eR = (id.x == maxIndex ? 2 : 0); // 2 0010
            int eD = (id.y == 0 ? 4 : 0);        // 4 0100
            int eU = (id.y == maxIndex ? 8 : 0); // 8 1000

            int subChunkType = eL | eR | eD | eU;

            subChunkType &= chunkType;

            // ----------------------
            // Bit Masks / Chunk Type
            // ----------------------
            // 
            //              UDRL
            //
            // Default  0   0000
            // W        1   0001
            // E        2   0010
            // -        3
            // S        4   0100
            // SW       5   0101
            // SE       6   0110
            // -        7   
            // N        8   1000
            // NW       9   1001
            // NE       10  1010

            return subChunkType;
        }

        // max tess above 6 not supported atm // TODO : support higher levels ?
        private int GetSubChunkGridResolution(int chunkTessellation)
        {
            return 1 << Mathf.Max(chunkTessellation - 3, 0);
        }

        private int GetMeshPatchType(Vector2Int id, int subChunkType, int meshPatchGridResolution)
        {
            return GetSubChunkType(id, subChunkType, meshPatchGridResolution);
        }

        private MeshChunk RotateMeshChunk(MeshChunk meshChunk, float theta)
        {
            for (int i = 0; i < meshChunk.vertexCount; i++)
            {
                meshChunk.vertices[i] = RotateVertex(meshChunk.vertices[i], theta);
            }

            return meshChunk;
        }

        private Vector3 RotateVertex(Vector3 vertex, float theta)
        {
            float c = Mathf.Cos(theta);
            float s = Mathf.Sin(theta);

            float x = vertex.x * c - vertex.z * s;
            float z = vertex.x * s + vertex.z * c;

            return new Vector3(x, vertex.y, z);
        }

        /// <summary>
        /// Max distance away from the camera where a vertex of the near water mesh should be displaced,
        /// so that it seamlessly matches the distant water plane.
        /// Distance to a vertex in shader divided by this value is used to create a falloff.
        /// </summary>
        /// <param name="chunkGridResolution"></param>
        /// <param name="chunkSize"></param>
        /// <returns>
        /// Max distance from camera at which a vertex can be displaced
        /// </returns>
        private float CalculateDisplacementMaxDistance(int chunkGridResolution, int chunkSize)
        {
            return (float)chunkGridResolution * (float)chunkSize * 0.5f - (float)chunkSize * 0.5f;
        }
    }
}