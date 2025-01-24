using UnityEngine;
using UnityEngine.Rendering.HighDefinition;

namespace GOcean
{
    using static Helper;
    using PropIDs = ShaderPropertyIDs;

    public class Terrain : Component
    {
        [ShaderParam("_TerrainHeightmapArrayResolution")]
        public const int TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION = 3;
        public const int TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION = TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION >> 1;
        [ShaderParam("_TerrainHeightmapArraySlices")]
        public const int TERRAIN_HEIGHTMAP_ARRAY_SLICES = 9;
        public const int MAX_SHORE_WAVE_COUNT = 7; // 7 * 9 = 63, fits into CS group nicely

        public bool useTerrainInfluence;
        [ShaderParam("_HeightmapOffset")]
        public float heightmapOffset;
        [ShaderParam("_WaveDisplacementFade")]
        public float waveDisplacementFade;
        [ShaderParam("_ShoreWaveCount")]
        public int shoreWaveCount;
        [ShaderParam("_ShoreWaveStartDepth")]
        public float shoreWaveStartDepth;
        [ShaderParam("_ShoreWaveFalloff")]
        public float shoreWaveFalloff;
        [ShaderParam("_ShoreWaveHeight")]
        public float shoreWaveHeight;
        [ShaderParam("_ShoreWaveSpeed")]
        public float shoreWaveSpeed;
        [ShaderParam("_ShoreWaveNoiseStrength")]
        public float shoreWaveNoiseStrength;
        [ShaderParam("_ShoreWaveNoiseScale")]
        public float shoreWaveNoiseScale;
        [ShaderParam("_ShoreWaveNormalStrength")]
        public float shoreWaveNormalStrength;
        [ShaderParam("_DirectionalInfluenceMultiplier")]
        public float directionalInfluenceMultiplier;

        [ShaderParam("_TerrainSize")]
        public Vector3 terrainSize;
        [ShaderParam("_ValidTerrainHeightmapMask")]
        public int validTerrainHeightmapMask;
        [ShaderParam("_TerrainPosScaledBounds")]
        public Vector4Int terrainPosScaledBounds;
        [ShaderParam("_TerrainHeightmapResolution")]
        public int terrainHeightmapResolution;
        [ShaderParam("_TerrainLookupResolution")]
        public int terrainLookupResolution;
        [ShaderParam("_TerrainLookupCoordOffset")]
        public Vector2Int terrainLookupCoordOffset;
        [ShaderParam("_UVMultiplier")]
        public float uvMultiplier;

        [ShaderParam("_TerrainHeightmapArrayTexture")]
        public RenderTexture terrainHeightmapArrayTexture;
        [ShaderParam("_TerrainShoreWaveArrayTexture")]
        public RenderTexture terrainShoreWaveArrayTexture;
        [ShaderParam("_TargetSliceIndicesBuffer")]
        private ComputeBuffer targetSliceIndicesBuffer;
        [ShaderParam("_DirectionalInfluenceBuffer")]
        private ComputeBuffer directionalInfluenceBuffer;

        public Vector2 directionalInfluence;

        private KernelIDs kernelIDs;
        private ThreadGroupSizes threadGroupSizes;
        private ThreadGroups threadGroups;
        private int[,] terrainLookupArray;
        private UnityEngine.Terrain[] terrainArray;
        private int[] targetSliceIndices;
        private Vector2Int previousTerrainCoord = new Vector2Int(int.MaxValue, int.MaxValue), terrainCoordDelta = Vector2Int.zero;
        private bool needsComputeDispatch = true, needsDirectionalInfluenceCopy = false, hasTerrain = false;

        public struct KernelIDs
        {
            public int InitialFill { get; private set; }
            public int CopyDirectionalInfluence { get; private set; }
            public int DirectionalInfluence { get; private set; }
            public int ComputeShoreWaves { get; private set; }
            public int UpdateTexturesCopyFoam { get; private set; }
            public int UpdateTexturesResetFoam { get; private set; }

            public KernelIDs(ComputeShader cs)
            {
                InitialFill = cs.FindKernel("InitialFill");
                CopyDirectionalInfluence = cs.FindKernel("CopyDirectionalInfluence");
                DirectionalInfluence = cs.FindKernel("DirectionalInfluence");
                ComputeShoreWaves = cs.FindKernel("ComputeShoreWaves");
                UpdateTexturesCopyFoam = cs.FindKernel("UpdateTexturesCopyFoam");
                UpdateTexturesResetFoam = cs.FindKernel("UpdateTexturesResetFoam");
            }
        }

        public struct ThreadGroupSizes
        {
            public Vector3Int Main { get; private set; }
            public Vector3Int DirectionalInfluence { get; private set; }

