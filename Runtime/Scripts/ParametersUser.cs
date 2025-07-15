using UnityEngine;

namespace GOcean
{
    [CreateAssetMenu(fileName = "Ocean Parameters", menuName = "GOcean/Ocean Parameters", order = 0)]
    [System.Serializable]
    public class ParametersUser : ScriptableObject
    {
        public const string RESOURCE_STRING = "GOcean_DefaultOceanParameters";
        public const int NUM_COMPONENTS = ComponentContainer.NUM_COMPONENTS;

        [SerializeReference]
        public GenericParamsUser generic = new GenericParamsUser();
        [SerializeReference]
        public WindParamsUser wind = new WindParamsUser();
        [SerializeReference]
        public DisplacementParamsUser displacement = new DisplacementParamsUser();
        [SerializeReference]
        public SurfaceParamsUser surface = new SurfaceParamsUser();
        [SerializeReference]
        public FoamParamsUser foam = new FoamParamsUser();
        [SerializeReference]
        public TerrainParamsUser terrain = new TerrainParamsUser();
        [SerializeReference]
        public ScreenParamsUser screen = new ScreenParamsUser();
        [SerializeReference]
        public CausticParamsUser caustic = new CausticParamsUser();
        [SerializeReference]
        public UnderwaterParamsUser underwater = new UnderwaterParamsUser();
        [SerializeReference]
        public MeshParamsUser mesh = new MeshParamsUser();
        [SerializeReference]
        public PhysicsParamsUser physics = new PhysicsParamsUser();

        private BaseParamsUser this[int i]
        {
            get
            {
                return i switch
                {
                    (int)ComponentIndices.generic => generic,
                    (int)ComponentIndices.wind => wind,
                    (int)ComponentIndices.displacement => displacement,
                    (int)ComponentIndices.surface => surface,
                    (int)ComponentIndices.foam => foam,
                    (int)ComponentIndices.terrain => terrain,
                    (int)ComponentIndices.screen => screen,
                    (int)ComponentIndices.caustic => caustic,
                    (int)ComponentIndices.underwater => underwater,
                    (int)ComponentIndices.mesh => mesh,
                    (int)ComponentIndices.physics => physics,
                    _ => throw new System.Exception("Invalid index.")
                };
            }
        }

        public void SetComponentReferences(ComponentContainer components)
        {
            for (int i = 0; i < NUM_COMPONENTS; i++)
            {
                this[i].SetComponent(components[i]);
            }
        }

        public void SetComponentsNull()
        {
            for (int i = 0; i < NUM_COMPONENTS; i++)
            {
                this[i].SetComponent(null);
            }
        }
    }

    [System.Serializable]
    public abstract class BaseParamsUser
    {
        protected Component component;

        public virtual void Update()
        {
            if (component != null)
            {
                component.Initialize();
                component.SetShaderParams();
            }
        }

        public void SetComponent(Component component)
        {
            this.component = component;
        }
    }

    [System.Serializable]
    public class GenericParamsUser : BaseParamsUser
    {
        public const uint PROP_COUNT = 4;

        public bool receiveSSR = false;
        public int randomSeed = 0;
        public float waterHeight = 100f;
        [Tooltip("Sets the sorting priority for the ocean relative to other transparent objects. Ocean should usually render before all other transparent objects.")]
        [Range(-100, 100)]
        public int sortingPriority = -50;
    }

    [System.Serializable]
    public class WindParamsUser : BaseParamsUser
    {
        [Min(0f)]
        public float windSpeed = 9f;
        [Tooltip("In radians.")]
        [LoopedFloat(Mathf.PI * 2f)]
        public float windDirection = 5f;
        [Min(0f)]
        public float windSpeedMin = 3f;
        [Min(1f)]
        public float windSpeedMax = 100f;
    }

