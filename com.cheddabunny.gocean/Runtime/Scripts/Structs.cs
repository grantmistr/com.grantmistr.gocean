using UnityEngine;

namespace GOcean
{
    using static Helper;
    using static ShaderPropertyIDs;

    public enum Resolution
    {
        _128 = 128,
        _256 = 256,
        _512 = 512,
        _1024 = 1024
    }

    public enum PowerTwo
    {
        _1 = 1,
        _2 = 2,
        _4 = 4,
        _8 = 8,
        _16 = 16,
        _32 = 32,
        _64 = 64,
        _128 = 128,
        _256 = 256,
        _512 = 512,
        _1024 = 1024,
        _2048 = 2048,
        _4096 = 4096,
        _8192 = 8192
    }

    public enum MaterialIndex
    {
        ocean = 0,
        distantOcean = 1,
        fullscreen = 2,
        waterScreenMask = 3,
        wireframe = 4
    }

    public enum ComputeShaderIndex
    {
        spectrum = 0,
        terrain = 1,
        underwater = 2,
        mesh = 3
    }

    [System.Serializable]
    public struct PowTwoVector4
    {
        public PowerTwo x;
        public PowerTwo y;
        public PowerTwo z;
        public PowerTwo w;

        public PowTwoVector4(PowerTwo x, PowerTwo y, PowerTwo z, PowerTwo w)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }

        public static implicit operator Vector4(PowTwoVector4 v)
        {
            return new Vector4((float)v.x, (float)v.y, (float)v.z, (float)v.w);
        }
    }

    [System.Serializable]
    public struct PatchScaleRatios
    {
        [Min(1f)]
        public float x;
        [Min(1f)]
        public float y;
        [Min(1f)]
        public float z;
        [Min(1f)]
        public float w;

        public PatchScaleRatios(float x, float y, float z, float w)
        {
            this.x = Mathf.Max(x, 1f);
            this.y = Mathf.Max(y, 1f);
            this.z = Mathf.Max(z, 1f);
            this.w = Mathf.Max(w, 1f);
        }

        public static implicit operator Vector4(PatchScaleRatios v)
        {
            return new Vector4(v.x, v.y, v.z, v.w);
        }
    }

    public struct Matrix2x2
    {
        public float M00;
        public float M01;
        public float M10;
        public float M11;

        static Matrix2x2()
        {
        }

        public Matrix2x2(float x, float y, float z, float w)
        {
            M00 = x;
            M01 = y;
            M10 = z;
            M11 = w;
        }

        public Matrix2x2(float[] r0, float[] r1)
        {
            M00 = r0[0];
            M01 = r0[1];
            M10 = r1[0];
            M11 = r1[1];
        }

        public Matrix2x2(float[] v)
        {
            M00 = v[0];
            M01 = v[1];
            M10 = v[2];
            M11 = v[3];
        }

        public static int SizeOf()
        {
            return sizeof(float) * 4;
        }

        public static Matrix2x2 RotationMatrixFromTheta(float theta)
        {
            float c = Mathf.Cos(theta);
            float s = Mathf.Sin(theta);

            return new Matrix2x2(c, -s, s, c);
        }

        public static Vector2 Mul(Matrix2x2 m, Vector2 v)
        {
            return new Vector2(m.M00 * v.x + m.M01 * v.y, m.M10 * v.x + m.M11 * v.y);
        }

        public static Vector2 operator *(Matrix2x2 m, Vector2 v)
        {
            return new Vector2(m.M00 * v.x + m.M01 * v.y, m.M10 * v.x + m.M11 * v.y);
        }

        public static Matrix2x2 Add(Matrix2x2 m0, Matrix2x2 m1)
        {
            m0.M00 += m1.M00;
            m0.M01 += m1.M01;
            m0.M10 += m1.M10;
            m0.M11 += m1.M11;
            return m0;
        }

        public static Matrix2x2 operator +(Matrix2x2 m0, Matrix2x2 m1)
        {
            m0.M00 += m1.M00;
            m0.M01 += m1.M01;
            m0.M10 += m1.M10;
            m0.M11 += m1.M11;
            return m0;
        }
    }

    public struct Matrix3x3
    {
        private float[,] M;

        public float this[int i, int j]
        {
            get
            {
                return M[i, j];
            }
        }

        public static Matrix3x3 identity = new Matrix3x3(
            1f, 0f, 0f,
            0f, 1f, 0f,
            0f, 0f, 1f
            );

        static Matrix3x3()
        {
        }

        public Matrix3x3(float a, float b, float c, float d, float e, float f, float g, float h, float i)
        {
            M = new float[3, 3];

            M[0, 0] = a;
            M[0, 1] = b;
            M[0, 2] = c;

            M[1, 0] = d;
            M[1, 1] = e;
            M[1, 2] = f;

            M[2, 0] = g;
            M[2, 1] = h;
            M[2, 2] = i;
        }

        public Matrix3x3(float[] r0, float[] r1, float[] r2)
        {
            M = new float[3, 3];

            M[0, 0] = r0[0];
            M[0, 1] = r0[1];
            M[0, 2] = r0[2];

            M[1, 0] = r1[0];
            M[1, 1] = r1[1];
            M[1, 2] = r1[2];

            M[2, 0] = r2[0];
            M[2, 1] = r2[1];
            M[2, 2] = r2[2];
        }

        public Matrix3x3(Vector3 c0, Vector3 c1, Vector3 c2)
        {
            M = new float[3, 3];

            M[0, 0] = c0[0];
            M[1, 0] = c0[1];
            M[2, 0] = c0[2];

            M[0, 1] = c1[0];
            M[1, 1] = c1[1];
            M[2, 1] = c1[2];

            M[0, 2] = c2[0];
            M[1, 2] = c2[1];
            M[2, 2] = c2[2];
        }

        public static Matrix3x3 RotationMatrixFromTheta(float theta)
        {
            float c = Mathf.Cos(theta);
            float s = Mathf.Sin(theta);

            float[] r0 = new float[3];
            float[] r1 = new float[3];
            float[] r2 = new float[3];

            r0[0] = c * c;
            r0[1] = s * s * c - c * s;
            r0[2] = c * s * c + s * s;

            r1[0] = c * s;
            r1[1] = s * s * s + c * c;
            r1[2] = c * s * s - s * c;

            r2[0] = -s;
            r2[1] = s * c;
            r2[2] = c * c;

            return new Matrix3x3(r0, r1, r2);
        }

        public static Vector3 operator * (Matrix3x3 m, Vector3 v)
        {
            Vector3 o;

            o.x = m[0, 0] * v[0] + m[0, 1] * v[1] + m[0, 2] * v[2];
            o.y = m[1, 0] * v[0] + m[1, 1] * v[1] + m[1, 2] * v[2];
            o.z = m[2, 0] * v[0] + m[2, 1] * v[1] + m[2, 2] * v[2];

            return o;
        }
    }

    public struct Vector4Int
    {
        public int x, y, z, w;

        public int this[int i]
        {
            get
            {
                return i switch
                {
                    0 => x,
                    1 => y,
                    2 => z,
                    3 => w,
                    _ => throw new System.Exception("Invalid index."),
                };
            }

            set
            {
                switch (i)
                {
                    case 0:
                        x = value;
                        break;
                    case 1:
                        y = value;
                        break;
                    case 2:
                        z = value;
                        break;
                    case 3:
                        w = value;
                        break;
                    default:
                        throw new System.Exception("Invalid index.");
                }
            }
        }

        static Vector4Int()
        {
        }

        public Vector4Int(int x, int y, int z, int w)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }
    }
}