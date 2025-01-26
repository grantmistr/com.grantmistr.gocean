using UnityEngine;

namespace GOcean
{
    public class CapFramerate : MonoBehaviour
    {
        public int frameRate = 60;
        private void Start()
        {
            Application.targetFrameRate = frameRate;
        }
    }
}
