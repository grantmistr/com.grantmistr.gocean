using UnityEngine;

namespace GOcean
{
    public enum ComputeShaderIndex
    {
        spectrum = 0,
        terrain = 1,
        underwater = 2,
        mesh = 3
    }

    [CreateAssetMenu(fileName = RESOURCE_STRING, menuName = "GOcean/Compute Shader Resources", order = 1)]
    [System.Serializable]
    public class ComputeShaderResources : ScriptableObject
    {
        public const string RESOURCE_STRING = "GOcean_ComputeShaderResources";

        [SerializeReference]
        public ComputeShader spectrumCS;
        [SerializeReference]
        public ComputeShader terrainCS;
        [SerializeReference]
        public ComputeShader underwaterCS;
        [SerializeReference]
        public ComputeShader meshCS;

        public ComputeShader this[int i]
        {
            get
            {
                return i switch
                {
                    (int)ComputeShaderIndex.spectrum => spectrumCS,
                    (int)ComputeShaderIndex.terrain => terrainCS,
                    (int)ComputeShaderIndex.underwater => underwaterCS,
                    (int)ComputeShaderIndex.mesh => meshCS,
                    _ => throw new System.Exception("Invalid index."),
                };
            }
        }
    }
}