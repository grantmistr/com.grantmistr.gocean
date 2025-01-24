using UnityEngine;

using static GOcean.Helper;

namespace GOcean
{
    [ExecuteAlways]
    [DisallowMultipleComponent]
    [RequireComponent(typeof(UnityEngine.Terrain))]
    [AddComponentMenu("GOcean/Terrain Data")]
    public class TerrainData : MonoBehaviour
    {
        private void OnEnable()
        {
            //GOcean.Instance.Terrain.terrainList.Add(GetComponent<Terrain>());
        }

        private void OnDisable()
        {
            //GOcean.Instance.Terrain.terrainList.Remove(GetComponent<Terrain>());
        }
    }
}