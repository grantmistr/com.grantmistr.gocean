using UnityEngine;

namespace GOcean
{
    [RequireComponent(typeof(Rigidbody))]
    public class Floater : MonoBehaviour
    {
        public BuoyancyInfluence[] buoyancyInfluences;
        new private Rigidbody rigidbody;
        private float initialLinearDamping;

        private void OnEnable()
        {
            if (buoyancyInfluences.Length < 1)
            {
                Debug.Log($"{this} has no buoyancy influence objects attached, and will be disabled.");
                enabled = false;
            }

            Matrix4x4 m = transform.localToWorldMatrix;
            foreach (BuoyancyInfluence i in buoyancyInfluences)
            {
                i.Initialize(m);
            }

            rigidbody = GetComponent<Rigidbody>();
            initialLinearDamping = rigidbody.linearDamping;
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
                float submergedVolumePercentage = 0f;
                foreach (BuoyancyInfluence i in buoyancyInfluences)
                {
                    i.UpdateWorldPosition(m);
                    submergedVolumePercentage += i.ApplyForce(rigidbody);
                }
                submergedVolumePercentage /= buoyancyInfluences.Length;

                rigidbody.linearDamping = Mathf.Lerp(initialLinearDamping, initialLinearDamping * Ocean.Instance.WaterDampeningMultiplier, submergedVolumePercentage);
            }
            else
            {
                float submergedVolumePercentage = 0f;
                foreach (BuoyancyInfluence i in buoyancyInfluences)
                {
                    submergedVolumePercentage += i.ApplyForce(rigidbody);
                }
                submergedVolumePercentage /= buoyancyInfluences.Length;

                rigidbody.linearDamping = Mathf.Lerp(initialLinearDamping, initialLinearDamping * Ocean.Instance.WaterDampeningMultiplier, submergedVolumePercentage);
            }
        }

        /// <summary>
        /// The initial linear dampening value that will be multiplied with the ocean water dampening multiplier.
        /// By default, this value is set to the linear dampening value on the rigid body.
        /// </summary>
        /// <returns></returns>
        public float GetInitialLinearDampening()
        {
            return initialLinearDamping;
        }

        /// <summary>
        /// Set the initial linear dampening value that will be multiplied with the ocean water dampening multiplier.
        /// By default, this value is set to the linear dampening value on the rigid body.
        /// </summary>
        /// <param name="linearDampening"></param>
        public void SetInitialLinearDampening(float linearDampening)
        {
            initialLinearDamping = linearDampening;
        }
    }
}