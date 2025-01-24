#ifndef GOCEAN_TERRAIN_HEIGHTMAP_SAMPLING
#define GOCEAN_TERRAIN_HEIGHTMAP_SAMPLING

// could generate this from script in seperate file if decide to 
// support terrain array length not equal to 9

#define TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION 3
#define TERRAIN_HEIGHTMAP_ARRAY_SLICES 9

struct TerrainSamplingData
{
    int slice;
    float2 uv;
    bool valid;
};

const static uint slice1DLookupArray[3][3] =
{
    0, 3, 6,
    1, 4, 7,
    2, 5, 8
};

const static uint2 slice2DLookupArray[9] =
{
    uint2(0, 0),
    uint2(1, 0),
    uint2(2, 0),
    uint2(0, 1),
    uint2(1, 1),
    uint2(2, 1),
    uint2(0, 2),
    uint2(1, 2),
    uint2(2, 2)
};

// L, R, D, U
// 9 if no adajcent slice
const static uint4 adjacentSliceLookupArray[9] =
{
    uint4(9, 1, 9, 3),
    uint4(0, 2, 9, 4),
    uint4(1, 9, 9, 5),
    uint4(9, 4, 0, 6),
    uint4(3, 5, 1, 7),
    uint4(4, 9, 2, 8),
    uint4(9, 7, 3, 9),
    uint4(6, 8, 4, 9),
    uint4(7, 9, 5, 9)
};

// L, R, D, U
// bit to test against validTerrainHeightmapMask for adjacent slices
//
// ex:  using slice 0 -> adjacentSliceMask[0] = uint4(0, 2, 0, 8)
//      testing right slice -> ( adjacentSliceMask[0].y & validTerrainHeightmapMask ) > 0
const static uint4 adjacentSliceMask[9] =
{
    uint4(0, 2, 0, 8),
    uint4(1, 4, 0, 16),
    uint4(2, 0, 0, 32),
    uint4(0, 16, 1, 64),
    uint4(8, 32, 2, 128),
    uint4(16, 0, 2, 256),
    uint4(0, 128, 8, 0),
    uint4(64, 256, 16, 0),
    uint4(128, 0, 32, 0)
};

bool InvalidAdjacentSlice(int index, int slice, int validTerrainHeightmapMask)
{
    return (adjacentSliceMask[index][slice] & validTerrainHeightmapMask) < 1;
}

bool4 InvalidAdjacentSlices(int index, int validTerrainHeightmapMask)
{
    bool x = InvalidAdjacentSlice(index, 0, validTerrainHeightmapMask);
    bool y = InvalidAdjacentSlice(index, 1, validTerrainHeightmapMask);
    bool z = InvalidAdjacentSlice(index, 2, validTerrainHeightmapMask);
    bool w = InvalidAdjacentSlice(index, 3, validTerrainHeightmapMask);
    
    return bool4(x, y, z, w);
}

int GetTerrainSlice1DIndex(int2 index, int res)
{
    return index.x + index.y * res;
}

int GetTerrainLookup1DIndex(int2 index, int res)
{
    return index.x + index.y * res;
}

uint2 GetTerrainSlice2DIndex(uint index, uint res)
{
    return uint2(index % res, index / res);
}

uint2 GetTerrainLookup2DIndex(uint index, uint res)
{
    return uint2(index % res, index / res);
}

bool InvalidTerrainPosScaled(float2 position, float4 terrainPosScaledBounds)
{
    return
        position.x < terrainPosScaledBounds.x ||
        position.y < terrainPosScaledBounds.z ||
        position.x >= terrainPosScaledBounds.y ||
        position.y >= terrainPosScaledBounds.w;
}

bool InvalidTerrainCoord(int2 coord, int resolution)
{
    return
        coord.x < 0 ||
        coord.y < 0 ||
        coord.x >= resolution ||
        coord.y >= resolution;
}

bool InvalidTerrainSlice2D(int2 slice)
{
    return
        slice.x < 0 ||
        slice.y < 0 ||
        slice.x >= TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION ||
        slice.y >= TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION;
}

bool InvalidTerrainHeightmapArraySliceIndex(int index, int validTerrainHeightmapMask)
{
    // bit at index position is 0
    return ((1 << index) & validTerrainHeightmapMask) < 1;
}

bool InvalidSamplingPosition(int2 coord, int2 slice2D, int slice, int validTerrainHeightmapMask, int terrainLookupResolution)
{
    return (InvalidTerrainCoord(coord, terrainLookupResolution) || InvalidTerrainSlice2D(slice2D) || InvalidTerrainHeightmapArraySliceIndex(slice, validTerrainHeightmapMask));
}

