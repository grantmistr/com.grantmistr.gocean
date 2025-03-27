using System.Reflection;
using System.Linq;
using UnityEngine;
using UnityEngine.Rendering;

namespace GOcean
{
    public static class ShaderParamSetter
    {
        /// <summary>
        /// Do not rely on this method to set CBuffers
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objectWithShaderParams"></param>
        /// <param name="data"></param>
        public static void SetParams<T>(T objectWithShaderParams, MaterialComputeShaderArrays data)
        {
            FieldInfo[] fields = GetShaderParamFields(objectWithShaderParams);

            foreach (FieldInfo fieldInfo in fields)
            {
                GetFieldData(fieldInfo, objectWithShaderParams, out string name, out int id, out object value, out bool global);

                if (value == null)
                {
                    continue;
                }

                if (global)
                {
                    SetGlobalShaderProperty(fieldInfo, name, id, value);
                }
                else
                {
                    foreach (Material material in data.Materials)
                    {
                        SetParamOnMaterial(material, fieldInfo, name, id, value);
                    }
                }

                for (int i = 0; i < data.ComputeShaders.Length; i++)
                {
                    if (!SetParamOnComputeShader(data.ComputeShaders[i], id, value))
                    {
                        SetParamOnComputeShaderKernels(data.ComputeShaders[i], data.KernelIDs[i], fieldInfo, name, id, value);
                    }
                }
            }
        }

        /// <summary>
        /// Do not rely on this method to set CBuffers
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objectWithShaderParams"></param>
        /// <param name="material"></param>
        public static void SetParams<T>(T objectWithShaderParams, Material material)
        {
            FieldInfo[] fields = GetShaderParamFields(objectWithShaderParams);

            foreach(FieldInfo fieldInfo in fields)
            {
                GetFieldData(fieldInfo, objectWithShaderParams, out string name, out int id, out object value, out bool global);

                if (value == null)
                {
                    continue;
                }

                if (global)
                {
                    SetGlobalShaderProperty(fieldInfo, name, id, value);
                    continue;
                }

                SetParamOnMaterial(material, fieldInfo, name, id, value);
            }
        }

        /// <summary>
        /// Do not rely on this method to set CBuffers
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objectWithShaderParams"></param>
        /// <param name="materials"></param>
        public static void SetParams<T>(T objectWithShaderParams, Material[] materials)
        {
            FieldInfo[] fields = GetShaderParamFields(objectWithShaderParams);

            foreach (FieldInfo fieldInfo in fields)
            {
                GetFieldData(fieldInfo, objectWithShaderParams, out string name, out int id, out object value, out bool global);

                if (value == null)
                {
                    continue;
                }

                if (global)
                {
                    SetGlobalShaderProperty(fieldInfo, name, id, value);
                    continue;
                }

                foreach (Material material in materials)
                {
                    SetParamOnMaterial(material, fieldInfo, name, id, value);
                }
            }
        }
        
        private static void SetParamOnMaterial(Material material, FieldInfo fieldInfo, string name, int id, object value)
        {
            switch (value)
            {
                case bool b:
                    material.SetInt(id, b ? 1 : 0);
                    break;
                case int i:
                    material.SetInt(id, i); // SetInteger throws error for some reason
                    break;
                case uint i:
                    material.SetInt(id, (int)i);
                    break;
                case float f:
                    material.SetFloat(id, f);
                    break;
                case Vector2 v:
                    material.SetVector(id, v);
                    break;
                case Vector2Int v:
                    material.SetVector(id, new Vector2(v.x, v.y));
                    break;
                case Vector3 v:
                    material.SetVector(id, v);
                    break;
                case Vector3Int v:
                    material.SetVector(id, new Vector3(v.x, v.y, v.z));
                    break;
                case Vector4 v:
                    material.SetVector(id, v);
                    break;
                case Vector4Int v:
                    material.SetVector(id, new Vector4(v.x, v.y, v.z, v.w));
                    break;
                case Vector4[] vectors:
                    material.SetVectorArray(id, vectors);
                    break;
                case Matrix4x4 m:
                    material.SetMatrix(id, m);
                    break;
                case Matrix4x4[] matrices:
                    material.SetMatrixArray(id, matrices);
                    break;
                case Color c:
                    material.SetColor(id, c);
                    break;
                case Color[] colors:
                    material.SetColorArray(id, colors);
                    break;
                case RenderTexture t:
                    material.SetTexture(id, t);
                    break;
                case Texture t:
                    material.SetTexture(id, t);
                    break;
                case RTHandle t:
                    material.SetTexture(id, t);
                    break;
                case ComputeBuffer b:
                    material.SetBuffer(id, b);
                    break;
                case GraphicsBuffer b:
                    material.SetBuffer(id, b);
                    break;
                default:
                    Debug.LogError(
                        $"Unsupported material type: " +
                        $"{name} of type {fieldInfo.FieldType}");
                    break;
            }
        }