    [System.Serializable]
    public class DisplacementParamsUser : BaseParamsUser
    {
        public Resolution spectrumTextureResolution = Resolution._512;
        [Min(0f)]
        public float gravity = 9.81f;
        [Min(0f)]
        public float speed = 1f;
        [Min(0f)]
        public float amplitude = 0.5f;
        [Tooltip("Slightly lowering Steepness below 1 can alleviate wave crest loops.")]
        [Range(0f, 1f)]
        public float steepness = 0.8f;
        [Range(0f, 1f)]
        public float turbulence = 0.2f;
        [Range(0f, 1f)]
        public float smoothing = 0f;
        [Tooltip("Size of the largest spectrum in the world units.")]
        [Min(1f)]
        public float maxPatchSize = 1024f;
        [Tooltip("Scale ratio of a spectrum with MaxPatchSize. MaxPatchSize divided by this value to get the size of the spectrum.")]
        public PatchScaleRatios patchScaleRatios = new PatchScaleRatios(1f, 2f, 4f, 8f);
        [Tooltip("Low wave frequency cutoff. No waves simulated with a frequency below this value.")]
        [Min(0f)]
        public float lowWaveCutoff = 0.015f;
        [Tooltip("High wave frequency cutoff. No waves simulated with a frequency above this value.")]
        [Min(0f)]
        public float highWaveCutoff = 100f;
    }

    [System.Serializable]
    public class SurfaceParamsUser : BaseParamsUser
    {
        [Min(0f)]
        public float normalStrength = 1f;
        [Range(0f, 1f)]
        public float smoothness = 0.9f;
        [Tooltip("Smoothness of distant water.")]
        [Range(0f, 1f)]
        public float distantSmoothness = 0.7f;
        [Tooltip("Distance from camera at which the water will be fully transitioned to distant smoothness value.")]
        [Min(0f)]
        public float smoothnessTransitionDistance = 2000f;
        public float refractionStrength = 5f;
        [ColorUsage(true, true)]
        public Color waterColor = new Color(0.3915094f, 0.70573f, 1f);
        [ColorUsage(true, true)]
        public Color scatteringColor = new Color(0.2520915f, 0.3896481f, 0.5188679f);
        [Min(1f)]
        public float scatteringFalloff = 5f;
    }

    [System.Serializable]
    public class FoamParamsUser : BaseParamsUser
    {
        public Texture2D foamTexture;
        public Color foamColor = new Color(0.89f, 0.88f, 0.87f);
        [Tooltip("Distance to fade out foam texture to avoid noticeable tiling.")]
        [Min(0f)]
        public float foamTextureFadeDistance = 1000f;
        [Min(0f)]
        public float foamTiling = 2f;
        [Tooltip("Secondary foam tiling is multiplied with tiling.")]
        [Min(0f)]
        public float secondaryFoamTiling = 8f;
        [Min(0f)]
        public float foamOffsetSpeed = 1f;
        [Tooltip("Effectiveness of foam texture.")]
        [Range(0f, 1f)]
        public float foamHardness = 0.6f;
        [Tooltip("When spectrum slices get combined, there can be too much foam, so slightly reducing this value below 1 can look good.")]
        [Range(0f, 1f)]
        public float distantFoam = 0.96f;
        public float edgeFoamWidth = 0.2f;
        public float edgeFoamFalloff = 0.5f;
        public float edgeFoamStrength = 0.3f;
        public float shoreWaveFoamAmount = 2f;
        [Min(0f)]
        public float foamDecayRate = 1f;
        [Tooltip("Raising this value increases how much of a wave foam will spawn on.")]
        public float foamBias = -0.2f;
        [Min(0f)]
        public float foamAccumulationRate = 1f;
    }

    [System.Serializable]
    public class TerrainParamsUser : BaseParamsUser
    {
        public bool useTerrainInfluence = true;
        [Tooltip("Offsets the shore waves on the terrain. Always recommend having this value above 0.")]
        public float heightmapOffset = 3f;
        [Tooltip("Depth at which waves are fully displaced, and unaffected by terrain heightmap.")]
        public float waveDisplacementFade = 100f;
        [Range(1, Terrain.MAX_SHORE_WAVE_COUNT)]
        public int shoreWaveCount = 5;
        [Min(0.001f)]
        public float shoreWaveStartDepth = 8f;
        [Tooltip("Modifies the shape of the wave crest.")]
        [Range(0.1f, 1f)]
        public float shoreWaveFalloff = 0.4f;
        public float shoreWaveHeight = 0.5f;
        public float shoreWaveSpeed = 0.15f;
        [Min(0f)]
        public float shoreWaveNoiseStrength = 0.02f;
        [Min(0f)]
        public float shoreWaveNoiseScale = 3f;
        public float shoreWaveNormalStrength = 0.5f;
        [Tooltip("How much shore waves are influenced by wind.")]
        [Range(0f, 1f)]
        public float directionalInfluenceMultiplier = 0.5f;
    }

