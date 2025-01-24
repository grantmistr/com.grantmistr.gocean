using UnityEngine;

namespace GOcean
{
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
    }

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
        /// ususally using Monobehavior OnEnable and OnDisable methods.
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