            public ThreadGroupSizes(ComputeShader cs, KernelIDs ids)
            {
                cs.GetKernelThreadGroupSizes(ids.ComputeShoreWaves, out uint x, out uint y, out uint z);
                Main = new Vector3Int((int)x, (int)y, (int)z);

                cs.GetKernelThreadGroupSizes(ids.DirectionalInfluence, out x, out y, out z);
                DirectionalInfluence = new Vector3Int((int)x, (int)y, (int)z);
            }
        }

        public struct ThreadGroups
        {
            public Vector3Int main;
            public Vector3Int directionalInfluence;

            public ThreadGroups(ThreadGroupSizes tgs, int terrainHeightmapResolution)
            {
                main = new Vector3Int(Mathf.CeilToInt(terrainHeightmapResolution / (float)tgs.Main.x), Mathf.CeilToInt(terrainHeightmapResolution / (float)tgs.Main.y), 1);
                directionalInfluence = new Vector3Int(1, 1, 1);
            }

            public void UpdateDirectionalInfluence(ThreadGroupSizes tgs, int sliceUpdateCount, int shoreWaveCount)
            {
                directionalInfluence.x = Mathf.CeilToInt(sliceUpdateCount * shoreWaveCount / (float)tgs.DirectionalInfluence.x);
            }
        }

        public Terrain()
        {
        }

        public override void Initialize()
        {
            InitializeParams(ocean.parametersUser.terrain);

            kernelIDs = new KernelIDs(ocean.TerrainCS);
            threadGroupSizes = new ThreadGroupSizes(ocean.TerrainCS, kernelIDs);

            MCSArrays.AddComputeShader(ocean.TerrainCS, kernelIDs.InitialFill, kernelIDs.CopyDirectionalInfluence, kernelIDs.DirectionalInfluence, kernelIDs.ComputeShoreWaves,
                kernelIDs.UpdateTexturesCopyFoam, kernelIDs.UpdateTexturesResetFoam);

            hasTerrain = InitializeTerrainArray() && useTerrainInfluence;

            SetKeyword(PropIDs.ShaderKeywords.HAS_TERRAIN_ON, hasTerrain, MCSArrays.Materials);
            SetKeyword(ocean.MeshCS, PropIDs.ShaderKeywords.HAS_TERRAIN_ON, hasTerrain);

            if (!hasTerrain)
            {
                ReleaseResources();
                return;
            }

            terrainSize = CalculateTerrainSize(terrainArray[0]);
            terrainHeightmapResolution = terrainArray[0].terrainData.heightmapResolution;
            terrainLookupResolution = CalculateLookupResolution(terrainArray, out terrainPosScaledBounds);
            uvMultiplier = CalculateUVMultiplier(terrainHeightmapResolution);
            directionalInfluence = CalculateDirectionalInfluence(ocean.WindDirection, directionalInfluenceMultiplier);

            threadGroups = new ThreadGroups(threadGroupSizes, terrainHeightmapResolution);

            InitializeTerrainLookupArray();
            InitializeTextures();
            InitializeTargetSliceIndicesBuffer();
            InitializeDirectionalInfluenceBuffer(threadGroupSizes);

            FirstUpdateTerrainTextureArray();
        }

        public override void ReleaseResources()
        {
            ReleaseTexture(ref terrainHeightmapArrayTexture);
            ReleaseTexture(ref terrainShoreWaveArrayTexture);
            ReleaseBuffer(ref targetSliceIndicesBuffer);
            ReleaseBuffer(ref directionalInfluenceBuffer);
        }

        public override void InitializeParams(BaseParamsUser userParams)
        {
            TerrainParamsUser u = userParams as TerrainParamsUser;

            useTerrainInfluence = u.useTerrainInfluence;
            heightmapOffset = u.heightmapOffset;
            waveDisplacementFade = u.waveDisplacementFade;
            shoreWaveCount = u.shoreWaveCount;
            shoreWaveStartDepth = u.shoreWaveStartDepth;
            shoreWaveFalloff = u.shoreWaveFalloff;
            shoreWaveHeight = u.shoreWaveHeight;
            shoreWaveSpeed = u.shoreWaveSpeed;
            shoreWaveNoiseStrength = u.shoreWaveNoiseStrength;
            shoreWaveNoiseScale = CalculateShoreWaveNoiseScale(u.shoreWaveNoiseScale);
            shoreWaveNormalStrength = u.shoreWaveNormalStrength;
            directionalInfluenceMultiplier = u.directionalInfluenceMultiplier;
        }

        public override void SetShaderParams()
        {
            SetKeyword(PropIDs.ShaderKeywords.HAS_TERRAIN_ON, hasTerrain, MCSArrays.Materials);
            SetKeyword(ocean.MeshCS, PropIDs.ShaderKeywords.HAS_TERRAIN_ON, hasTerrain);

            base.SetShaderParams();
        }

