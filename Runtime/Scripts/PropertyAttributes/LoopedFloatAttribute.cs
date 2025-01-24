using UnityEngine;

namespace GOcean
{
    public class LoopedFloatAttribute : PropertyAttribute
    {
        public float max;

        public LoopedFloatAttribute(float max)
        {
            this.max = max;
            
        }
    }
}