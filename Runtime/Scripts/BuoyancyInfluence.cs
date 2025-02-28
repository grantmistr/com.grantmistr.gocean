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

        public float GetRadius()
        {
            return radius;
        }

        public void SetRadius(float radius)
        {
            this.radius = radius;
        }

        public Vector3 GetLocalPosition()
        {
            return localPosition;
        }

        public void SetLocalPosition(Vector3 position)
        {
            localPosition = position;
        }

        public void UpdateWorldPosition(Matrix4x4 localToWorldMatrix)
        {
            oceanSampler.position = localToWorldMatrix.MultiplyPoint(localPosition);
        }

        /// <summary>
        /// Applies a force to a rigid body at the position of this buoyancy influence, increasing based on how much of the influence
        /// is submerged underwater.
        /// </summary>
        /// <param name="rigidbody"></param>
        /// <returns>
        /// Submerged percentage, 0-1 range.
        /// </returns>
        public float ApplyForce(Rigidbody rigidbody)
        {
            float submergedPercentage = Mathf.Clamp01((oceanSampler.outputData.height - (oceanSampler.position.y - radius)) / (2f * radius));
            float submergedVolume = submergedPercentage * (4f * Mathf.PI * radius * radius);
            Vector3 buoyantForce = submergedVolume * force * Time.fixedDeltaTime * UnityEngine.Physics.gravity.magnitude * oceanSampler.outputData.normal;
            
            rigidbody.AddForceAtPosition(buoyantForce, oceanSampler.position);

            return submergedPercentage;
        }

        public Vector3 GetWorldPosition()
        {
            return oceanSampler.position;
        }
    }
}