float2 GetTerrainPositionScaled(float2 position, float3 terrainSize)
{
    return float2(position.x / terrainSize.x, position.y / terrainSize.z);
}

float2 GetTerrainPositionScaled(float3 position, float3 terrainSize)
{
    return GetTerrainPositionScaled(position.xz, terrainSize);
}

int2 GetTerrainLookupCoord(float2 position, float3 terrainSize, float4 terrainPosScaledBounds, int2 terrainLookupCoordOffset)
{
    float2 p = GetTerrainPositionScaled(position, terrainSize);
    p -= terrainPosScaledBounds.xz;
    return (int2) p - terrainLookupCoordOffset;
}

int2 GetTerrainLookupCoord(float3 position, float3 terrainSize, float4 terrainPosScaledBounds, int2 terrainLookupCoordOffset)
{
    return GetTerrainLookupCoord(position.xz, terrainSize, terrainPosScaledBounds, terrainLookupCoordOffset);
}

void GetTerrainSamplingData(
    float2 position, float3 terrainSize, float4 terrainPosScaledBounds, float2 offset, float uvMultiplier,
    int2 terrainLookupCoordOffset, int terrainLookupResolution, int validTerrainHeightmapMask,
    out int slice, out float2 uv, out bool valid)
{
    uv = GetTerrainPositionScaled(position, terrainSize);
    uv -= terrainPosScaledBounds.xz;
    uv += offset;
    
    int2 coord = ((int2) floor(uv));
    int2 slice2D = coord - terrainLookupCoordOffset;
    slice = GetTerrainSlice1DIndex(slice2D, TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION);

    valid = !InvalidSamplingPosition(coord, slice2D, slice, validTerrainHeightmapMask, terrainLookupResolution);
    slice = valid ? slice : 0;
    uv = frac(uv);
    uv *= uvMultiplier;
    uv += (1.0 - uvMultiplier) * 0.5;
}

void GetTerrainSamplingData(
    float3 position, float3 terrainSize, float4 terrainPosScaledBounds, float2 offset, float uvMultiplier,
    int2 terrainLookupCoordOffset, int terrainLookupResolution, int validTerrainHeightmapMask,
    out uint slice, out float2 uv, out bool valid)
{
    GetTerrainSamplingData(
    position.xz, terrainSize, terrainPosScaledBounds, offset, uvMultiplier,
    terrainLookupCoordOffset, terrainLookupResolution, validTerrainHeightmapMask,
    slice, uv, valid);
}

TerrainSamplingData GetTerrainSamplingData(
    float2 position, float3 terrainSize, float4 terrainPosScaledBounds, float2 offset, float uvMultiplier,
    int2 terrainLookupCoordOffset, int terrainLookupResolution, int validTerrainHeightmapMask)
{
    TerrainSamplingData data;
    
    GetTerrainSamplingData(
    position, terrainSize, terrainPosScaledBounds, offset, uvMultiplier,
    terrainLookupCoordOffset, terrainLookupResolution, validTerrainHeightmapMask,
    data.slice, data.uv, data.valid);
    
    return data;
}

// ======================================== SHADER GRAPH METHODS ======================================== //

void GetTerrainLookupCoord_float(float3 position, float3 terrainSize, float4 terrainPosScaledBounds, int2 terrainLookupCoordOffset, out int2 coord)
{
    coord = GetTerrainLookupCoord(position, terrainSize, terrainPosScaledBounds, terrainLookupCoordOffset);
}

void GetTerrainSamplingData_float(
    float3 position, float3 terrainSize, float4 terrainPosScaledBounds, float2 offset, float uvMultiplier,
    int2 terrainLookupCoordOffset, int terrainLookupResolution, int validTerrainHeightmapMask,
    out int slice, out float2 uv, out bool valid)
{
    GetTerrainSamplingData(
    position, terrainSize, terrainPosScaledBounds, offset, uvMultiplier,
    terrainLookupCoordOffset, terrainLookupResolution, validTerrainHeightmapMask,
    slice, uv, valid);
}

void GetTerrainSamplingData_float(
    float2 position, float3 terrainSize, float4 terrainPosScaledBounds, float2 offset, float uvMultiplier,
    int2 terrainLookupCoordOffset, int terrainLookupResolution, int validTerrainHeightmapMask,
    out int slice, out float2 uv, out bool valid)
{
    GetTerrainSamplingData(
    position, terrainSize, terrainPosScaledBounds, offset, uvMultiplier,
    terrainLookupCoordOffset, terrainLookupResolution, validTerrainHeightmapMask,
    slice, uv, valid);
}

#endif // GOCEAN_TERRAIN_HEIGHTMAP_SAMPLING