        /// <summary>
        /// Actually do compute dispatches.
        /// </summary>
        /// <param name="ctx"></param>
        public void UpdateDirectionalInfluenceAndComputeTerrainTextureArray(CustomPassContext ctx)
        {
            if (!hasTerrain)
            {
                return;
            }

            if (needsComputeDispatch && threadGroups.main.z > 0)
            {
                if (needsDirectionalInfluenceCopy)
                {
                    threadGroups.UpdateDirectionalInfluence(threadGroupSizes, threadGroups.main.z, shoreWaveCount);
                    ctx.cmd.SetComputeIntParam(ocean.TerrainCS, PropIDs.sliceUpdateCount, threadGroups.main.z);
                    ctx.cmd.SetComputeIntParams(ocean.TerrainCS, PropIDs.slice2DOffsetDirection, terrainCoordDelta.x, terrainCoordDelta.y);
                    ctx.cmd.DispatchCompute(ocean.TerrainCS, kernelIDs.CopyDirectionalInfluence, threadGroups.directionalInfluence);

                    needsDirectionalInfluenceCopy = false;
                }

                ctx.cmd.DispatchCompute(ocean.TerrainCS, kernelIDs.DirectionalInfluence, threadGroups.directionalInfluence);
                ctx.cmd.DispatchCompute(ocean.TerrainCS, kernelIDs.ComputeShoreWaves, threadGroups.main);
            }
        }

        private void ComputeUpdatedTerrainData(CustomPassContext ctx, Vector2Int terrainCoord, Vector2Int previousTerrainCoord)
        {
            // terrains might not have GOceanTerrainComponent, so can still have 0 terrain heightmaps that need update
            needsComputeDispatch = false;

            // reset threadGroups.z to 0
            threadGroups.main.z = 0;

            // direction camera moved
            terrainCoordDelta = terrainCoord - previousTerrainCoord;

            // multiplier flips the x and y direction to iterate over the 3x3 terrain array, so that previous foam data can be transferred to the proper slice
            // if moving left (previousTerrainCoord.x > terrainCoord.x), value is -1
            // if moving right (previousTerrainCoord.x <= terrainCoord.x), value is 1
            // if moving down (previousTerrainCoord.y > terrainCoord.y), value is -1
            // if moving up (previousTerrainCoord.y <= terrainCoord.y), value is 1
            Vector2Int multiplier = Vector2Int.one;

            if (terrainCoordDelta.x < 0)
            {
                multiplier.x = -1;
            }

            if (terrainCoordDelta.y < 0)
            {
                multiplier.y = -1;
            }

            for (int y = -TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION; y <= TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION; y++)
            {
                for (int x = -TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION; x <= TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION; x++)
                {
                    int correctedX = x * multiplier.x;
                    int correctedY = y * multiplier.y;

                    Vector2Int coord = new Vector2Int(terrainCoord.x + correctedX, terrainCoord.y + correctedY);

                    if (InvalidTerrainCoord(coord))
                    {
                        continue;
                    }

                    int id = terrainLookupArray[coord.x, coord.y];

                    // if id is -1 then there is no terrain with a GOceanTerrainData component 
                    // at this coordinate in the square grid of terrains
                    if (id > -1)
                    {
                        int x_ = correctedX + TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION;
                        int y_ = correctedY + TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION;

                        int slice = x_ + y_ * TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION;
                        int sliceWorldSpace = GetTerrainLookup1D(coord);
                        validTerrainHeightmapMask |= 1 << slice;

                        targetSliceIndices[threadGroups.main.z] = slice;
                        targetSliceIndices[threadGroups.main.z + TERRAIN_HEIGHTMAP_ARRAY_SLICES] = sliceWorldSpace;
                        threadGroups.main.z++;

                        Vector2Int sourceSlice2D = new Vector2Int(x_ + terrainCoordDelta.x, y_ + terrainCoordDelta.y);

                        // if invalid source slice, copy terrain heightmap texture from terrain array and reset shore wave array texture slice to 0
                        if (InvalidTerrainSlice(sourceSlice2D))
                        {
                            ctx.cmd.SetComputeTextureParam(ocean.TerrainCS, kernelIDs.UpdateTexturesResetFoam, PropIDs.terrainHeightmapTexture, terrainArray[id].terrainData.heightmapTexture);
                            ctx.cmd.SetComputeIntParam(ocean.TerrainCS, PropIDs.slice, slice);
                            ctx.cmd.DispatchCompute(ocean.TerrainCS, kernelIDs.UpdateTexturesResetFoam, threadGroups.main.x, threadGroups.main.y, 1);
                        }

                        // if valid, copy shore wave source slice to new slice
                        else
                        {
                            int sourceSlice = sourceSlice2D.x + sourceSlice2D.y * TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION;
                            ctx.cmd.SetComputeTextureParam(ocean.TerrainCS, kernelIDs.UpdateTexturesCopyFoam, PropIDs.terrainHeightmapTexture, terrainArray[id].terrainData.heightmapTexture);
                            ctx.cmd.SetComputeIntParam(ocean.TerrainCS, PropIDs.slice, slice);
                            ctx.cmd.SetComputeIntParam(ocean.TerrainCS, PropIDs.sourceSlice, sourceSlice);
                            ctx.cmd.DispatchCompute(ocean.TerrainCS, kernelIDs.UpdateTexturesCopyFoam, threadGroups.main.x, threadGroups.main.y, 1);
                        }

                        needsComputeDispatch = true;
                    }
                }
            }

            ctx.cmd.SetBufferData(targetSliceIndicesBuffer, targetSliceIndices);
        }

