using UnityEngine;

namespace GOcean
{
    public enum MaterialIndex
    {
        ocean = 0,
        distantOcean = 1,
        fullscreen = 2,
        waterScreenMask = 3,
        wireframe = 4
    }

    [CreateAssetMenu(fileName = RESOURCE_STRING, menuName = "GOcean/Material Resources", order = 1)]
    [System.Serializable]
    public class MaterialResources : ScriptableObject
    {
        public const string RESOURCE_STRING = "GOcean_MaterialResources";

        [SerializeReference]
        public Material oceanM;
        [SerializeReference]
        public Material distantOceanM;
        [SerializeReference]
        public Material fullscreenM;
        [SerializeReference]
        public Material waterScreenMaskM;
        [SerializeReference]
        public Material wireframeM;

        public Material this[int i]
        {
            get
            {
                return i switch
                {
                    (int)MaterialIndex.ocean => oceanM,
                    (int)MaterialIndex.distantOcean => distantOceanM,
                    (int)MaterialIndex.fullscreen => fullscreenM,
                    (int)MaterialIndex.waterScreenMask => waterScreenMaskM,
                    (int)MaterialIndex.wireframe => wireframeM,
                    _ => throw new System.Exception("Invalid index."),
                };
            }
        }
    }
}