        /// <summary>
        /// Do not rely on this method to set CBuffers
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objectWithShaderParams"></param>
        /// <param name="cs"></param>
        /// <param name="kernel"></param>
        public static void SetParams<T>(T objectWithShaderParams, ComputeShader cs, int kernel)
        {
            FieldInfo[] fields = GetShaderParamFields(objectWithShaderParams);

            foreach (FieldInfo fieldInfo in fields)
            {
                GetFieldData(fieldInfo, objectWithShaderParams, out string name, out int id, out object value, out bool global);

                if (value == null)
                {
                    continue;
                }

                SetParamOnComputeShader(cs, kernel, fieldInfo, name, id, value);
            }
        }

        /// <summary>
        /// Do not rely on this method to set CBuffers
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objectWithShaderParams"></param>
        /// <param name="cs"></param>
        /// <param name="kernelIDs"></param>
        public static void SetParams<T>(T objectWithShaderParams, ComputeShader cs, int[] kernelIDs)
        {
            FieldInfo[] fields = GetShaderParamFields(objectWithShaderParams);

            foreach (FieldInfo fieldInfo in fields)
            {
                GetFieldData(fieldInfo, objectWithShaderParams, out string name, out int id, out object value, out bool global);

                if (value == null)
                {
                    continue;
                }

                if (!SetParamOnComputeShader(cs, id, value))
                {
                    SetParamOnComputeShaderKernels(cs, kernelIDs, fieldInfo, name, id, value);
                }
            }
        }

        /// <summary>
        /// Do not rely on this method to set CBuffers
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objectWithShaderParams"></param>
        /// <param name="computeShaders"></param>
        /// <param name="kernelIDs"></param>
        public static void SetParams<T>(T objectWithShaderParams, ComputeShader[] computeShaders, int[][] kernelIDs)
        {
            FieldInfo[] fields = GetShaderParamFields(objectWithShaderParams);

            foreach (FieldInfo fieldInfo in fields)
            {
                GetFieldData(fieldInfo, objectWithShaderParams, out string name, out int id, out object value, out bool global);

                if (value == null)
                {
                    continue;
                }

                for (int i = 0; i < computeShaders.Length; i++)
                {
                    if (!SetParamOnComputeShader(computeShaders[i], id, value))
                    {
                        SetParamOnComputeShaderKernels(computeShaders[i], kernelIDs[i], fieldInfo, name, id, value);
                    }
                }
            }
        }

        private static void SetParamOnComputeShader(ComputeShader cs, int kernel, FieldInfo fieldInfo, string name, int id, object value)
        {
            switch (value)
            {
                case bool b:
                    cs.SetBool(id, b);
                    break;
                case int i:
                    cs.SetInt(id, i);
                    break;
                case uint i:
                    cs.SetInt(id, (int)i);
                    break;
                case int[] ints:
                    cs.SetInts(id, ints);
                    break;
                case float f:
                    cs.SetFloat(id, f);
                    break;
                case Vector2 v:
                    cs.SetVector(id, v);
                    break;
                case Vector2Int v:
                    cs.SetVector(id, new Vector2(v.x, v.y));
                    break;
                case Vector3 v:
                    cs.SetVector(id, v);
                    break;
                case Vector3Int v:
                    cs.SetVector(id, new Vector3(v.x, v.y, v.z));
                    break;
                case Vector4 v:
                    cs.SetVector(id, v);
                    break;
                case Vector4Int v:
                    cs.SetVector(id, new Vector4(v.x, v.y, v.z, v.w));
                    break;
                case Vector4[] vectors:
                    cs.SetVectorArray(id, vectors);
                    break;
                case Matrix4x4 m:
                    cs.SetMatrix(id, m);
                    break;
                case Matrix4x4[] matrices:
                    cs.SetMatrixArray(id, matrices);
                    break;
                case Color c:
                    cs.SetVector(id, c); // will this automatically linearize?
                    break;
                case Color[] colors:
                    cs.SetVectorArray(id, colors.Select(c => new Vector4(c.linear.r, c.linear.g, c.linear.b, c.linear.a)).ToArray());
                    break;
                case RenderTexture t:
                    cs.SetTexture(kernel, id, t);
                    break;
                case Texture t:
                    cs.SetTexture(kernel, id, t);
                    break;
                case RTHandle t:
                    cs.SetTexture(kernel, id, t);
                    break;
                case ComputeBuffer b:
                    cs.SetBuffer(kernel, id, b);
                    break;
                case GraphicsBuffer b:
                    cs.SetBuffer(kernel, id, b);
                    break;
                default:
                    Debug.LogError(
                        $"Unsupported compute shader type: " +
                        $"{name} of type {fieldInfo.FieldType}");
                    break;
            }
        }