        /// <summary>
        /// Compute and setup data needed to dispatch and update terrain shore wave texture. Do this before updating
        /// constant buffer, because this updates ValidTerrainHeightmapMask and TerrainLookupCoordOffset.
        /// </summary>
        /// <param name="ctx"></param>
        public void UpdateTerrainData(CustomPassContext ctx)
        {
            if (!hasTerrain)
            {
                return;
            }

            Vector2Int terrainCoord = GetTerrainLookupCoord(ctx.hdCamera.camera.transform.position);

            // vec2 to subtract from terrain coord in shader to get proper 2D slice in [0,0] to [2,2] range
            terrainLookupCoordOffset = new Vector2Int(terrainCoord.x - 1, terrainCoord.y - 1);

            // if in same terrain coord, nothing needs updating
            if (terrainCoord.x == previousTerrainCoord.x && terrainCoord.y == previousTerrainCoord.y)
            {
                return;
            }

            validTerrainHeightmapMask = 0;

            // only need to update if within valid coord range +- 1
            // valid coord range starts at 0 and ends at terrainLookupResolution - 1
            // so an invalid center coord would be <= -2 or >= terrainLookupResolution + 1
            if (terrainCoord.x < -1 || terrainCoord.y < -1 || terrainCoord.x > terrainLookupResolution || terrainCoord.y > terrainLookupResolution)
            {
                needsComputeDispatch = false;
                previousTerrainCoord = terrainCoord;

                return;
            }

            ComputeUpdatedTerrainData(ctx, terrainCoord, previousTerrainCoord);
            previousTerrainCoord = terrainCoord;

            // only need to copy directional influence if also need compute dispatch
            needsDirectionalInfluenceCopy = needsComputeDispatch;
        }

        public void FirstUpdateTerrainTextureArray()
        {
            if (!hasTerrain)
            {
                return;
            }

            Vector3 position;

            if (Camera.current == null)
            {
                position = Vector3.zero;
            }
            else
            {
                position = Camera.current.transform.position;
            }

            ocean.TerrainCS.SetTexture(kernelIDs.UpdateTexturesResetFoam, PropIDs.terrainHeightmapArrayTexture, terrainHeightmapArrayTexture);
            ocean.TerrainCS.SetTexture(kernelIDs.UpdateTexturesResetFoam, PropIDs.terrainShoreWaveArrayTexture, terrainShoreWaveArrayTexture);
            ocean.TerrainCS.SetInt(PropIDs.terrainHeightmapResolution, terrainHeightmapResolution);

            Vector2Int terrainCoord = GetTerrainLookupCoord(position);

            // vec2 to subtract from terrain coord in shader to get proper 2D slice in [0,0] to [2,2] range
            terrainLookupCoordOffset = new Vector2Int(terrainCoord.x - 1, terrainCoord.y - 1);

            // 9 rightmost bits: will be 1 if that terrain texture array slice is valid
            validTerrainHeightmapMask = 0;

            // terrains might not have GOceanTerrainComponent, so can still have 0 terrain heightmaps that need update
            needsComputeDispatch = false;

            // reset threadGroups.z to 0
            threadGroups.main.z = 0;

            for (int y = -TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION; y <= TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION; y++)
            {
                for (int x = -TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION; x <= TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION; x++)
                {
                    Vector2Int coord = new Vector2Int(terrainCoord.x + x, terrainCoord.y + y);

                    if (InvalidTerrainCoord(coord))
                    {
                        continue;
                    }

                    int id = terrainLookupArray[coord.x, coord.y];

                    // if id is -1 then there is no terrain with a GOceanTerrainData component 
                    // at this coordinate in the square grid of terrains
                    if (id > -1)
                    {
                        int x_ = x + TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION;
                        int y_ = y + TERRAIN_HEIGHTMAP_ARRAY_HALF_RESOLUTION;

                        int slice = x_ + y_ * TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION;
                        int sliceWorldSpace = coord.x + coord.y * terrainLookupResolution;
                        validTerrainHeightmapMask |= 1 << slice;

                        targetSliceIndices[threadGroups.main.z] = slice;
                        targetSliceIndices[threadGroups.main.z + TERRAIN_HEIGHTMAP_ARRAY_SLICES] = sliceWorldSpace;
                        threadGroups.main.z++;

                        ocean.TerrainCS.SetTexture(kernelIDs.UpdateTexturesResetFoam, PropIDs.terrainHeightmapTexture, terrainArray[id].terrainData.heightmapTexture);
                        ocean.TerrainCS.SetInt(PropIDs.slice, slice);
                        ocean.TerrainCS.Dispatch(kernelIDs.UpdateTexturesResetFoam, threadGroups.main.x, threadGroups.main.y, 1);

                        needsComputeDispatch = true;
                    }
                }
            }

            targetSliceIndicesBuffer.SetData(targetSliceIndices);

            previousTerrainCoord = terrainCoord;
        }

