using UnityEngine;
using UnityEngine.Rendering;

namespace GOcean
{
    using static GOcean.OceanSampler;
    using static Helper;

    public class Physics : Component
    {
        public const uint HEIGHT_SAMPLE_ITERATIONS = 2;
        private const uint DISPLACEMENT_TEXTURE_READBACK_COUNT = 4;

        public Texture2D[] spectrumTextureReadback = new Texture2D[DISPLACEMENT_TEXTURE_READBACK_COUNT];
        
        private bool waitingOnRequest = false;

        public Physics()
        {
        }

        public override void Initialize()
        {
            InitializeTextures();
        }

        public override void InitializeParams(BaseParamsUser userParams) { }

        public override void SetShaderParams() { }

        private void InitializeTextures()
        {
            int resolution = (int)components.Displacement.spectrumTextureResolution;

            resolution = Mathf.Max(resolution, 1);

            if (spectrumTextureReadback == null)
            {
                spectrumTextureReadback = new Texture2D[DISPLACEMENT_TEXTURE_READBACK_COUNT];
            }

            for (int i = 0; i < spectrumTextureReadback.Length; i++)
            {
                if (spectrumTextureReadback[i] == null)
                {
                    spectrumTextureReadback[i] = new Texture2D(resolution, resolution, TextureFormat.RGBAHalf, false);
                }
                else if (spectrumTextureReadback[i].width != resolution || spectrumTextureReadback[i].height != resolution)
                {
                    spectrumTextureReadback[i].Reinitialize(resolution, resolution);
                }
            }
        }

        public void FrameUpdate()
        {
            RequestReadback();
        }

        private void RequestReadback()
        {
            if (components.Displacement.spectrumTexture != null)
            {
                if (!waitingOnRequest)
                {
                    waitingOnRequest = true;
                    AsyncGPUReadback.Request(components.Displacement.spectrumTexture, 0, OnCompletedReadback);
                }
            }
        }

        private void OnCompletedReadback(AsyncGPUReadbackRequest request)
        {
            waitingOnRequest = false;

            if (request.hasError)
            {
                Debug.LogError("GPU readback error");
                return;
            }

            for (int i = 0; i < spectrumTextureReadback.Length; i++)
            {
                if (spectrumTextureReadback[i] != null)
                {
                    spectrumTextureReadback[i].SetPixelData<Vector4>(request.GetData<Vector4>(i), 0);
                }
            }
        }

        public void SampleOcean(OceanSampler sampler)
        {
            Vector3 uvTerrain = sampler.position;
            Vector3 uvTerrainStep = uvTerrain;

            Vector2 uv0 = new Vector2(sampler.position.x / components.Displacement.patchSize.x, sampler.position.z / components.Displacement.patchSize.x);
            Vector2 uv1 = new Vector2(sampler.position.x / components.Displacement.patchSize.y, sampler.position.z / components.Displacement.patchSize.y);
            Vector2 uvStep0 = uv0;
            Vector2 uvStep1 = uv1;

            for (uint i = 0; i < sampler.iterations; i++)
            {
                DoSampleStep(uv0, uv1, ref uvStep0, ref uvStep1, uvTerrain, ref uvTerrainStep);
            }

            Vector2Int lookupCoord = components.Terrain.GetTerrainLookupCoord(uvTerrainStep);
            float terrainSample = 1f;

            if (!components.Terrain.InvalidTerrainCoord(lookupCoord))
            {
                if (!components.Terrain.InvalidTerrainLookupIndex(lookupCoord, out int index))
                {
                    terrainSample = components.Terrain.GetTerrainFromIndex(index).SampleHeight(uvTerrainStep);
                    terrainSample = components.Generic.waterHeight - terrainSample;
                    terrainSample /= components.Terrain.waveDisplacementFade;
                    terrainSample = Mathf.Clamp01(terrainSample);
                }
            }

            Vector4 displacementSample = spectrumTextureReadback[0].GetPixelBilinear(uvStep0.x, uvStep0.y);
            displacementSample += (Vector4)spectrumTextureReadback[2].GetPixelBilinear(uvStep1.x, uvStep1.y);

            Vector4 normalSample = spectrumTextureReadback[1].GetPixelBilinear(uvStep0.x, uvStep0.y);
            normalSample += (Vector4)spectrumTextureReadback[3].GetPixelBilinear(uvStep1.x, uvStep1.y);

            sampler.outputData.height = displacementSample.y * terrainSample + components.Generic.waterHeight;
            sampler.outputData.normal = new Vector3(normalSample.x * terrainSample, 1f, normalSample.y * terrainSample).normalized;
        }

        private void DoSampleStep(Vector2 uv0, Vector2 uv1, ref Vector2 uvStep0, ref Vector2 uvStep1, Vector3 uvTerrain, ref Vector3 uvTerrainStep)
        {
            Vector2Int lookupCoord = components.Terrain.GetTerrainLookupCoord(uvTerrainStep);
            float terrainSample = 1f;

            if (!components.Terrain.InvalidTerrainCoord(lookupCoord))
            {
                if (!components.Terrain.InvalidTerrainLookupIndex(lookupCoord, out int index))
                {
                    terrainSample = components.Terrain.GetTerrainFromIndex(index).SampleHeight(uvTerrainStep);
                    terrainSample = components.Generic.waterHeight - terrainSample;
                    terrainSample /= components.Terrain.waveDisplacementFade;
                    terrainSample = Mathf.Clamp01(terrainSample);
                }
            }

            Vector4 textureSample = spectrumTextureReadback[0].GetPixelBilinear(uvStep0.x, uvStep0.y);
            textureSample += (Vector4)spectrumTextureReadback[2].GetPixelBilinear(uvStep1.x, uvStep1.y);

            Vector2 displacementSample = new Vector2(textureSample.x, textureSample.z);
            displacementSample *= terrainSample;

            uvTerrainStep.x = uvTerrain.x - displacementSample.x;
            uvTerrainStep.z = uvTerrain.z - displacementSample.y;

            uvStep0 = uv0 - displacementSample / components.Displacement.patchSize.x;
            uvStep1 = uv1 - displacementSample / components.Displacement.patchSize.y;
        }
    }
}