        /// <summary>
        /// </summary>
        /// <param name="cs"></param>
        /// <param name="id"></param>
        /// <param name="value"></param>
        /// <returns>
        /// True if a non kernel specific param was set
        /// </returns>
        private static bool SetParamOnComputeShader(ComputeShader cs, int id, object value)
        {
            bool paramSet = true;

            switch (value)
            {
                case bool b:
                    cs.SetBool(id, b);
                    break;
                case int i:
                    cs.SetInt(id, i);
                    break;
                case uint i:
                    cs.SetInt(id, (int)i);
                    break;
                case int[] ints:
                    cs.SetInts(id, ints);
                    break;
                case float f:
                    cs.SetFloat(id, f);
                    break;
                case Vector2 v:
                    cs.SetVector(id, v);
                    break;
                case Vector2Int v:
                    cs.SetVector(id, new Vector2(v.x, v.y));
                    break;
                case Vector3 v:
                    cs.SetVector(id, v);
                    break;
                case Vector3Int v:
                    cs.SetVector(id, new Vector3(v.x, v.y, v.z));
                    break;
                case Vector4 v:
                    cs.SetVector(id, v);
                    break;
                case Vector4Int v:
                    cs.SetVector(id, new Vector4(v.x, v.y, v.z, v.w));
                    break;
                case Vector4[] vectors:
                    cs.SetVectorArray(id, vectors);
                    break;
                case Matrix4x4 m:
                    cs.SetMatrix(id, m);
                    break;
                case Matrix4x4[] matrices:
                    cs.SetMatrixArray(id, matrices);
                    break;
                case Color c:
                    cs.SetVector(id, c); // will this automatically linearize?
                    break;
                case Color[] colors:
                    cs.SetVectorArray(id, colors.Select(c => new Vector4(c.linear.r, c.linear.g, c.linear.b, c.linear.a)).ToArray());
                    break;
                default:
                    paramSet = false;
                    break;
            }

            return paramSet;
        }

        private static void SetParamOnComputeShaderKernels(ComputeShader cs, int[] kernels, FieldInfo fieldInfo, string name, int id, object value)
        {
            switch (value)
            {
                case RenderTexture t:
                    break;
                case Texture t:
                    break;
                case RTHandle t:
                    break;
                case ComputeBuffer b:
                    break;
                case GraphicsBuffer b:
                    break;
                default:
                    Debug.LogError(
                        $"Unsupported compute shader type: " +
                        $"{name} of type {fieldInfo.FieldType}");
                    return;
            }

            foreach (int index in kernels)
            {
                switch (value)
                {
                    case RenderTexture t:
                        if (t != null)
                        {
                            cs.SetTexture(index, id, t);
                        }
                        break;
                    case Texture t:
                        if (t != null)
                        {
                            cs.SetTexture(index, id, t);
                        }
                        break;
                    case RTHandle t:
                        if (t != null)
                        {
                            cs.SetTexture(index, id, t);
                        }
                        break;
                    case ComputeBuffer b:
                        if (b != null)
                        {
                            cs.SetBuffer(index, id, b);
                        }
                        break;
                    case GraphicsBuffer b:
                        if (b != null)
                        {
                            cs.SetBuffer(index, id, b);
                        }
                        break;
                    default:
                        break;
                }
            }
        }

