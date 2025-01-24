using UnityEngine;
using System;

namespace GOcean
{
    using static Helper;
    using PropIDs = ShaderPropertyIDs;

    // idk if this class is even necessary, can use the functions in HDMaterial to set diffusion profiles
    public static class DiffusionProfileHelper
    {
        public static void SetDiffusionProfileOnMaterials(Vector4 diffusionProfileVec4GU, float diffusionProfileHash, params Material[] materials)
        {
            foreach (Material m in materials)
            {
                m.SetVector(PropIDs.diffusionProfileAsset, diffusionProfileVec4GU);
                m.SetFloat(PropIDs.diffusionProfile, diffusionProfileHash);
            }
        }

        // COPIED FROM HDUtils
        public static Vector4 ConvertGUIDToVector4(string guid)
        {
            Vector4 vector;
            byte[] bytes = new byte[16];

            for (int i = 0; i < 16; i++)
            {
                bytes[i] = byte.Parse(guid.Substring(i * 2, 2), System.Globalization.NumberStyles.HexNumber);
            }

            vector = new Vector4(
                BitConverter.ToSingle(bytes, 0),
                BitConverter.ToSingle(bytes, 4),
                BitConverter.ToSingle(bytes, 8),
                BitConverter.ToSingle(bytes, 12)
            );

            return vector;
        }

        // Copied from DiffusionProfileHashTable.cs
        public static int MonoStringHash(string guid)
        {
            int hash1 = 5381;
            int hash2 = hash1;

            int i = 0;
            int c;

            while (i < guid.Length)
            {
                c = guid[i];

                hash1 = ((hash1 << 5) + hash1) ^ c;

                i++;

                if (i >= guid.Length)
                {
                    break;
                }

                c = guid[i];

                hash2 = ((hash2 << 5) + hash2) ^ c;

                i++;
            }

            return hash1 + (hash2 * 1566083941);
        }

        // Only copied this function from DiffusionProfileHashTable.cs for now,
        // but probably should just copy them all and iterate through the diffusion
        // profile list, generating all the hashes and handling collisions.
        public static uint GetDiffusionProfileHash(string gui)
        {
            uint hash32 = (uint)MonoStringHash(gui);
            uint mantissa = hash32 & 0x7FFFFF;
            uint exponent = 0b10000000; // 0 as exponent

            // only store the first 23 bits so when the hash is converted to float, it doesn't write into
            // the exponent part of the float (which avoids having NaNs, inf or precisions issues)
            return (exponent << 23) | mantissa;
        }
    }
}