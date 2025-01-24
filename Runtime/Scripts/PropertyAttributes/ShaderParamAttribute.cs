using UnityEngine;

namespace GOcean
{
    public class ShaderParamAttribute : PropertyAttribute
    {
        public string name;

        public ShaderParamAttribute(string name)
        {
            this.name = name;
        }
    }

    public class ShaderParamGlobalAttribute : ShaderParamAttribute
    {
        public ShaderParamGlobalAttribute(string name) : base(name) { }
    }
}