        public UnityEngine.Terrain GetTerrainFromLookupCoord(Vector2Int coord)
        {
            return GetTerrainFromLookupCoord(coord.x, coord.y);
        }

        public UnityEngine.Terrain GetTerrainFromLookupCoord(int x, int y)
        {
            return terrainArray[terrainLookupArray[x, y]];
        }

        public UnityEngine.Terrain GetTerrainFromIndex(int index)
        {
            return terrainArray[index];
        }

        public UnityEngine.Terrain[] GetTerrainArray()
        {
            return terrainArray;
        }

        public int[,] GetTerrainLookupArray()
        {
            return terrainLookupArray;
        }

        /// <summary>
        /// Pos / size
        /// </summary>
        /// <param name="position"></param>
        /// <param name="terrainSize"></param>
        /// <returns></returns>
        public Vector2 GetTerrainPositionScaled(Vector3 position)
        {
            return new Vector2(position.x / terrainSize.x, position.z / terrainSize.z);
        }

        public bool InvalidTerrainPosition(Vector3 position)
        {
            return InvalidScaledPosition(GetTerrainPositionScaled(position));
        }

        public bool InvalidScaledPosition(Vector2 position)
        {
            return
                position.x < terrainPosScaledBounds.x ||
                position.x >= terrainPosScaledBounds.y ||
                position.y < terrainPosScaledBounds.z ||
                position.y >= terrainPosScaledBounds.w;
        }

        /// <summary>
        /// The returned vec 2 int is a value to be used with the terrainLookup array, as long as
        /// it's in the valid range of 0 to lookup res - 1
        /// </summary>
        /// <param name="position"></param>
        /// <param name="terrainSize"></param>
        /// <param name="terrainPosScaledBounds"></param>
        /// <returns></returns>
        public Vector2Int GetTerrainLookupCoord(Vector3 position)
        {
            Vector2 scaledPos = GetTerrainPositionScaled(position);
            return GetTerrainLookupCoord(scaledPos);
        }

        /// <summary>
        /// The returned vec 2 int is a value to be used with the terrainLookup array, as long as
        /// it's in the valid range of 0 to lookup res - 1
        /// </summary>
        /// <param name="position"></param>
        /// <param name="terrainSize"></param>
        /// <param name="terrainPosScaledBounds"></param>
        /// <returns></returns>
        public Vector2Int GetTerrainLookupCoord(Vector2 scaledPosition)
        {
            return new Vector2Int(Mathf.FloorToInt(scaledPosition.x - terrainPosScaledBounds.x), Mathf.FloorToInt(scaledPosition.y - terrainPosScaledBounds.z));
        }

        /// <summary>
        /// </summary>
        /// <param name="coord"></param>
        /// <param name="lookupResolution"></param>
        /// <returns>
        /// True if either component of coord is less than 0 or gEqual lookup resolution.
        /// </returns>
        public bool InvalidTerrainCoord(Vector2Int coord)
        {
            return InvalidTerrainCoord(coord.x, coord.y);
        }

        /// <summary>
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="lookupResolution"></param>
        /// <returns>
        /// True if either component of coord is less than 0 or gEqual lookup resolution.
        /// </returns>
        public bool InvalidTerrainCoord(int x, int y)
        {
            return
                x < 0 ||
                y < 0 ||
                x >= terrainLookupResolution ||
                y >= terrainLookupResolution;
        }

        public bool InvalidTerrainSlice(int slice)
        {
            return ((1 << slice) & validTerrainHeightmapMask) < 1;
        }

        public bool InvalidTerrainSlice(Vector2Int slice)
        {
            return InvalidTerrainSlice(slice.x, slice.y);
        }

        public bool InvalidTerrainSlice(int x, int y)
        {
            return
                x < 0 ||
                y < 0 ||
                x >= TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION ||
                y >= TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION;
        }

