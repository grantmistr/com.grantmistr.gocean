using UnityEngine.Rendering;

namespace GOcean
{
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

        private Component[] components = new Component[NUM_COMPONENTS] {
            new Generic(),
            new Wind(),
            new Displacement(),
            new Surface(),
            new Foam(),
            new Terrain(),
            new Screen(),
            new Caustic(),
            new Underwater(),
            new Mesh(),
            new Physics()
        };

        public Generic Generic              { get { return components[0] as Generic; } }
        public Wind Wind                    { get { return components[1] as Wind; } }
        public Displacement Displacement    { get { return components[2] as Displacement; } }
        public Surface Surface              { get { return components[3] as Surface; } }
        public Foam Foam                    { get { return components[4] as Foam; } }
        public Terrain Terrain              { get { return components[5] as Terrain; } }
        public Screen Screen                { get { return components[6] as Screen; } }
        public Caustic Caustic              { get { return components[7] as Caustic; } }
        public Underwater Underwater        { get { return components[8] as Underwater; } }
        public Mesh Mesh                    { get { return components[9] as Mesh; } }
        public Physics Physics              { get { return components[10] as Physics; } }

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