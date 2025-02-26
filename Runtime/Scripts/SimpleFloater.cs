using UnityEngine;

namespace GOcean
{
    [AddComponentMenu("GOcean/Simple Floater")]
    public class SimpleFloater : MonoBehaviour
    {
        private OceanSampler sampler;

        private void OnEnable()
        {
            if (sampler == null)
            {
                sampler = new OceanSampler(this.transform.position);
            }

            Ocean.OceanSamplers.Add(sampler);
        }

        private void OnDisable()
        {
            Ocean.OceanSamplers.Remove(sampler);
        }

        private void FixedUpdate()
        {
            Vector3 newPos = new Vector3(this.transform.position.x, sampler.outputData.height, this.transform.position.z);
            this.transform.position = newPos;
            sampler.position = newPos;
        }
    }
}