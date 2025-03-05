using UnityEngine.Rendering;

namespace GOcean
{
    public enum ComponentIndices
    {
        generic = 0,
        wind = 1,
        displacement = 2,
        surface = 3,
        foam = 4,
        terrain = 5,
        screen = 6,
        caustic = 7,
        underwater = 8,
        mesh = 9,
        physics = 10
    }

    public abstract class Component
    {
        protected Ocean ocean;
        protected ComponentContainer components;
        protected RTHandleSystem rtHandleSystem;
        protected MaterialComputeShaderArrays MCSArrays;

        public abstract void Initialize();
        public void Initialize(Ocean ocean, ComponentContainer components, RTHandleSystem rtHandleSystem, MaterialComputeShaderArrays MCSArrays)
        {
            this.ocean = ocean;
            this.components = components;
            this.rtHandleSystem = rtHandleSystem;
            this.MCSArrays = MCSArrays;

            Initialize();
        }
        public virtual void ReleaseResources() { }
        public abstract void InitializeParams(BaseParamsUser userParams);
        public virtual void SetShaderParams()
        {
            if (MCSArrays == null)
            {
                return;
            }

            ShaderParamSetter.SetParams(this, MCSArrays);
        }
    }

    public class ComponentContainer
    {
        public const int NUM_COMPONENTS = 11;

        private Component[] components = new Component[NUM_COMPONENTS];

        public Generic Generic              { get { return components[(int)ComponentIndices.generic] as Generic; } }
        public Wind Wind                    { get { return components[(int)ComponentIndices.wind] as Wind; } }
        public Displacement Displacement    { get { return components[(int)ComponentIndices.displacement] as Displacement; } }
        public Surface Surface              { get { return components[(int)ComponentIndices.surface] as Surface; } }
        public Foam Foam                    { get { return components[(int)ComponentIndices.foam] as Foam; } }
        public Terrain Terrain              { get { return components[(int)ComponentIndices.terrain] as Terrain; } }
        public Screen Screen                { get { return components[(int)ComponentIndices.screen] as Screen; } }
        public Caustic Caustic              { get { return components[(int)ComponentIndices.caustic] as Caustic; } }
        public Underwater Underwater        { get { return components[(int)ComponentIndices.underwater] as Underwater; } }
        public Mesh Mesh                    { get { return components[(int)ComponentIndices.mesh] as Mesh; } }
        public Physics Physics              { get { return components[(int)ComponentIndices.physics] as Physics; } }

        public ComponentContainer()
        {
            components[(int)ComponentIndices.generic] = new Generic();
            components[(int)ComponentIndices.wind] = new Wind();
            components[(int)ComponentIndices.displacement] = new Displacement();
            components[(int)ComponentIndices.surface] = new Surface();
            components[(int)ComponentIndices.foam] = new Foam();
            components[(int)ComponentIndices.terrain] = new Terrain();
            components[(int)ComponentIndices.screen] = new Screen();
            components[(int)ComponentIndices.caustic] = new Caustic();
            components[(int)ComponentIndices.underwater] = new Underwater();
            components[(int)ComponentIndices.mesh] = new Mesh();
            components[(int)ComponentIndices.physics] = new Physics();
        }

        public Component this[int i]
        {
            get
            {
                return components[i];
            }
        }

        public void Initialize()
        {
            foreach (Component component in components)
            {
                component.Initialize();
            }
        }

        public void Initialize(Ocean ocean, RTHandleSystem rtHandleSystem, MaterialComputeShaderArrays MCSArrays)
        {
            foreach (Component component in components)
            {
                component.Initialize(ocean, this, rtHandleSystem, MCSArrays);
            }
        }

        public void ReleaseResources()
        {
            foreach (Component component in components)
            {
                component.ReleaseResources();
            }
        }

        public void SetShaderParams()
        {
            foreach (Component component in components)
            {
                component.SetShaderParams();
            }
        }
    }
}