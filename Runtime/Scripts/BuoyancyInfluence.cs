using UnityEngine;

namespace GOcean
{
    [System.Serializable]
    public class BuoyancyInfluence
    {
        [SerializeField]
        private float force = 1f;
        [SerializeField]
        private float radius = 1f;
        [SerializeField]
        private Vector3 localPosition = Vector3.zero;
        [SerializeField]
        private OceanSampler oceanSampler = new OceanSampler();

        public void Initialize()
        {
            Ocean.OceanSamplers.Add(oceanSampler);
        }

        public void Initialize(Matrix4x4 localToWorldMatrix)
        {
            UpdateWorldPosition(localToWorldMatrix);
            Ocean.OceanSamplers.Add(oceanSampler);
        }

        public void DeInitialize()
        {
            Ocean.OceanSamplers.Remove(oceanSampler);
        }

        public void SetSamplerIterations(uint iterations)
        {
            oceanSampler.iterations = iterations;
        }

        public void SetForce(float force)
        {
            this.force = force;
        }

        public void SetRadius(float radius)
        {
            this.radius = radius;
        }

        public void SetLocalPosition(Vector3 position, Matrix4x4 localToWorldMatrix)
        {
            localPosition = position;
            UpdateWorldPosition(localToWorldMatrix);
        }

        public void UpdateWorldPosition(Matrix4x4 localToWorldMatrix)
        {
            oceanSampler.position = localToWorldMatrix.MultiplyPoint(localPosition);
        }

        public void ApplyForce(Rigidbody rigidbody)
        {
            float f = (oceanSampler.outputData.height - (oceanSampler.position.y - radius)) / (2f * radius) / rigidbody.mass * force * Time.deltaTime;
            f = Mathf.Max(f, 0f);
            rigidbody.AddForceAtPosition(oceanSampler.outputData.normal * f, oceanSampler.position);
        }

        public Vector3 GetWorldPosition()
        {
            return oceanSampler.position;
        }
    }
}