        /// <summary>
        /// </summary>
        /// <param name="coord"></param>
        /// <returns>
        /// true if index is < 0
        /// </returns>
        public bool InvalidTerrainLookupIndex(Vector2Int coord)
        {
            return InvalidTerrainLookupIndex(coord.x, coord.y);
        }

        /// <summary>
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <returns>
        /// true if index is < 0
        /// </returns>
        public bool InvalidTerrainLookupIndex(int x, int y)
        {
            return terrainLookupArray[x, y] < 0;
        }

        /// <summary>
        /// </summary>
        /// <param name="coord"></param>
        /// <param name="index"></param>
        /// <returns>
        /// true if index is < 0
        /// </returns>
        public bool InvalidTerrainLookupIndex(Vector2Int coord, out int index)
        {
            return InvalidTerrainLookupIndex(coord.x, coord.y, out index);
        }

        /// <summary>
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="value"></param>
        /// <returns>
        /// true if index is < 0
        /// </returns>
        public bool InvalidTerrainLookupIndex(int x, int y, out int index)
        {
            index = terrainLookupArray[x, y];
            return index < 0;
        }

        public int GetTerrainSlice1D(Vector2Int slice2D)
        {
            return GetTerrainSlice1D(slice2D.x, slice2D.y);
        }

        public int GetTerrainSlice1D(int x, int y)
        {
            return x + y * TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION;
        }

        public Vector2Int GetTerrainSlice2D(int slice)
        {
            return new Vector2Int(slice % TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION, slice / TERRAIN_HEIGHTMAP_ARRAY_RESOLUTION);
        }

        public int GetTerrainLookup1D(Vector2Int coord)
        {
            return coord.x + coord.y * terrainLookupResolution;
        }

        public Vector2Int GetTerrainLookup2D(int slice)
        {
            return new Vector2Int(slice % terrainLookupResolution, slice / terrainLookupResolution);
        }

        /// <summary>
        /// Initialize array of Terrains with GOceanTerrainData component
        /// </summary>
        /// <returns>True if Terrains with TerrainData component found</returns>
        /// <exception cref="System.Exception"></exception>
        private bool InitializeTerrainArray()
        {
            TerrainData[] terrainData = Object.FindObjectsByType<TerrainData>(FindObjectsSortMode.None);

            if (terrainData.Length < 1)
            {
                Debug.Log("No TerrainData components found.");
                terrainArray = null;
                return false;
            }

            if (terrainArray == null || terrainArray.Length < 1 || terrainArray.Length != terrainData.Length)
            {
                terrainArray = new UnityEngine.Terrain[terrainData.Length];

                for (int i = 0; i < terrainData.Length; i++)
                {
                    terrainData[i].TryGetComponent<UnityEngine.Terrain>(out UnityEngine.Terrain terrain);
                    if (terrain == null)
                    {
                        throw new System.Exception("TerrainData component does not have an associated UnityEngine.Terrain component.");
                    }
                    terrainArray[i] = terrain;
                }
            }

            return true;
        }

        /// <summary>
        /// Width and height of the terrain array's 2D lookup array. <br/>
        /// Also computes terrainPosScaledBounds, which is (min scaled pos X, max scaled pos X, min scaled pos Z, max scaled pos Z). <br/>
        /// A scaled position is terrain position / terrain size. <br/>
        /// The scaled bounds is the valid area with terrains that have a GOceanTerrainData component attached. <br/>
        /// </summary>
        /// <param name="terrainPosScaledBounds"></param>
        /// <returns></returns>
        private int CalculateLookupResolution(UnityEngine.Terrain[] terrainArray, out Vector4Int terrainPosScaledBounds)
        {
            if (terrainArray == null)
            {
                Debug.Log("Terrain Array null");
                terrainPosScaledBounds = new Vector4Int(0, 0, 0, 0);
                return 0;
            }

            if (terrainArray.Length < 1)
            {
                Debug.Log("Terrain Array length < 1");
                terrainPosScaledBounds = new Vector4Int(0, 0, 0, 0);
                return 0;
            }

            // size.x and size.z should be the same
            Vector3 size = terrainArray[0].terrainData.size;

            float maxX = terrainArray[0].transform.position.x / size.x;
            float minX = maxX;
            float maxZ = terrainArray[0].transform.position.z / size.z;
            float minZ = maxZ;

            for (int i = 1; i < terrainArray.Length; i++)
            {
                float x = terrainArray[i].transform.position.x / size.x;
                float z = terrainArray[i].transform.position.z / size.z;

                maxX = Mathf.Max(maxX, x);
                minX = Mathf.Min(minX, x);

                maxZ = Mathf.Max(maxZ, z);
                minZ = Mathf.Min(minZ, z);
            }

            terrainPosScaledBounds = new Vector4Int(Mathf.RoundToInt(minX), Mathf.RoundToInt(maxX + 1f), Mathf.RoundToInt(minZ), Mathf.RoundToInt(maxZ + 1f));

            int resolution = Mathf.Max(Mathf.RoundToInt(maxX - minX), Mathf.RoundToInt(maxZ - minZ));
            resolution += 1;

            return resolution;
        }

