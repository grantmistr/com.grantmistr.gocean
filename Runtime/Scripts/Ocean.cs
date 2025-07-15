using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;
    using static Helper;

    [ExecuteAlways]
    [DisallowMultipleComponent]
    [AddComponentMenu("GOcean/Ocean", -1)]
    public class Ocean : MonoBehaviour
    {
        /// <summary>
        /// Singleton instance of the ocean. One ocean per scene.
        /// </summary>
        public static Ocean Instance { get { return instance; } }
        private static Ocean instance;

        /// <summary>
        /// List of OceanSampler objects that get updated on FixedUpdate
        /// </summary>
        public static List<OceanSampler> OceanSamplers { get; private set; } = new List<OceanSampler>();

        private const uint NUM_MATERIALS = 5;
        private const uint NUM_COMPUTE_SHADERS = 4;

        [SerializeReference]
        public ParametersUser parametersUser;
        [SerializeReference]
        private ComponentContainer components = new ComponentContainer();
        private Constants constants = new Constants();

        private Material[] materials = new Material[NUM_MATERIALS];
        public Material OceanM              { get { return materials[(int)MaterialIndex.ocean]; } }
        public Material DistantOceanM       { get { return materials[(int)MaterialIndex.distantOcean]; } }
        public Material FullscreenM         { get { return materials[(int)MaterialIndex.fullscreen]; } }
        public Material WaterScreenMaskM    { get { return materials[(int)MaterialIndex.waterScreenMask]; } }
        public Material WireframeM          { get { return materials[(int)MaterialIndex.wireframe]; } }

        private ComputeShader[] computeShaders = new ComputeShader[NUM_COMPUTE_SHADERS];
        public ComputeShader SpectrumCS     { get { return computeShaders[(int)ComputeShaderIndex.spectrum]; } }
        public ComputeShader TerrainCS      { get { return computeShaders[(int)ComputeShaderIndex.terrain]; } }
        public ComputeShader UnderwaterCS   { get { return computeShaders[(int)ComputeShaderIndex.underwater]; } }
        public ComputeShader MeshCS         { get { return computeShaders[(int)ComputeShaderIndex.mesh]; } }

        private MaterialComputeShaderArrays MCSArrays = new MaterialComputeShaderArrays();
        private RTHandleSystem rtHandleSystem = new RTHandleSystem();
        private CustomPasses customPasses = new CustomPasses();

        public delegate void OnInitializedEventHandler();
        public delegate void OnUnInitializedEventHandler();
        public event OnInitializedEventHandler OnInitialized;
        public event OnUnInitializedEventHandler OnUnInitialized;

        private bool isInitialized = false;
        public bool IsInitialized
        {
            get
            {
                return isInitialized;
            }
            private set
            {
                bool prevValue = isInitialized;

                isInitialized = value;

                if (value != prevValue)
                {
                    if (value)
                    {
                        if (OnInitialized != null)
                        {
                            OnInitialized();
                        }
                    }
                    else
                    {
                        if (OnUnInitialized != null)
                        {
                            OnUnInitialized();
                        }
                    }
                }
            }
        }

        public Vector4 CascadeShadowSplits => constants.perCameraData[0].cascadeShadowSplits;
        public Vector4 CameraPositionStepped => constants.perCameraData[0].cameraPositionStepped;
        public float CameraZRotation => constants.perCameraData[0].cameraZRotation;
        public float WaterDampeningMultiplier => components.Physics.waterDampeningMultiplier;

        public Vector2 WindDirection
        {
            get
            {
                return components.Wind.WindDirection;
            }
            set
            {
                components.Wind.WindDirection = value;
            }
        }

        public float WindSpeed
        {
            get
            {
                return components.Wind.WindSpeed;
            }
            set
            {
                components.Wind.WindSpeed = value;
            }
        }

        public float WaterHeight
        {
            get
            {
                return components.Generic.waterHeight;
            }
            set
            {
                components.Generic.waterHeight = value;
            }
        }

        public float Turbulence
        {
            get
            {
                return components.Displacement.turbulence;
            }
            set
            {
                components.Displacement.turbulence = value;
            }
        }

        private void OnEnable()
        {
            if (!ValidateInstance())
            {
                Debug.Log("Destroying one GOcean instance");

                LateUpdateSmartDestroy(this, Cleanup);

                return;
            }

            Initialize();
        }

#if UNITY_EDITOR
        private void LateUpdate()
        {
            if (!ValidateTexturesSet() && IsInitialized)
            {
                SetShaderParams();
            }
        }
#endif

        private void FixedUpdate()
        {
            FixedFrameUpdate();
        }

        private void Update()
        {
            FrameUpdate();
        }

        private void OnDisable()
        {
            IsInitialized = false;
            customPasses.DisableVolumes();
            ReleaseResources();

            if (instance == this)
            {
                instance = null;
            }
        }

        private void OnDestroy()
        {
            Cleanup();
        }

        /// <summary>
        /// </summary>
        /// <returns>True if valid instance</returns>
        private bool ValidateInstance()
        {
            if (instance == null)
            {
                instance = this;
            }
            else if (instance != this)
            {
                Debug.Log("Multiple GOcean instances found");
                return false;
            }

            return true;
        }

        public void Initialize()
        {
            if (!PipelineCompatibilityChecker.IsValid())
            {
                return;
            }

            customPasses.DisableVolumes();

            if (!ComponentCheck())
            {
                GetDefaultResources();
            }

            if (!ComponentCheck())
            {
                Debug.Log("Invalid components, could not initialize Ocean.");
                return;
            }

            MCSArrays.AddMaterials(materials);
            InitializeRTHandleSystem();
            components.Initialize(this, rtHandleSystem, MCSArrays);
            constants.Initialize(components);
            parametersUser.SetComponentReferences(components);
            SetShaderParams();

            customPasses.Initialize(this, components, constants);
            customPasses.EnableVolumes();

            IsInitialized = true;

#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                if (firstInit)
                {
                    firstInit = false;
                    StartCoroutine(FirstInit());
                }
            }
#endif
        }

