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
        private float diameter = 2f;
        private float volume = 4f * Mathf.PI;

        public BuoyancyInfluence() { }

        public BuoyancyInfluence(float force, float radius, uint iterations)
        {
            this.force = force;
            this.radius = radius;
            this.localPosition = Vector3.zero;
            this.oceanSampler.iterations = iterations;
        }

        public BuoyancyInfluence(float force, float radius, Vector3 localPosition, uint iterations)
        {
            this.force = force;
            this.radius = radius;
            this.localPosition = localPosition;
            this.oceanSampler.iterations = iterations;
        }

        public BuoyancyInfluence Clone()
        {
            return new BuoyancyInfluence(force, radius, localPosition, oceanSampler.iterations);
        }

        public void Initialize()
        {
            diameter = 2f * radius;
            volume = 4f * Mathf.PI * radius * radius;
            Ocean.OceanSamplers.Add(oceanSampler);
        }

        public void Initialize(Matrix4x4 localToWorldMatrix)
        {
            UpdateWorldPosition(localToWorldMatrix);
            diameter = radius + radius;
            volume = 4f * Mathf.PI * radius * radius;
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
            diameter = radius + radius;
            volume = 4f * Mathf.PI * radius;
        }

        public Vector3 GetLocalPosition()
        {
            return localPosition;
        }

        public void SetLocalPosition(Vector3 position)
        {
            localPosition = position;
        }

        public void UpdateLocalPosition(Matrix4x4 worldToLocalMatrix)
        {
            localPosition = worldToLocalMatrix.MultiplyPoint(oceanSampler.position);
        }

        public Vector3 GetWorldPosition()
        {
            return oceanSampler.position;
        }

        public void SetWorldPosition(Vector3 position)
        {
            oceanSampler.position = position;
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
            float submergedPercentage = Mathf.Clamp01((oceanSampler.outputData.height - (oceanSampler.position.y - radius)) / diameter);
            float submergedVolume = submergedPercentage * volume;
            Vector3 buoyantForce = submergedVolume * force * Time.fixedDeltaTime * UnityEngine.Physics.gravity.magnitude * oceanSampler.outputData.normal;
            
            rigidbody.AddForceAtPosition(buoyantForce, oceanSampler.position);

            return submergedPercentage;
        }
    }
}