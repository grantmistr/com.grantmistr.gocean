using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;

namespace GOcean
{
    using static Helper;
    using PropIDs = ShaderPropertyIDs;

    public class Constants
    {
        public PerCameraData[] perCameraData = { PerCameraData.Default };
        public OnDemandData[] onDemandData = { OnDemandData.Default };
        public ConstantData[] constantData = { ConstantData.Default };

        private ComputeBuffer perCameraDataBuffer;
        private ComputeBuffer onDemandDataBuffer;
        private ComputeBuffer constantDataBuffer;

        public struct PerCameraData
        {
            public Vector4 cascadeShadowSplits;
            public Vector4 cameraPositionStepped;
            public float cameraZRotation;
            public float unused0;
            public float unused1;
            public float unused2;
            public Vector2Int terrainLookupCoordOffset;
            public int validTerrainHeightmapMask;
            public int unused3;

            public static readonly PerCameraData Default = new PerCameraData()
            {
                cascadeShadowSplits = Vector4.zero,
                cameraPositionStepped = Vector4.zero,
                cameraZRotation = 0f,
                unused0 = 0f,
                unused1 = 0f,
                unused2 = 0f,
                terrainLookupCoordOffset = Vector2Int.zero,
                validTerrainHeightmapMask = 0,
                unused3 = 0
            };

            public void Update(CustomPassContext ctx, ComponentContainer components)
            {
                HDShadowSettings shadowSettings = ctx.hdCamera.volumeStack.GetComponent<HDShadowSettings>();

                cascadeShadowSplits[0] = shadowSettings.cascadeShadowSplit0.value * shadowSettings.maxShadowDistance.value;
                cascadeShadowSplits[1] = shadowSettings.cascadeShadowSplit1.value * shadowSettings.maxShadowDistance.value;
                cascadeShadowSplits[2] = shadowSettings.cascadeShadowSplit2.value * shadowSettings.maxShadowDistance.value;
                cascadeShadowSplits[3] = shadowSettings.maxShadowDistance.value;

                cameraPositionStepped = CalculateCameraPositionStepped(ctx.hdCamera.camera, components.Mesh.chunkSize);
                cameraZRotation = GetCameraZRotation(ctx.hdCamera.camera);
                terrainLookupCoordOffset = components.Terrain.terrainLookupCoordOffset;
                validTerrainHeightmapMask = components.Terrain.validTerrainHeightmapMask;
            }

            public void Update(Camera camera, ComponentContainer components)
            {
                HDShadowSettings shadowSettings = VolumeManager.instance.stack.GetComponent<HDShadowSettings>();

                if (shadowSettings != null)
                {
                    cascadeShadowSplits[0] = shadowSettings.cascadeShadowSplit0.value * shadowSettings.maxShadowDistance.value;
                    cascadeShadowSplits[1] = shadowSettings.cascadeShadowSplit1.value * shadowSettings.maxShadowDistance.value;
                    cascadeShadowSplits[2] = shadowSettings.cascadeShadowSplit2.value * shadowSettings.maxShadowDistance.value;
                    cascadeShadowSplits[3] = shadowSettings.maxShadowDistance.value;
                }

                if (camera != null)
                {
                    cameraPositionStepped = CalculateCameraPositionStepped(camera, components.Mesh.chunkSize);
                    cameraZRotation = GetCameraZRotation(camera);
                }

                terrainLookupCoordOffset = components.Terrain.terrainLookupCoordOffset;
                validTerrainHeightmapMask = components.Terrain.validTerrainHeightmapMask;
            }

            public static int SizeOf()
            {
                return sizeof(float) * 12 + sizeof(int) * 4;
            }
        }

        public struct OnDemandData
        {
            public Vector2 windDirection;
            public Vector2 directionalInfluence;
            public float windSpeed;
            public float causticStrength;
            public float lightRayStrength;
            public float lightRayStrengthInverse;
            public float waterHeight;
            public float turbulence;
            public float unused4;
            public float unused5;

            public static readonly OnDemandData Default = new OnDemandData()
            {
                windDirection = Vector2.zero,
                directionalInfluence = Vector2.zero,
                windSpeed = 0f,
                causticStrength = 0f,
                lightRayStrength = 0f,
                lightRayStrengthInverse = 0f,
                waterHeight = 0f,
                turbulence = 0f,
                unused4 = 0f,
                unused5 = 0f
            };

            public void Update(ComponentContainer components)
            {
                windDirection = components.Wind.WindDirection;
                directionalInfluence = components.Terrain.directionalInfluence;
                windSpeed = components.Wind.WindSpeed;
                causticStrength = components.Caustic.causticStrength;
                lightRayStrength = components.Underwater.lightRayStrength;
                lightRayStrengthInverse = components.Underwater.lightRayStrengthInverse;
                waterHeight = components.Generic.waterHeight;
                turbulence = components.Displacement.turbulence;
            }

