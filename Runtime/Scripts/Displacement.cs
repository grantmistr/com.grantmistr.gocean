using UnityEngine;
using UnityEngine.Rendering;
using Unity.Mathematics;
using System.Threading.Tasks;

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;
    using static Helper;

    public class Displacement : Component
    {
        public const int SPECTRUM_TEXTURE_SLICE_COUNT = 10;
        public const int SPECTRUM_COUNT = 4;
        public const float AMPLITUDE_SCALE = 3e-07f;

        [ShaderParam("_SpectrumTextureResolution")]
        public int spectrumTextureResolution;
        [ShaderParam("_Gravity")]
        public float gravity;
        [ShaderParam("_Speed")]
        public float speed;
        [ShaderParam("_Amplitude")]
        public float amplitude;
        [ShaderParam("_Steepness")]
        public float steepness;
        [ShaderParam("_Turbulence")]
        public float turbulence;
        [ShaderParam("_Smoothing")]
        public float smoothing;
        [ShaderParam("_MaxPatchSize")]
        public float maxPatchSize;
        [ShaderParam("_PatchScaleRatios")]
        public Vector4 patchScaleRatios;
        [ShaderParam("_LowWaveCutoff")]
        public float lowWaveCutoff;
        [ShaderParam("_HighWaveCutoff")]
        public float highWaveCutoff;

        [ShaderParam("_PatchSize")]
        public Vector4 patchSize;
        [ShaderParam("_PatchHighestWaveCount")]
        public Vector4 patchHighestWaveCount;
        [ShaderParam("_PatchLowestWaveCount")]
        public Vector4 patchLowestWaveCount;
        [ShaderParam("_SpectrumMaxAmplitude")]
        public Vector4 spectrumMaxAmplitude = Vector4.one;
        [ShaderParam("_MaxAmplitude")]
        public float maxAmplitude = 1f;

        [ShaderParamGlobal("_SpectrumTexture")]
        public RenderTexture spectrumTexture;

        public ThreadGroups threadGroups;
        public KernelIDs kernelIDs;

        public struct KernelIDs
        {
            public int InitialFill { get; private set; }
            public int UpdateInitialSpectrum { get; private set; }
            public int UpdateInitialSpectrumConjugate { get; private set; }
            public int UpdateSpectrum { get; private set; }
            public int IFFT { get; private set; }
            public int AssembleMaps { get; private set; }
            public int SurfaceData { get; private set; }
            public int MergeSurfaceData { get; private set; }
            public int CalculateSpectrumMaxAmplitude { get; private set; }

            public KernelIDs(Displacement displacement)
            {
                InitialFill = displacement.ocean.SpectrumCS.FindKernel("InitialFill");
                UpdateInitialSpectrum = displacement.ocean.SpectrumCS.FindKernel("UpdateInitialSpectrum");
                UpdateInitialSpectrumConjugate = displacement.ocean.SpectrumCS.FindKernel("UpdateInitialSpectrumConjugate");
                UpdateSpectrum = displacement.ocean.SpectrumCS.FindKernel("UpdateSpectrum");
                IFFT = displacement.ocean.SpectrumCS.FindKernel("IFFT");
                AssembleMaps = displacement.ocean.SpectrumCS.FindKernel("AssembleMaps");
                SurfaceData = displacement.ocean.SpectrumCS.FindKernel("SurfaceData");
                MergeSurfaceData = displacement.ocean.SpectrumCS.FindKernel("MergeSurfaceData");
                CalculateSpectrumMaxAmplitude = displacement.ocean.SpectrumCS.FindKernel("CalculateSpectrumMaxAmplitude");
            }

            public readonly int[] ToArray()
            {
                return new int[] { InitialFill, UpdateInitialSpectrum, UpdateInitialSpectrumConjugate, UpdateSpectrum, IFFT, AssembleMaps, SurfaceData, MergeSurfaceData, CalculateSpectrumMaxAmplitude };
            }
        }

        public struct ThreadGroups
        {
            public Vector3Int Main { get; private set; }
            public Vector3Int IFFT { get; private set; }
            public Vector3Int MergeSurfaceData { get; private set; }

            public ThreadGroups(Displacement displacement)
            {
                Vector3Int v = new Vector3Int();
                displacement.ocean.SpectrumCS.GetKernelThreadGroupSizes(displacement.kernelIDs.UpdateInitialSpectrum, out uint x, out uint y, out uint z);
                v.x = Mathf.CeilToInt(displacement.spectrumTextureResolution / (float)x);
                v.y = Mathf.CeilToInt(displacement.spectrumTextureResolution / (float)y);
                v.z = SPECTRUM_COUNT;
                Main = v;

                IFFT = new Vector3Int(1, displacement.spectrumTextureResolution, SPECTRUM_COUNT);

                MergeSurfaceData = new Vector3Int(v.x, v.y, 1);
            }
        }

        public Displacement()
        {
        }

        public override void Initialize()
        {
            InitializeParams(ocean.parametersUser.displacement);

            kernelIDs = new KernelIDs(this);
            threadGroups = new ThreadGroups(this);

            MCSArrays.AddComputeShader(ocean.SpectrumCS, kernelIDs.UpdateInitialSpectrum, kernelIDs.UpdateInitialSpectrumConjugate,
                kernelIDs.UpdateSpectrum, kernelIDs.IFFT, kernelIDs.AssembleMaps, kernelIDs.SurfaceData, kernelIDs.MergeSurfaceData);

            InitializeSpectrumTexture(spectrumTextureResolution);
        }

        public override void ReleaseResources()
        {
            ReleaseTexture(ref spectrumTexture);
        }

        public override void InitializeParams(BaseParamsUser userParams)
        {
            DisplacementParamsUser u = userParams as DisplacementParamsUser;

            spectrumTextureResolution = (int)u.spectrumTextureResolution;

            gravity = u.gravity;
            speed = u.speed;
            steepness = u.steepness;
            amplitude = CalculateAmplitude(u.amplitude);
            turbulence = u.turbulence;
            smoothing = u.smoothing;
            maxPatchSize = u.maxPatchSize;
            patchScaleRatios = u.patchScaleRatios;

            patchSize = CalculatePatchSizes(maxPatchSize, patchScaleRatios);
            lowWaveCutoff = u.lowWaveCutoff;
            highWaveCutoff = u.highWaveCutoff;
            CalculatePatchLowHighWaveCounts(lowWaveCutoff, highWaveCutoff, smoothing, patchSize, out patchLowestWaveCount, out patchHighestWaveCount);
            CalculateSpectrumMaxAmplitude();
            //spectrumMaxAmplitude = CalculateSpectrumMaxAmplitude(patchSize, patchLowestWaveCount, patchHighestWaveCount, spectrumTextureResolution, amplitude, gravity);
            //maxAmplitude = CalculateMaxAmplitude(spectrumMaxAmplitude);
        }

        public override void SetShaderParams()
        {
            SetKeywords(spectrumTextureResolution);

            base.SetShaderParams();
        }

        private void SetKeywords(int spectrumTextureResolution)
        {
            SetKeyword(ocean.SpectrumCS, $"RESOLUTION_{(int)Resolution._128}", false);
            SetKeyword(ocean.SpectrumCS, $"RESOLUTION_{(int)Resolution._256}", false);
            SetKeyword(ocean.SpectrumCS, $"RESOLUTION_{(int)Resolution._512}", false);
            SetKeyword(ocean.SpectrumCS, $"RESOLUTION_{(int)Resolution._1024}", false);

            SetKeyword(ocean.SpectrumCS, $"RESOLUTION_{spectrumTextureResolution}", true);
        }

        private void InitializeSpectrumTexture(int resolution)
        {
            RenderTexture rt = spectrumTexture;

            if (rt == null)
            {
                Create();
            }
            else if (rt.width != resolution || rt.height != resolution || rt.volumeDepth != SPECTRUM_TEXTURE_SLICE_COUNT)
            {
                rt.Release();
                Create();
            }
            else if (!rt.IsCreated())
            {
                rt.Create();
            }

            spectrumTexture = rt;

            void Create()
            {
                rt = new RenderTexture(resolution, resolution, 0, RenderTextureFormat.ARGBHalf);
                rt.name = "SpectrumTexture";
                rt.filterMode = FilterMode.Bilinear;
                rt.wrapMode = TextureWrapMode.Repeat;
                rt.dimension = TextureDimension.Tex2DArray;
                rt.volumeDepth = SPECTRUM_TEXTURE_SLICE_COUNT;
                rt.memorylessMode = RenderTextureMemoryless.MSAA | RenderTextureMemoryless.Depth;
                rt.enableRandomWrite = true;
                rt.useMipMap = true;
                rt.autoGenerateMips = false;
                rt.Create();

                ocean.SpectrumCS.SetInt("_SpectrumTextureResolution_", resolution);
                ocean.SpectrumCS.SetTexture(kernelIDs.InitialFill, PropIDs.spectrumTexture, rt);
                ocean.SpectrumCS.Dispatch(kernelIDs.InitialFill, threadGroups.Main.x, threadGroups.Main.y, SPECTRUM_TEXTURE_SLICE_COUNT);
            }
        }

        public void UpdateSpectrumTexture(CommandBuffer cmd)
        {
            cmd.DispatchCompute(ocean.SpectrumCS, kernelIDs.UpdateInitialSpectrum, threadGroups.Main);
            cmd.DispatchCompute(ocean.SpectrumCS, kernelIDs.UpdateInitialSpectrumConjugate, threadGroups.Main);
            cmd.DispatchCompute(ocean.SpectrumCS, kernelIDs.UpdateSpectrum, threadGroups.Main);

            cmd.SetComputeIntParam(ocean.SpectrumCS, PropIDs.IFFTDirection, 0);
            cmd.DispatchCompute(ocean.SpectrumCS, kernelIDs.IFFT, threadGroups.IFFT);
            
            cmd.SetComputeIntParam(ocean.SpectrumCS, PropIDs.IFFTDirection, 1);
            cmd.DispatchCompute(ocean.SpectrumCS, kernelIDs.IFFT, threadGroups.IFFT);
            
            cmd.DispatchCompute(ocean.SpectrumCS, kernelIDs.AssembleMaps, threadGroups.Main);
            cmd.DispatchCompute(ocean.SpectrumCS, kernelIDs.SurfaceData, threadGroups.Main);
            cmd.DispatchCompute(ocean.SpectrumCS, kernelIDs.MergeSurfaceData, threadGroups.MergeSurfaceData);
            
            cmd.GenerateMips(spectrumTexture);
        }

        private void CalculatePatchLowHighWaveCounts(float lowWaveCutoff, float highWaveCutoff, float reduceWaves, Vector4 patchSize, out Vector4 patchLowestWaveCount, out Vector4 patchHighestWaveCount)
        {
            Vector4 l = new Vector4();
            Vector4 h = new Vector4();

            Vector4 worldTexelSize = patchSize / (float)spectrumTextureResolution;

            l[0] = lowWaveCutoff;
            h[0] = 1f / (worldTexelSize[0] * worldTexelSize[0]);

            for (int i = 1; i < 4; i++)
            {
                l[i] = Mathf.Max(1f / Mathf.Sqrt(patchSize[i]), l[0]);
                h[i] = Mathf.Min(1f / (worldTexelSize[i] * worldTexelSize[i]), highWaveCutoff);
            }

            h[3] = highWaveCutoff;

            for (int i = 0; i < 4; i++)
            {
                h[i] = Mathf.Lerp(h[i], l[i], Mathf.Clamp01(reduceWaves * (float)(1 << i)));
            }

            patchLowestWaveCount = l;
            patchHighestWaveCount = h;
        }

        private Vector4 CalculatePatchSizes(float maxPatchSize, Vector4 patchScaleRatios)
        {
            Vector4 v = new Vector4();

            for (int i = 0; i < 4; i++)
            {
                v[i] = maxPatchSize / patchScaleRatios[i];
            }

            return v;
        }

        private float CalculateMaxAmplitude(Vector4 spectrumMaxAmplitude)
        {
            float o = 0f;

            o += spectrumMaxAmplitude.x;
            o += spectrumMaxAmplitude.y;
            o += spectrumMaxAmplitude.z;
            o += spectrumMaxAmplitude.w;

            return o;
        }

        private async Task<Vector4> CalculateSpectrumMaxAmplitudeComputeDispatch()
        {
            uint[] sumArray = new uint[SPECTRUM_COUNT + 1] { 0, 0, 0, 0, 0 };

            ComputeBuffer sumBuffer = new ComputeBuffer(SPECTRUM_COUNT + 1, sizeof(uint), ComputeBufferType.Raw);
            sumBuffer.SetData(sumArray);

            int kernel = ocean.SpectrumCS.FindKernel("CalculateSpectrumMaxAmplitude");

            // patchSize and spectrumTextureResolution are in CBuffer, so needed to redefine them with different names
            // since this function is getting called before CBuffers have actual data
            ocean.SpectrumCS.SetBuffer(kernel, PropIDs.spectrumMaxAmplitudeBuffer, sumBuffer);
            ocean.SpectrumCS.SetVector("_PatchSize_", patchSize);
            ocean.SpectrumCS.SetVector(PropIDs.patchLowestWaveCount, patchLowestWaveCount);
            ocean.SpectrumCS.SetVector(PropIDs.patchHighestWaveCount, patchHighestWaveCount);
            ocean.SpectrumCS.SetInt("_SpectrumTextureResolution_", spectrumTextureResolution);
            ocean.SpectrumCS.SetFloat(PropIDs.amplitude, amplitude);
            ocean.SpectrumCS.SetFloat(PropIDs.gravity, gravity);
            SetKeywords(spectrumTextureResolution);

            ocean.SpectrumCS.Dispatch(kernel, 1, 1, SPECTRUM_COUNT);

            sumBuffer.GetData(sumArray);
            
            while (sumArray[SPECTRUM_COUNT] < 4)
            {
                await Task.Delay(Mathf.RoundToInt(Time.deltaTime * 1000f));
                sumBuffer.GetData(sumArray);
            }
            
            sumBuffer.Release();
            sumBuffer = null;

            return new Vector4(math.asfloat(sumArray[0]), math.asfloat(sumArray[1]), math.asfloat(sumArray[2]), math.asfloat(sumArray[3]));
        }

        private async void CalculateSpectrumMaxAmplitude()
        {
            spectrumMaxAmplitude = await CalculateSpectrumMaxAmplitudeComputeDispatch();
            maxAmplitude = CalculateMaxAmplitude(spectrumMaxAmplitude);
            components.Mesh.UpdateBounds(maxAmplitude);
        }

        private Vector4 CalculateSpectrumMaxAmplitude(Vector4 patchSize, Vector4 patchLowestWaveCount, Vector4 patchHighestWaveCount, int spectrumTextureResolution, float amplitude, float gravity)
        {
            ComputeBuffer sumBuffer = new ComputeBuffer(SPECTRUM_COUNT + 1, sizeof(float), ComputeBufferType.Raw);

            int kernel = ocean.SpectrumCS.FindKernel("CalculateSpectrumMaxAmplitude");

            // patchSize and spectrumTextureResolution are in CBuffer, so needed to redefine them with different names
            // since this function is getting called before CBuffers have actual data
            ocean.SpectrumCS.SetBuffer(kernel, PropIDs.spectrumMaxAmplitudeBuffer, sumBuffer);
            ocean.SpectrumCS.SetVector("_PatchSize_", patchSize);
            ocean.SpectrumCS.SetVector(PropIDs.patchLowestWaveCount, patchLowestWaveCount);
            ocean.SpectrumCS.SetVector(PropIDs.patchHighestWaveCount, patchHighestWaveCount);
            ocean.SpectrumCS.SetInt("_SpectrumTextureResolution_", spectrumTextureResolution);
            ocean.SpectrumCS.SetFloat(PropIDs.amplitude, amplitude);
            ocean.SpectrumCS.SetFloat(PropIDs.gravity, gravity);
            SetKeywords(spectrumTextureResolution);

            ocean.SpectrumCS.Dispatch(kernel, 1, 1, SPECTRUM_COUNT);

            float[] sumArray = new float[SPECTRUM_COUNT];
            sumBuffer.GetData(sumArray);
            sumBuffer.Release();
            sumBuffer = null;

            return new Vector4(sumArray[0], sumArray[1], sumArray[2], sumArray[3]);
        }

        private float Phillips(float frequency, float windSpeed, float amplitude, float gravity)
        {
            float w2 = frequency * frequency;
            float w4 = w2 * w2;
            float largestWave = windSpeed * windSpeed / gravity;
            largestWave *= largestWave;

            return Mathf.Sqrt(amplitude * Mathf.Exp(-1f / (w2 * largestWave)) / w4) * (1f / Mathf.Sqrt(2f));
        }

        private float Dispersion(float frequency, float gravity)
        {
            return Mathf.Sqrt(gravity * frequency);
        }

        private Vector2 ComplexMultiply(Vector2 c0, Vector2 c1)
        {
            Vector2 c;
            c.x = c0.x * c1.x - c0.y * c1.y;
            c.y = c0.x * c1.y + c0.y * c1.x;

            return c;
        }

        private float CalculateAmplitude(float userAmplitude)
        {
            return userAmplitude * AMPLITUDE_SCALE;
        }
    }
}