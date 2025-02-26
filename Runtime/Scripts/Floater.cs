using UnityEngine;

namespace GOcean
{
    [RequireComponent(typeof(Rigidbody))]
    public class Floater : MonoBehaviour
    {
        [SerializeField]
        private bool uniformSamplerIterations = true;
        public bool UniformSamplerIterations
        {
            get
            {
                return uniformSamplerIterations;
            }
            set
            {
                uniformSamplerIterations = value;
                if (value)
                {
                    foreach (BuoyancyInfluence i in buoyancyInfluences)
                    {
                        i.SetSamplerIterations(samplerIterations);
                    }
                }
            }
        }
        [SerializeField]
        private bool uniformForce = true;
        public bool UniformForce
        {
            get
            {
                return uniformForce;
            }
            set
            {
                uniformForce = value;
                if (value)
                {
                    foreach (BuoyancyInfluence i in buoyancyInfluences)
                    {
                        i.SetForce(force);
                    }
                }
            }
        }
        [SerializeField]
        private bool uniformRadius = true;
        public bool UniformRadius
        {
            get
            {
                return uniformRadius;
            }
            set
            {
                uniformRadius = value;
                if (value)
                {
                    foreach (BuoyancyInfluence i in buoyancyInfluences)
                    {
                        i.SetRadius(radius);
                    }
                }
            }
        }

        public uint samplerIterations = 2;
        public float force = 1f;
        public float radius = 1f;

        public BuoyancyInfluence[] buoyancyInfluences;

        new private Rigidbody rigidbody;

        private void OnEnable()
        {
            UniformSamplerIterations = uniformSamplerIterations;
            UniformForce = uniformForce;
            UniformRadius = uniformRadius;

            foreach (BuoyancyInfluence i in buoyancyInfluences)
            {
                i.Initialize(transform.localToWorldMatrix);
            }

            rigidbody = GetComponent<Rigidbody>();
        }

        private void OnDisable()
        {
            foreach (BuoyancyInfluence i in buoyancyInfluences)
            {
                i.DeInitialize();
            }
        }

        private void FixedUpdate()
        {
            if (transform.hasChanged)
            {
                Matrix4x4 m = transform.localToWorldMatrix;
                foreach (BuoyancyInfluence i in buoyancyInfluences)
                {
                    i.UpdateWorldPosition(m);
                    i.ApplyForce(rigidbody);
                }
            }
            else
            {
                foreach (BuoyancyInfluence i in buoyancyInfluences)
                {
                    i.ApplyForce(rigidbody);
                }
            }
        }
    }
}