#ifndef GOCEAN_MESH_DATA
#define GOCEAN_MESH_DATA

#define VERTEX_SIZE_BYTE 20
#define VERTEX_PREDISPLACED_POSITION_XZ_SIZE_BYTE 8
#define VERTEX_DISPLACED_POSITION_SIZE_BYTE 12
#define TRIANGLE_SIZE_BYTE 60

#define SUBCHUNK_SIZE_BYTE 12

#define MESH_CHUNK_SIZE_BYTE 104
#define MESH_CHUNK_SIZE 26
#define MESH_CHUNK_COUNT 11
#define MESH_CHUNK_MAX_VERTICES 6
#define MESH_CHUNK_MAX_INDICES 12
#define MESH_CHUNK_MAX_TRIANGLES 4

// R/W locations in indirect args buffer, offset in bytes
#define VERT_COUNT_RW_LOCATION 0
#define TOTAL_VERT_COUNT_RW_LOCATION 16
#define SUB_CHUNK_COUNT_RW_LOCATION 40
#define DISPLACE_VERTICES_THREAD_GROUP_SIZE_RW_LOCATION 44
#define EDGE_CHUNK_START_READ_POSITION_RW_LOCATION 56

#define UNDERWATER_MASK_VERTEX_COUNT 12

struct Vertex
{
    float2 preDisplacedPositionXZ;
    float3 position;
};

struct Triangle
{
    Vertex vertices[3];
};

struct MeshChunk
{
    uint triangleCount;
    uint vertexCount;
    float2 vertices[MESH_CHUNK_MAX_VERTICES];
    uint indices[MESH_CHUNK_MAX_INDICES];
};

struct Chunk
{
    uint type;
    uint tessellation;
    float2 position;
};

struct SubChunk
{
    uint data; // rightmost 4 bits: tessellation // next 4 bits: type // next ~8 bits: scale factor (_ChunkSize is divided by this value)
    float2 position;
};

// TODO : generate from script?
const static MeshChunk meshChunkArray[MESH_CHUNK_COUNT] =
{
    2, 4, -1, -1, 1, -1, -1, 1, 1, 1, -1, 0, 0, -1, 2, 1, 0, 2, 3, 1, 0, 0, 0, 0, 0, 0,
    3, 5, -1, -1, 1, -1, -1, 1, 1, 1, -1, 0, 0, -1, 4, 1, 0, 2, 3, 4, 4, 3, 1, 0, 0, 0,
    3, 5, 1, 1, -1, 1, 1, -1, -1, -1, 1, 0, 0, -1, 4, 1, 0, 2, 3, 4, 4, 3, 1, 0, 0, 0,
    2, 4, -1, -1, 1, -1, -1, 1, 1, 1, -1, 0, 0, -1, 2, 1, 0, 2, 3, 1, 0, 0, 0, 0, 0, 0,
    3, 5, 1, -1, 1, 1, -1, -1, -1, 1, 0, -1, 0, -1, 4, 1, 0, 2, 3, 4, 4, 3, 1, 0, 0, 0,
    4, 6, -1, -1, 1, -1, -1, 1, 1, 1, -1, 0, 0, -1, 4, 5, 0, 3, 1, 5, 4, 3, 5, 2, 3, 4,
    4, 6, 1, -1, 1, 1, -1, -1, -1, 1, 0, -1, 1, 0, 4, 5, 0, 3, 1, 5, 4, 3, 5, 2, 3, 4,
    2, 4, -1, -1, 1, -1, -1, 1, 1, 1, -1, 0, 0, -1, 2, 1, 0, 2, 3, 1, 0, 0, 0, 0, 0, 0,
    3, 5, -1, 1, -1, -1, 1, 1, 1, -1, 0, 1, 0, -1, 4, 1, 0, 2, 3, 4, 4, 3, 1, 0, 0, 0,
    4, 6, -1, 1, -1, -1, 1, 1, 1, -1, 0, 1, -1, 0, 4, 5, 0, 3, 1, 5, 4, 3, 5, 2, 3, 4,
    4, 6, 1, 1, -1, 1, 1, -1, -1, -1, 1, 0, 0, 1, 4, 5, 0, 3, 1, 5, 4, 3, 5, 2, 3, 4
};

#endif // GOCEAN_MESH_DATA