            public static int SizeOf()
            {
                return sizeof(float) * 12;
            }
        }

        public struct ConstantData
        {
            public Vector4 patchSize;
            public Vector4 underwaterFogColor;
            public float underwaterFogFadeDistance;
            public float causticDistortion;
            public float causticDefinition;
            public float causticTiling;
            public float causticFadeDepth;
            public float causticAboveWaterFadeDistance;
            public float unused6;
            public float unused7;
            public uint spectrumTextureResolution;
            public int unused8;
            public int unused9;
            public int unused10;

            public static readonly ConstantData Default = new ConstantData()
            {
                patchSize = Vector4.zero,
                underwaterFogColor = Vector4.zero,
                underwaterFogFadeDistance = 0f,
                causticDistortion = 0f,
                causticDefinition = 0f,
                causticTiling = 0f,
                causticFadeDepth = 0f,
                causticAboveWaterFadeDistance = 0f,
                unused6 = 0f,
                unused7 = 0f,
                spectrumTextureResolution = 0,
                unused8 = 0,
                unused9 = 0,
                unused10 = 0
            };

            public void Update(ComponentContainer components)
            {
                patchSize = components.Displacement.patchSize;
                underwaterFogColor = components.Underwater.underwaterFogColor.linear;
                underwaterFogFadeDistance = components.Underwater.underwaterFogFadeDistance;
                causticDistortion = components.Caustic.causticDistortion;
                causticDefinition = components.Caustic.causticDefinition;
                causticTiling = components.Caustic.causticTiling;
                causticFadeDepth = components.Caustic.causticFadeDepth;
                causticAboveWaterFadeDistance = components.Caustic.causticAboveWaterFadeDistance;
                spectrumTextureResolution = (uint)components.Displacement.spectrumTextureResolution;
            }

            public static int SizeOf()
            {
                return sizeof(float) * 16 + sizeof(int) * 4;
            }
        }

        public void Initialize(ComponentContainer components)
        {
            InitializeAsCBuffer(ref perCameraDataBuffer, PerCameraData.SizeOf(), perCameraData);
            InitializeAsCBuffer(ref onDemandDataBuffer, OnDemandData.SizeOf(), onDemandData);
            InitializeAsCBuffer(ref constantDataBuffer, ConstantData.SizeOf(), constantData);

            perCameraDataBuffer.SetData(perCameraData);
            onDemandDataBuffer.SetData(onDemandData);
            constantDataBuffer.SetData(constantData);

            Shader.SetGlobalConstantBuffer(PropIDs.GOceanPerCamera, perCameraDataBuffer, 0, PerCameraData.SizeOf());
            Shader.SetGlobalConstantBuffer(PropIDs.GOceanOnDemand, onDemandDataBuffer, 0, OnDemandData.SizeOf());
            Shader.SetGlobalConstantBuffer(PropIDs.GOceanConstant, constantDataBuffer, 0, ConstantData.SizeOf());
        }

        public void UpdatePerCameraData(CustomPassContext ctx, ComponentContainer components)
        {
            perCameraData[0].Update(ctx, components);
            perCameraDataBuffer.SetData(perCameraData);
        }

        public void UpdatePerCameraData(Camera camera, ComponentContainer components)
        {
            if (camera == null)
            {
                return;
            }

            perCameraData[0].Update(camera, components);
            perCameraDataBuffer.SetData(perCameraData);
        }

        public void UpdateOnDemandData(ComponentContainer components)
        {
            onDemandData[0].Update(components);
            onDemandDataBuffer.SetData(onDemandData);
        }

        public void UpdateConstantData(ComponentContainer components)
        {
            constantData[0].Update(components);
            constantDataBuffer.SetData(constantData);
        }

        public void SetCBuffersOnComputeShaders(ComputeShader[] computeShaders)
        {
            foreach (ComputeShader c in computeShaders)
            {
                c.SetConstantBuffer(PropIDs.GOceanPerCamera, perCameraDataBuffer, 0, PerCameraData.SizeOf());
                c.SetConstantBuffer(PropIDs.GOceanOnDemand, onDemandDataBuffer, 0, OnDemandData.SizeOf());
                c.SetConstantBuffer(PropIDs.GOceanConstant, constantDataBuffer, 0, ConstantData.SizeOf());
            }
        }

        public void ReleaseResources()
        {
            ReleaseBuffer(ref perCameraDataBuffer);
            ReleaseBuffer(ref onDemandDataBuffer);
            ReleaseBuffer(ref constantDataBuffer);
        }
    }
}