    [System.Serializable]
    public class ScreenParamsUser : BaseParamsUser
    {
        [Tooltip("Write screen water to depth buffer before post processing. Useful for depth of field.")]
        public bool screenWaterWritesToDepth = true;
        public Texture2D screenWaterNoiseTexture;
        [Min(0f)]
        public float screenWaterTiling = 0.2f;
        [Min(0f)]
        public float screenWaterFadeSpeed = 800f;
    }

    [System.Serializable]
    public class CausticParamsUser : BaseParamsUser
    {
        [Min(0f)]
        public float causticStrength = 0.08f;
        public float causticTiling = 0.8f;
        [Tooltip("Strength of chromatic aberration like effect.")]
        public float causticDistortion = 0.002f;
        [Min(0f)]
        public float causticDefinition = 10f;
        [Tooltip("Underwater depth at which caustics (and light rays) will fade out.")]
        [Min(1f)]
        public float causticFadeDepth = 400f;
        [Tooltip("Distance at which caustics will fade out above the water.")]
        [Min(1f)]
        public float causticAboveWaterFadeDistance = 20f;
    }

    [System.Serializable]
    public class UnderwaterParamsUser : BaseParamsUser
    {
        public Color underwaterFogColor = new Color(0.6179246f, 0.8031732f, 1f);
        [Min(0f)]
        public float underwaterFogFadeDistance = 150f;
        [Range(0f, 500f)]
        public float underwaterSurfaceEmissionStrength = 30f;
        [Range(0f, 1f)]
        public float lightRayShadowMultiplier = 0.1f;
        [Min(0f)]
        public float lightRayTiling = 1f;
        [Range(0f, 3f)]
        public float lightRayDefinition = 1.25f;
        [Tooltip("Light rays fade in from camera near clip plane.")]
        [Min(1f)]
        public float lightRayFadeInDistance = 1f;
        [Tooltip("Number of iterations used to calculate underwater light rays.")]
        [Range(1, 32)]
        public uint sliceCount = 16;
        [Min(1f)]
        public float maxSliceDepth = 80f;
        [Min(0.01f)]
        public float minSliceDepth = 1f;
    }

    [System.Serializable]
    public class MeshParamsUser : BaseParamsUser
    {
        [Range(1, 1000)]
        public int chunkSize = 90;
        [Range(3, 1000)]
        public int chunkGridResolution = 30;
        [Tooltip("There really is no reason to lower this value. Control the tessellation using chunk size and chunk grid resolution.")]
        [Range(0, Mesh.MAX_SUPPORTED_TESSELLATION_LEVEL)]
        public int maxTessellation = Mesh.MAX_SUPPORTED_TESSELLATION_LEVEL;
        [Range(0f, 1f)]
        public float tessellationFalloff = 0.8f;
        [Range(0f, Mesh.MAX_SUPPORTED_TESSELLATION_LEVEL)]
        public float tessellationOffset = 0f;
        public float cullPadding = 0f;
        [Tooltip("How gradual mesh displacement will flatten to match distant water plane. Lower values are more gradual.")]
        [Min(1f)]
        public float displacementFalloff = 3f;
        [Tooltip("Won't show up in build.")]
        public bool drawWireframe = false;
    }

    [System.Serializable]
    public class PhysicsParamsUser : BaseParamsUser
    {
        [Tooltip("Multiplier for rigid body dampening when the rigid body is in water.")]
        [Min(0f)]
        public float waterDampeningMultiplier = 1000f;
    }
}