#if UNITY_EDITOR
        private bool firstInit = true;

        // Can't seem to fill a render texture using a compute shader on the frame the RT is created?
        // Maybe this has to do with loading the compute shader from resources... IDK man, seems to be
        // editor only problem tho
        private IEnumerator FirstInit()
        {
            yield return WaitForFrames(1);
            components.Generic.GenerateRandomNoise();
            components.Terrain.InitialArrayTextureFill();
            components.Terrain.FirstUpdateTerrainTextureArray();
        }
#endif

        private void GetDefaultResources()
        {
            ParametersUser parametersUser = Resources.Load<ParametersUser>(ParametersUser.RESOURCE_STRING);
            MaterialResources materials = Resources.Load<MaterialResources>(MaterialResources.RESOURCE_STRING);
            ComputeShaderResources computeShaders = Resources.Load<ComputeShaderResources>(ComputeShaderResources.RESOURCE_STRING);

            if (this.parametersUser == null)
            {
                this.parametersUser = parametersUser;
            }

            for (int i = 0; i < NUM_MATERIALS; i++)
            {
                if (this.materials[i] == null || this.materials[i] != materials[i])
                {
                    this.materials[i] = materials[i];
                }
            }

            for (int i = 0; i < NUM_COMPUTE_SHADERS; i++)
            {
                if (this.computeShaders[i] == null || this.computeShaders[i] != computeShaders[i])
                {
                    this.computeShaders[i] = computeShaders[i];
                }
            }
        }

        private IEnumerator GetDefaultResourcesAsync()
        {
            ResourceRequest paramsRequest = Resources.LoadAsync<ParametersUser>(ParametersUser.RESOURCE_STRING);
            ResourceRequest materialRequest = Resources.LoadAsync<MaterialResources>(MaterialResources.RESOURCE_STRING);
            ResourceRequest computeShaderRequest = Resources.LoadAsync<ComputeShaderResources>(ComputeShaderResources.RESOURCE_STRING);
            
            while(!(paramsRequest.isDone && materialRequest.isDone && computeShaderRequest.isDone))
            {
                yield return null;
            }

            if (parametersUser == null)
            {
                parametersUser = paramsRequest.asset as ParametersUser;
            }

            MaterialResources materials = materialRequest.asset as MaterialResources;
            for (int i = 0; i < NUM_MATERIALS; i++)
            {
                if (this.materials[i] == null || this.materials[i] != materials[i])
                {
                    this.materials[i] = materials[i];
                }
            }

            ComputeShaderResources computeShaders = computeShaderRequest.asset as ComputeShaderResources;
            for (int i = 0; i < NUM_COMPUTE_SHADERS; i++)
            {
                if (this.computeShaders[i] == null || this.computeShaders[i] != computeShaders[i])
                {
                    this.computeShaders[i] = computeShaders[i];
                }
            }
        }

        /// <summary>
        /// </summary>
        /// <returns>True if all components are valid</returns>
        private bool ComponentCheck()
        {
            bool invalid = false;

            foreach (Material m in materials)
            {
                if (m == null)
                {
                    invalid = true;
                }
            }

            foreach (ComputeShader c in computeShaders)
            {
                if (c == null)
                {
                    invalid = true;
                }
            }

            if (parametersUser == null)
            {
                invalid = true;
            }

            return !invalid;
        }

        /// <summary>
        /// Only call this on init / re-init
        /// </summary>
        private void SetShaderParams()
        {
            constants.UpdatePerCameraData(Camera.current, components);
            constants.UpdateOnDemandData(components);
            constants.UpdateConstantData(components);

            constants.SetCBuffersOnComputeShaders(computeShaders);

            components.SetShaderParams();
        }

        /// <summary>
        /// Scuffed way of determining if user has ctrl+s the scene. Render texture refs will get dropped unless
        /// they have been saved as assets, or they are global :^)
        /// </summary>
        /// <returns></returns>
        private bool ValidateTexturesSet()
        {
            if (OceanM != null)
            {
                return OceanM.GetTexture(PropIDs.terrainShoreWaveArrayTexture) != null;
            }

            return false;
        }

        /// <summary>
        /// Releases resources before init
        /// </summary>
        public void ReInitialize()
        {
            IsInitialized = false;
            customPasses.DisableVolumes();
            ReleaseResources();
            MCSArrays.Reset();

            Initialize();
        }

        private void FixedFrameUpdate()
        {
            if (IsInitialized)
            {
                components.Physics.FrameUpdate();
                UpdateSampleData();
            }
        }

        private void FrameUpdate()
        {
            if (IsInitialized)
            {
                components.Generic.DrawWaterForward();
#if UNITY_EDITOR
                components.Mesh.DrawWireframe();
#endif
            }
        }

        private void UpdateSampleData()
        {
            foreach (OceanSampler sampler in OceanSamplers)
            {
                components.Physics.SampleOcean(sampler);
            }
        }

        private void InitializeRTHandleSystem()
        {
            if (rtHandleSystem == null)
            {
                rtHandleSystem = new RTHandleSystem();
                rtHandleSystem.Initialize(1, 1);
                rtHandleSystem.SetReferenceSize(1, 1);
            }
        }

        private void ReleaseResources()
        {
            ReleaseRTHandleSystem(ref rtHandleSystem);
            components.ReleaseResources();
            constants.ReleaseResources();
        }

        private void Cleanup()
        {
            IsInitialized = false;
            customPasses.DisableVolumes();
            customPasses.Destroy(this);
            ReleaseResources();

            if (instance == this)
            {
                instance = null;
            }
        }

        public void LogKeywords()
        {
            foreach (LocalKeyword kw in OceanM.enabledKeywords)
            {
                Debug.Log(kw.ToString());
            }
        }

        /// <summary>
        /// Call this function if any ocean properties were modified.
        /// </summary>
        public void UpdateOnDemandDataBuffer()
        {
            constants.UpdateOnDemandData(components);
        }

        public void UpdateConstantDataBuffer()
        {
            constants.UpdateConstantData(components);
        }

        /// <summary>
        /// Sample the ocean at a position, with optional number of iterations for more, or less accurate result.
        /// </summary>
        /// <param name="samplePosition"></param>
        /// <param name="iterations"></param>
        /// <returns>
        /// Ocean height and normal at sample position
        /// </returns>
        public OceanSampleOutputData SampleOcean(Vector3 samplePosition, uint iterations = Physics.HEIGHT_SAMPLE_ITERATIONS)
        {
            return components.Physics.SampleOcean(samplePosition, iterations);
        }
    }
}