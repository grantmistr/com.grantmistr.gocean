using UnityEngine;

namespace GOcean
{
    [System.Serializable]
    public class OceanSampleOutputData
    {
        /// <summary>
        /// Height at position
        /// </summary>
        public float height;

        /// <summary>
        /// Normal vector at position
        /// </summary>
        public Vector3 normal;

        public OceanSampleOutputData()
        {
            height = 0f;
            normal = Vector3.up;
        }

        public OceanSampleOutputData(float height, Vector3 normal)
        {
            this.height = height;
            this.normal = normal;
        }
    }

    [System.Serializable]
    public class OceanSampler
    {
        /// <summary>
        /// Position to sample the ocean
        /// </summary>
        public Vector3 position;

        /// <summary>
        /// Number of iterations used to sample the ocean. Higher iterations will return a more
        /// accurate result. Consider using more iterations for smaller objects.
        /// </summary>
        public uint iterations;

        /// <summary>
        /// Returned ocean sample data
        /// </summary>
        public readonly OceanSampleOutputData outputData = new OceanSampleOutputData();

        /// <summary>
        /// Add and remove this object from the static list of OceanSamplers in GOcean.Ocean,
        /// usually using Monobehavior OnEnable and OnDisable methods.
        /// </summary>
        public OceanSampler()
        {
            this.position = Vector3.zero;
            this.iterations = Physics.HEIGHT_SAMPLE_ITERATIONS;
        }

        /// <summary>
        /// Add and remove this object from the static list of OceanSamplers in GOcean.Ocean,
        /// usually using Monobehavior OnEnable and OnDisable methods.
        /// </summary>
        /// <param name="position"></param>
        /// <param name="iterations"></param>
        public OceanSampler(Vector3 position, uint iterations = Physics.HEIGHT_SAMPLE_ITERATIONS)
        {
            this.position = position;
            this.iterations = iterations;
        }
    }
}