        private void InitializeTextures()
        {
            bool a = InitializeTerrainHeightmapArrayTexture();
            bool b = InitializeTerrainShoreWaveArrayTexture();

            if (a || b)
            {
                InitialArrayTextureFill();
            }
        }

        /// <summary>
        /// Creates a Texture2DArray where each slice contains terrain heightmap data
        /// </summary>
        /// <returns>
        /// True if the texture was created or if its resolution / depth was changed
        /// </returns>
        private bool InitializeTerrainHeightmapArrayTexture()
        {
            RenderTexture rt = terrainHeightmapArrayTexture;

            bool update = false;
            int resolution = terrainArray[0].terrainData.heightmapResolution;

            if (rt == null)
            {
                Create();
                update = true;
            }
            else if (rt.width != resolution || rt.height != resolution || rt.volumeDepth != TERRAIN_HEIGHTMAP_ARRAY_SLICES)
            {
                rt.Release();
                Create();
                update = true;
            }
            else if (!rt.IsCreated())
            {
                rt.Create();
                update = true;
            }

            terrainHeightmapArrayTexture = rt;

            void Create()
            {
                rt = new RenderTexture(resolution, resolution, 0, terrainArray[0].terrainData.heightmapTexture.format);
                rt.name = "TerrainHeightmapArrayTexture";
                rt.wrapMode = TextureWrapMode.Clamp;
                rt.filterMode = FilterMode.Bilinear;
                rt.dimension = UnityEngine.Rendering.TextureDimension.Tex2DArray;
                rt.volumeDepth = TERRAIN_HEIGHTMAP_ARRAY_SLICES;
                rt.enableRandomWrite = true;
                rt.Create();
            }

            return update;
        }

        private bool InitializeTerrainShoreWaveArrayTexture()
        {
            RenderTexture rt = terrainShoreWaveArrayTexture;

            bool update = false;
            int resolution = terrainArray[0].terrainData.heightmapResolution;

            if (rt == null)
            {
                Create();
                update = true;
            }
            else if (rt.width != resolution || rt.height != resolution || rt.volumeDepth != TERRAIN_HEIGHTMAP_ARRAY_SLICES)
            {
                rt.Release();
                Create();
                update = true;
            }
            else if (!rt.IsCreated())
            {
                rt.Create();
                update = true;
            }

            terrainShoreWaveArrayTexture = rt;

            void Create()
            {
                rt = new RenderTexture(resolution, resolution, 0, UnityEngine.Experimental.Rendering.GraphicsFormat.R8G8B8A8_UNorm);
                rt.name = "ShoreWaveTexture";
                rt.wrapMode = TextureWrapMode.Clamp;
                rt.filterMode = FilterMode.Bilinear;
                rt.dimension = UnityEngine.Rendering.TextureDimension.Tex2DArray;
                rt.volumeDepth = TERRAIN_HEIGHTMAP_ARRAY_SLICES;
                rt.enableRandomWrite = true;
                rt.Create();
            }

            return update;
        }

        /// <summary>
        /// 2D index in lookup array will contain an integer that maps to an index in the terrain array.
        /// Integer will be -1 if there is no terrain or a terrain without a GOceanTerrainData component.
        /// </summary>
        private void InitializeTerrainLookupArray()
        {
            int resolution = terrainLookupResolution;

            terrainLookupArray = new int[resolution, resolution];

            // init to -1
            for (int y = 0; y < resolution; y++)
            {
                for (int x = 0; x < resolution; x++)
                {
                    terrainLookupArray[x, y] = -1;
                }
            }

            for (int i = 0; i < terrainArray.Length; i++)
            {
                Vector3 position = terrainArray[i].transform.position;
                Vector2Int coord = GetTerrainLookupCoord(position);

                terrainLookupArray[coord.x, coord.y] = i;
            }
        }

        /// <summary>
        /// Fill all slices of texture arrays with black
        /// </summary>
        public void InitialArrayTextureFill()
        {
            ocean.TerrainCS.SetTexture(kernelIDs.InitialFill, PropIDs.terrainHeightmapArrayTexture, terrainHeightmapArrayTexture);
            ocean.TerrainCS.SetTexture(kernelIDs.InitialFill, PropIDs.terrainShoreWaveArrayTexture, terrainShoreWaveArrayTexture);
            ocean.TerrainCS.SetInt(PropIDs.terrainHeightmapResolution, terrainHeightmapResolution);
            ocean.TerrainCS.Dispatch(kernelIDs.InitialFill, threadGroups.main.x, threadGroups.main.y, TERRAIN_HEIGHTMAP_ARRAY_SLICES);
        }

