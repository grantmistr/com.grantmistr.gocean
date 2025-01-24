using UnityEngine;
using System.Linq;

namespace GOcean
{
    public class MaterialComputeShaderArrays
    {
        public Material[] Materials { get; private set; } = new Material[0];
        public ComputeShader[] ComputeShaders { get; private set; } = new ComputeShader[0];
        public int[][] KernelIDs { get; private set; } = new int[0][];

        private void AddMaterial(Material material)
        {
            Material[] m = new Material[Materials.Length + 1];
            Materials.CopyTo(m, 0);
            m[Materials.Length] = material;
            Materials = m;
        }

        public void AddMaterials(params Material[] materials)
        {
            for (int i = 0; i < materials.Length; i++)
            {
                if (this.Materials.Contains<Material>(materials[i]))
                {
                    continue;
                }

                AddMaterial(materials[i]);
            }
        }

        public void AddComputeShader(ComputeShader computeShader, params int[] kernelIDs)
        {
            if (ComputeShaders.Contains<ComputeShader>(computeShader))
            {
                return;
            }

            ComputeShader[] cs = new ComputeShader[ComputeShaders.Length + 1];
            ComputeShaders.CopyTo(cs, 0);
            cs[ComputeShaders.Length] = computeShader;
            ComputeShaders = cs;
            
            int[][] k = new int[this.KernelIDs.Length + 1][];
            for (int i = 0; i < this.KernelIDs.Length; i++)
            {
                if (this.KernelIDs[i] != null)
                {
                    k[i] = this.KernelIDs[i];
                }
            }
            k[this.KernelIDs.Length] = kernelIDs;
            this.KernelIDs = k;
        }

        public void AddComputeShaders(ComputeShader[] computeShaders, params int[][] kernelIDs)
        {
            for (int i = 0; i < computeShaders.Length; i++)
            {
                AddComputeShader(computeShaders[i], kernelIDs[i]);
            }
        }

        public void Reset()
        {
            Materials = new Material[0];
            ComputeShaders = new ComputeShader[0];
            KernelIDs = new int[0][];
        }

        public override string ToString()
        {
            string s = "Materials: [";

            for (int i = 0; i < Materials.Length; i++)
            {
                s += Materials[i].name;
                if (i != Materials.Length - 1)
                {
                    s += ", ";
                }
            }

            s += "]\nCompute Shaders:\n";

            for (int i = 0; i < ComputeShaders.Length; i++)
            {
                s += ComputeShaders[i].name + ": [";
                for (int j = 0; j < KernelIDs[i].Length; j++)
                {
                    s += KernelIDs[i][j];
                    if (j != KernelIDs[i].Length - 1)
                    {
                        s += ", ";
                    }
                }
                s += "]\n";
            }

            return s;
        }
    }
}