        private static void SetGlobalShaderProperty(FieldInfo fieldInfo, string name, int id, object value)
        {
            switch (value)
            {
                case bool b:
                    Shader.SetGlobalInteger(id, b ? 1 : 0);
                    break;
                case int i:
                    Shader.SetGlobalInteger(id, i);
                    break;
                case uint i:
                    Shader.SetGlobalInteger(id, (int)i);
                    break;
                case float f:
                    Shader.SetGlobalFloat(id, f);
                    break;
                case Vector2 v:
                    Shader.SetGlobalVector(id, v);
                    break;
                case Vector2Int v:
                    Shader.SetGlobalVector(id, new Vector2(v.x, v.y));
                    break;
                case Vector3 v:
                    Shader.SetGlobalVector(id, v);
                    break;
                case Vector3Int v:
                    Shader.SetGlobalVector(id, new Vector3(v.x, v.y, v.z));
                    break;
                case Vector4 v:
                    Shader.SetGlobalVector(id, v);
                    break;
                case Vector4Int v:
                    Shader.SetGlobalVector(id, new Vector4(v.x, v.y, v.z, v.w));
                    break;
                case Vector4[] vectors:
                    Shader.SetGlobalVectorArray(id, vectors);
                    break;
                case Matrix4x4 m:
                    Shader.SetGlobalMatrix(id, m);
                    break;
                case Matrix4x4[] matrices:
                    Shader.SetGlobalMatrixArray(id, matrices);
                    break;
                case Color c:
                    Shader.SetGlobalColor(id, c);
                    break;
                case Color[] colors:
                    Shader.SetGlobalVectorArray(id, colors.Select(c => new Vector4(c.linear.r, c.linear.g, c.linear.b, c.linear.a)).ToArray());
                    break;
                case RenderTexture t:
                    Shader.SetGlobalTexture(id, t);
                    break;
                case Texture t:
                    Shader.SetGlobalTexture(id, t);
                    break;
                case RTHandle t:
                    Shader.SetGlobalTexture(id, t);
                    break;
                case ComputeBuffer b:
                    Shader.SetGlobalBuffer(id, b);
                    break;
                case GraphicsBuffer b:
                    Shader.SetGlobalBuffer(id, b);
                    break;
                default:
                    Debug.LogError(
                        $"Unsupported global type: " +
                        $"{name} of type {fieldInfo.FieldType}");
                    break;
            }
        }

        private static FieldInfo[] GetShaderParamFields<T>(T objectWithShaderParams)
        {
            return objectWithShaderParams.GetType()
                .GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static)
                .Where(field => field.IsDefined(typeof(ShaderParamAttribute)))
                .ToArray();
        }

        private static void GetFieldData<T>(FieldInfo fieldInfo, T objectWithShaderParams, out string name, out int id, out object value, out bool global)
        {
            ShaderParamAttribute shaderParam = fieldInfo.GetCustomAttribute<ShaderParamAttribute>();

            name = shaderParam.name;
            name = string.IsNullOrWhiteSpace(name) ? fieldInfo.Name : name;
            id = Shader.PropertyToID(name);
            value = fieldInfo.GetValue(objectWithShaderParams);
            global = shaderParam is ShaderParamGlobalAttribute;
        }

        public static void ReapplyProperties(Material material)
        {
            Shader shader = material.shader;
            int shaderPropCount = shader.GetPropertyCount();

            for (int i = 0; i < shaderPropCount; i++)
            {
                int prop = shader.GetPropertyNameId(i);
                ShaderPropertyType propType = shader.GetPropertyType(i);
                switch (propType)
                {
                    case ShaderPropertyType.Color:
                        Color color = material.GetColor(prop);
                        material.SetColor(prop, color);
                        break;
                    case ShaderPropertyType.Vector:
                        Vector4 vector = material.GetVector(prop);
                        material.SetVector(prop, vector);
                        break;
                    case ShaderPropertyType.Float:
                    case ShaderPropertyType.Range:
                        float floatVal = material.GetFloat(prop);
                        material.SetFloat(prop, floatVal);
                        break;
                    case ShaderPropertyType.Int:
                        int intVal = material.GetInteger(prop);
                        material.SetInteger(prop, intVal);
                        break;
                    case ShaderPropertyType.Texture:
                    default:
                        break;

                }
            }
        }
    }
}