        private void InitializeTargetSliceIndicesBuffer()
        {
            int count = TERRAIN_HEIGHTMAP_ARRAY_SLICES << 1;

            targetSliceIndices = new int[count];
            for (int i = 0; i < targetSliceIndices.Length; i++)
            {
                targetSliceIndices[i] = 0;
            }

            if (targetSliceIndicesBuffer == null)
            {
                Create();
            }
            else if (targetSliceIndicesBuffer.count != count || targetSliceIndicesBuffer.stride != sizeof(int))
            {
                targetSliceIndicesBuffer.Release();
                Create();
            }

            void Create()
            {
                targetSliceIndicesBuffer = new ComputeBuffer(count, sizeof(int));
                targetSliceIndicesBuffer.name = "Target Slice Indices Buffer";
                targetSliceIndicesBuffer.SetData(targetSliceIndices);
            }
        }

        private void InitializeDirectionalInfluenceBuffer(ThreadGroupSizes tgs)
        {
            int count = tgs.DirectionalInfluence.x << (shoreWaveCount * TERRAIN_HEIGHTMAP_ARRAY_SLICES / tgs.DirectionalInfluence.x);

            Vector4[] directionalInfluence = new Vector4[count];
            for (int i = 0; i < directionalInfluence.Length; i++)
            {
                directionalInfluence[i] = new Vector4(0f, 0f, 0f, 0f);
            }

            if (directionalInfluenceBuffer == null)
            {
                Create();
            }
            else if (directionalInfluenceBuffer.count != count || directionalInfluenceBuffer.stride != sizeof(float) * 4)
            {
                directionalInfluenceBuffer.Release();
                Create();
            }

            void Create()
            {
                directionalInfluenceBuffer = new ComputeBuffer(count, sizeof(float) * 4);
                directionalInfluenceBuffer.name = "Directional Influence Buffer";
                directionalInfluenceBuffer.SetData(directionalInfluence);
            }
        }

        private float CalculateShoreWaveFalloffFactor(float shoreWaveFalloff)
        {
            return TAU / Mathf.Pow(TAU, shoreWaveFalloff);
        }

        private Vector2 CalculateDirectionalInfluence(Vector2 windDirection, float directionalInfluenceMultiplier)
        {
            return windDirection * directionalInfluenceMultiplier;
        }

        public void UpdateDirectionalInfluence(Vector2 windDirection)
        {
            directionalInfluence = CalculateDirectionalInfluence(windDirection, directionalInfluenceMultiplier);
        }

        private float CalculateUVMultiplier(int terrainHeightmapResolution)
        {
            return 1f - (1f / (float)terrainHeightmapResolution);
        }

        private Vector4Int GetOffsetCoord(Vector3Int coord, Vector2Int offset, int res)
        {
            Vector2Int slice2D = GetTerrainSlice2D(coord.z);

            int x = coord.x + offset.x;
            int offsetX = x >= res ? 1 : x < 0 ? -1 : 0;
            x = x < 0 ? x + res : x % res;

            int y = coord.y + offset.y;
            int offsetY = y >= res ? 1 : y < 0 ? -1 : 0;
            y = y < 0 ? y + res : y % res;

            Vector2Int newSlice2D = new Vector2Int(slice2D.x + offsetX, slice2D.y + offsetY);
            int newSlice1D = GetTerrainSlice1D(newSlice2D);
            bool invalid = InvalidTerrainSlice(newSlice2D);

            Vector4Int offsetCoord;

            if (invalid)
            {
                offsetCoord = new Vector4Int(coord.x, coord.y, coord.z, 0);
            }
            else
            {
                offsetCoord = new Vector4Int(x, y, newSlice1D, 1);
            }

            return offsetCoord;
        }

        /// <summary>
        /// Y (height) component of terrainData.size is multiplied by 2.
        /// IDK why need to multiply by 2 to get the proper height.
        /// </summary>
        /// <param name="terrain"></param>
        /// <returns></returns>
        private Vector3 CalculateTerrainSize(UnityEngine.Terrain terrain)
        {
            Vector3 size = terrain.terrainData.size;
            return new Vector3(size.x, size.y * 2f, size.z);
        }

        private float CalculateShoreWaveNoiseScale(float userShoreWaveNoiseScale)
        {
            return 1f / userShoreWaveNoiseScale;
        }

        public void LogValidTerrainHeightmapMask()
        {
            string s = "";
            for (int i = 2; i >= 0; i--)
            {
                for (int j = 0; j < 3; j++)
                {
                    int k = i * 3 + j;
                    s += (validTerrainHeightmapMask & (1 << k)) > 0 ? "1" : "0";
                }
                s += "\n";
            }

            Debug.Log(s);
        }
    }
}