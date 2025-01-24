using UnityEngine;

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;
    using static Helper;

    public static class MeshChunks
    {
        public const int MESH_CHUNK_BUFFER_SIZE = 11;

        public readonly struct MeshChunkArray
        {
            private readonly MeshChunk[] meshChunks;

            public MeshChunkArray(bool needsVertexPositions = true)
            {
                meshChunks = new MeshChunk[MESH_CHUNK_BUFFER_SIZE];

                // float2 vertex positions // n: negative 1, p: positive 1, z: zero
                Vector2 nn = new Vector2(-1f, -1f);
                Vector2 pn = new Vector2(1f, -1f);
                Vector2 np = new Vector2(-1f, 1f);
                Vector2 pp = new Vector2(1f, 1f);
                Vector2 nz = new Vector2(-1f, 0f);
                Vector2 zn = new Vector2(0f, -1f);

                Vector2[] vertices = new Vector2[MeshChunk.MAX_VERTICES] { nn, pn, np, pp, nz, zn };
                uint[] indices;

                indices = new uint[MeshChunk.MAX_INDICES] { 2, 1, 0, 2, 3, 1, 0, 0, 0, 0, 0, 0 };
                MeshChunk chunkDefault = new MeshChunk(2, 4, vertices, indices);

                indices = new uint[MeshChunk.MAX_INDICES] { 4, 1, 0, 2, 3, 4, 4, 3, 1, 0, 0, 0 };
                MeshChunk chunkEdge = new MeshChunk(3, 5, vertices, indices);

                indices = new uint[MeshChunk.MAX_INDICES] { 4, 5, 0, 3, 1, 5, 4, 3, 5, 2, 3, 4 };
                MeshChunk chunkCorner = new MeshChunk(4, 6, vertices, indices);

                if (needsVertexPositions)
                {
                    meshChunks[0] = chunkDefault;               // Default  0   0000
                    meshChunks[1] = chunkEdge;                  // W        1   0001
                    meshChunks[2] = chunkEdge.Clone();          // E        2   0010
                    meshChunks[2].RotateMeshChunk180Degrees();
                    meshChunks[3] = chunkDefault;               // -        3
                    meshChunks[4] = chunkEdge.Clone();          // S        4   0100
                    meshChunks[4].RotateMeshChunk90DegreesCC();
                    meshChunks[5] = chunkCorner;                // SW       5   0101
                    meshChunks[6] = chunkCorner.Clone();        // SE       6   0110
                    meshChunks[6].RotateMeshChunk90DegreesCC();
                    meshChunks[7] = chunkDefault;               // -        7   
                    meshChunks[8] = chunkEdge.Clone();          // N        8   1000
                    meshChunks[8].RotateMeshChunk90DegreesCW();
                    meshChunks[9] = chunkCorner.Clone();        // NW       9   1001
                    meshChunks[9].RotateMeshChunk90DegreesCW();
                    meshChunks[10] = chunkCorner.Clone();       // NE       10  1010
                    meshChunks[10].RotateMeshChunk180Degrees();
                }
                else
                {
                    meshChunks[0] = chunkDefault;               // Default  0   0000
                    meshChunks[1] = chunkEdge;                  // W        1   0001
                    meshChunks[2] = chunkEdge;                  // E        2   0010
                    meshChunks[3] = chunkDefault;               // -        3
                    meshChunks[4] = chunkEdge;                  // S        4   0100
                    meshChunks[5] = chunkCorner;                // SW       5   0101
                    meshChunks[6] = chunkCorner;                // SE       6   0110
                    meshChunks[7] = chunkDefault;               // -        7   
                    meshChunks[8] = chunkEdge;                  // N        8   1000
                    meshChunks[9] = chunkCorner;                // NW       9   1001
                    meshChunks[10] = chunkCorner;               // NE       10  1010
                }
            }

            public MeshChunk this[int index]
            {
                get
                {
                    return meshChunks[index];
                }
            }

            public override string ToString()
            {
                string s = "";
                
                for (int i = 0; i < meshChunks.Length; i++)
                {
                    s += meshChunks[i].ToString();

                    if (i < meshChunks.Length - 1)
                    {
                        s += ",\n";
                    }
                }

                return s;
            }
        }

        public readonly struct MeshChunk
        {
            public const int MAX_VERTICES = 6;
            public const int MAX_INDICES = 12;

            public readonly uint triangleCount;
            public readonly uint vertexCount;
            public readonly Vector2[] vertices; // 6
            public readonly uint[] indices; // 12

            public MeshChunk(uint triangleCount, uint vertexCount, Vector2[] vertices, uint[] indices)
            {
                this.triangleCount = triangleCount;
                this.vertexCount = vertexCount;
                this.vertices = vertices;
                this.indices = indices;
            }

            public static int SizeOf()
            {
                return sizeof(float) * 2 * MAX_VERTICES + sizeof(int) * (MAX_INDICES + 2);
            }

            public override string ToString()
            {
                string s = "";

                s += triangleCount + ", " + vertexCount + ", ";

                for (int i = 0; i < vertices.Length; i++)
                {
                    s += vertices[i].x + ", " + vertices[i].y + ", ";
                }

                for (int i = 0; i < indices.Length; i++)
                {
                    s += indices[i];

                    if (i < indices.Length - 1)
                    {
                        s += ", ";
                    }
                }

                return s;
            }

            public MeshChunk Clone()
            {
                Vector2[] v = (Vector2[])vertices.Clone();
                uint[] i = (uint[])indices.Clone();

                return new MeshChunk(triangleCount, vertexCount, v, i);
            }

            public void RotateMeshChunk(float theta)
            {
                for (uint i = 0; i < vertexCount; i++)
                {
                    vertices[i] = RotateVector2(vertices[i], theta);
                }
            }

            public void RotateMeshChunk180Degrees()
            {
                for (uint i = 0; i < vertexCount; i++)
                {
                    vertices[i] = Rotate180Degrees(vertices[i]);
                }
            }

            public void RotateMeshChunk90DegreesCC()
            {
                for (uint i = 0; i < vertexCount; i++)
                {
                    vertices[i] = Rotate90DegreesCC(vertices[i]);
                }
            }

            public void RotateMeshChunk90DegreesCW()
            {
                for (uint i = 0; i < vertexCount; i++)
                {
                    vertices[i] = Rotate90DegreesCW(vertices[i]);
                }
            }
        }
    }
}