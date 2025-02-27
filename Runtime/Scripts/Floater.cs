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

                rigidbody.linearDamping = Mathf.Lerp(initialLinearDamping, initialLinearDamping * 1000f, submergedVolumePercentage);
            }
            else
            {
                float submergedVolumePercentage = 0f;
                foreach (BuoyancyInfluence i in buoyancyInfluences)
                {
                    submergedVolumePercentage += i.ApplyForce(rigidbody);
                }
                submergedVolumePercentage /= buoyancyInfluences.Length;

                rigidbody.linearDamping = Mathf.Lerp(initialLinearDamping, initialLinearDamping * 1000f, submergedVolumePercentage);
            }
        }
    }
}