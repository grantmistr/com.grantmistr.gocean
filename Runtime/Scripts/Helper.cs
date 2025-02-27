using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Rendering;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;

    public static class Helper
    {
        public const float TAU = Mathf.PI * 2f;

        /// <summary>
        /// Bounds centered on origin with size = float.MaxValue
        /// </summary>
        public static readonly Bounds MAX_BOUNDS = new Bounds(Vector3.zero, new Vector3(float.MaxValue, float.MaxValue, float.MaxValue));

        /// <summary>
        /// tiling * 0.001
        /// </summary>
        /// <param name="tiling"></param>
        /// <returns></returns>
        public static float CalculateTiling(float tiling)
        {
            return tiling * 0.001f;
        }

        /// <summary>
        /// XY has a stepped position based on water mesh chunk size.
        /// The stepped camera position is used to calculate the chunk positions,
        /// so that the chunks 'jump' to their proper positions on a grid when the
        /// camera moves. ZW has the camera position modded by chunk size.
        /// </summary>
        /// <param name="camera"></param>
        /// <param name="chunkSize"></param>
        /// <returns>Stepped camera position</returns>
        public static Vector4 CalculateCameraPositionStepped(Camera camera, int chunkSize)
        {
            float stepSize = chunkSize;
            float halfStep = stepSize * 0.5f;

            float x = Mathf.Floor(camera.transform.position.x / stepSize) * stepSize + halfStep;
            float y = Mathf.Floor(camera.transform.position.z / stepSize) * stepSize + halfStep;
            float z = NoNegativeMod(camera.transform.position.x, stepSize) - halfStep;
            float w = NoNegativeMod(camera.transform.position.z, stepSize) - halfStep;

            return new Vector4(x, y, z, w);
        }

        public static Vector4 CalculateZBufferParams(Camera camera)
        {
            float y = camera.farClipPlane / camera.nearClipPlane;
            float x = 1f - y;
            float z = x / camera.farClipPlane;
            float w = y / camera.farClipPlane;

            return new Vector4(x, y, z, w);
        }

        public static float EyeToRawDepth(float depth, Camera camera)
        {
            Vector4 v = CalculateZBufferParams(camera);

            return (1f / depth - v.w) / v.z;
        }

        public static Vector2 CalculateLightPositionScreen(Vector3 lightDirection, Matrix4x4 cameraMatrix)
        {
            Vector4 v = new Vector4(lightDirection.x, lightDirection.y, lightDirection.z, 0f);
            v = cameraMatrix * v;

            Vector2 o = new Vector2(v.x / v.w, v.y / v.w);
            return o;
        }

        public static void CalculateLightRayUVOffset(Camera camera, Vector3 prevCamPos, Vector3 prevCamForward, Transform light, ref Vector2 translate, ref float rotate)
        {
            Vector3 right = camera.transform.right;
            Vector3 up = camera.transform.up;
            Vector3 forward = camera.transform.forward;

            Vector3 dir = camera.transform.position - prevCamPos;
            Vector3 dirNorm = dir.normalized;

            Matrix3x3 lightRotationMatrix = new Matrix3x3(light.right, light.up, light.forward);
            Vector3 forwardLS = lightRotationMatrix * forward;
            Vector3 prevForwardLS = lightRotationMatrix * prevCamForward;

            Vector2 F = new Vector2(forwardLS.x, forwardLS.y);
            Vector2 prevF = new Vector2(prevForwardLS.x, prevForwardLS.y);
            Vector2 prevFRot = Rotate90DegreesCC(prevF);

            const float translateScale = 0.0004f;

            float dotR = Vector3.Dot(right, dir) * translateScale;
            float dotU = Vector3.Dot(up, dir) * translateScale;
            float dotF = Vector3.Dot(forward, dir) * translateScale;

            float verticalOffset = 1f - Mathf.Abs(Vector3.Dot(dirNorm, light.forward));
            verticalOffset *= Vector3.Dot(forward, light.right) > 0f ? -1f : 1f;
            verticalOffset *= dotU;

            translate.x += dotR - verticalOffset - dotF;
            translate.y += dotF - verticalOffset;
            translate.x %= 1f;
            translate.y %= 1f;

            const float rotateScale = 0.1f;

            rotate += Vector2.Dot(F, prevFRot) * -rotateScale;
            rotate %= 1f;
        }

        /// <summary>
        /// scale * 0.001
        /// </summary>
        /// <param name="scale"></param>
        /// <returns></returns>
        public static float CalculateLightRayTranslateScale(float scale)
        {
            return scale * 0.001f;
        }

        /// <summary>
        /// scale * 0.001
        /// </summary>
        /// <param name="scale"></param>
        /// <returns></returns>
        public static float CalculateLightRayRotateScale(float scale)
        {
            return scale * 0.001f;
        }

        /// <summary>
        /// Computes offsets for the light ray compute pass. Requires camera matrix from previous frame.
        /// </summary>
        /// <param name="cameraMatrix"></param>
        /// <param name="prevCameraMatrix"></param>
        /// <param name="light"></param>
        /// <param name="translate"></param>
        /// <param name="rotate"></param>
        public static void CalculateLightRayUVOffset(Matrix4x4 cameraMatrix, Matrix4x4 prevCameraMatrix, Transform light, float translateScale, float rotateScale, ref Vector2 translate, ref float rotate)
        {
            Vector3 right = cameraMatrix.GetColumn(0);
            Vector3 up = cameraMatrix.GetColumn(1);
            Vector3 forward = cameraMatrix.GetColumn(2);

            Vector3 dir = cameraMatrix.GetPosition() - prevCameraMatrix.GetPosition();
            Vector3 dirNorm = dir.normalized;

            Matrix3x3 lightRotationMatrix = new Matrix3x3(light.right, light.up, light.forward);
            Vector3 forwardLS = lightRotationMatrix * forward;
            Vector3 prevForwardLS = lightRotationMatrix * prevCameraMatrix.GetColumn(2);

            Vector2 F = new Vector2(forwardLS.x, forwardLS.y);
            Vector2 prevF = new Vector2(prevForwardLS.x, prevForwardLS.y);
            Vector2 prevFRot = Rotate90DegreesCC(prevF);

            float dotR = Vector3.Dot(right, dir) * translateScale;
            float dotU = Vector3.Dot(up, dir) * translateScale;
            float dotF = Vector3.Dot(forward, dir) * translateScale * 0.5f;
            dotF *= 1f - Mathf.Abs(Vector3.Dot(dirNorm, light.forward));

            Vector3 v = Vector3.Cross(light.forward, Vector3.up).normalized;
            v.x = Mathf.Abs(v.x);
            v.z = Mathf.Abs(v.z);
            v = Vector3.Cross(v, Vector3.up).normalized;

            float verticalOffset = dotU * 0.5f;
            verticalOffset *= Vector3.Dot(forward, light.right) > 0f ? -1f : 1f;
            verticalOffset *= Vector3.Dot(v, light.forward) > 0f ? -1f : 1f;
            verticalOffset *= 1f - Mathf.Abs(Vector3.Dot(dirNorm, light.forward));

            translate.x += dotR - verticalOffset - dotF;
            translate.y += dotF - verticalOffset;
            translate.x %= 1f;
            translate.y %= 1f;

            rotate += Vector2.Dot(F, prevFRot) * -rotateScale;
            rotate %= 1f;
        }

        /// <summary>
        /// Computes offsets for the light ray compute pass. Requires camera matrix from previous frame.
        /// </summary>
        /// <param name="cameraMatrix"></param>
        /// <param name="prevCameraMatrix"></param>
        /// <param name="lightRight"></param>
        /// <param name="lightUp"></param>
        /// <param name="lightForward"></param>
        /// <param name="translate"></param>
        /// <param name="rotate"></param>
        public static void CalculateLightRayUVOffset(Matrix4x4 cameraMatrix, Matrix4x4 prevCameraMatrix, Vector3 lightRight, Vector3 lightUp, Vector3 lightForward, ref Vector2 translate, ref float rotate)
        {
            Vector3 right = cameraMatrix.GetColumn(0);
            Vector3 up = cameraMatrix.GetColumn(1);
            Vector3 forward = cameraMatrix.GetColumn(2);

            Vector3 dir = cameraMatrix.GetPosition() - prevCameraMatrix.GetPosition();
            Vector3 dirNorm = dir.normalized;

            Matrix3x3 lightRotationMatrix = new Matrix3x3(lightRight, lightUp, lightForward);
            Vector3 forwardLS = lightRotationMatrix * forward;
            Vector3 prevForwardLS = lightRotationMatrix * prevCameraMatrix.GetColumn(2);

            Vector2 F = new Vector2(forwardLS.x, forwardLS.y);
            Vector2 prevF = new Vector2(prevForwardLS.x, prevForwardLS.y);
            Vector2 prevFRot = Rotate90DegreesCC(prevF);

            const float translateScale = 0.0004f;

            float dotR = Vector3.Dot(right, dir) * translateScale;
            float dotU = Vector3.Dot(up, dir) * translateScale;
            float dotF = Vector3.Dot(forward, dir) * translateScale;

            float verticalOffset = 1f - Mathf.Abs(Vector3.Dot(dirNorm, lightForward));
            verticalOffset *= Vector3.Dot(forward, lightRight) > 0f ? -1f : 1f;
            verticalOffset *= dotU;

            translate.x += dotR - verticalOffset - dotF;
            translate.y += dotF - verticalOffset;
            translate.x %= 1f;
            translate.y %= 1f;

            const float rotateScale = 0.1f;

            rotate += Vector2.Dot(F, prevFRot) * -rotateScale;
            rotate %= 1f;
        }

        public static void SetKeyword(ref Material material, string keyword, bool value)
        {
            if (value)
            {
                material.EnableKeyword(keyword);
            }
            else
            {
                material.DisableKeyword(keyword);
            }
        }

        public static void SetKeyword(Material material, string keyword, bool value)
        {
            if (value)
            {
                material.EnableKeyword(keyword);
            }
            else
            {
                material.DisableKeyword(keyword);
            }
        }

        public static void SetKeyword(string keyword, bool value, params Material[] materials)
        {
            if (value)
            {
                foreach (Material m in materials)
                {
                    m.EnableKeyword(keyword);
                }
            }
            else
            {
                foreach (Material m in materials)
                {
                    m.DisableKeyword(keyword);
                }
            }
        }

        public static void SetKeyword(ref ComputeShader shader, string keyword, bool value)
        {
            if (value)
            {
                shader.EnableKeyword(keyword);
            }
            else
            {
                shader.DisableKeyword(keyword);
            }
        }

        public static void SetKeyword(ComputeShader shader, string keyword, bool value)
        {
            if (value)
            {
                shader.EnableKeyword(keyword);
            }
            else
            {
                shader.DisableKeyword(keyword);
            }
        }

        /// <summary>
        /// </summary>
        /// <param name="camera"></param>
        /// <returns>rotation around Z axis in radians</returns>
        public static float GetCameraZRotation(Camera camera)
        {
            return camera.transform.rotation.eulerAngles.z / 180f * Mathf.PI;
        }

        // ----- //

        /// <summary>
        /// https://stackoverflow.com/a/3380723
        /// </summary>
        /// <param name="x"></param>
        /// <returns></returns>
        public static float FastArcCos(float x)
        {
            return (-0.69813170079773212f * x * x - 0.87266462599716477f) * x + 1.5707963267948966f;
        }

        public static Vector2 Lerp(Vector2 v0, Vector2 v1, float t)
        {
            Vector2 v = new Vector2(Mathf.Lerp(v0.x, v1.x, t), Mathf.Lerp(v0.y, v1.y, t));
            return v;
        }

        public static Vector2 RotateVector2(Vector2 v, float theta)
        {
            Vector2 output;
            float c = Mathf.Cos(theta);
            float s = Mathf.Sin(theta);

            output.x = v.x * c - v.y * s;
            output.y = v.x * s + v.y * c;

            return output;
        }

        public static Vector2 Rotate180Degrees(Vector2 v)
        {
            v.x = -v.x;
            v.y = -v.y;

            return v;
        }

        public static Vector2 Rotate90DegreesCC(Vector2 v)
        {
            float t = v.x;
            v.x = -v.y;
            v.y = t;

            return v;
        }

        public static Vector2 Rotate90DegreesCW(Vector2 v)
        {
            float t = v.y;
            v.y = -v.x;
            v.x = t;

            return v;
        }

        /// <summary>
        /// Get the min and max values for each channel of a texture.
        /// </summary>
        /// <param name="t"></param>
        /// <param name="min"></param>
        /// <param name="max"></param>
        public static void CalculateTextureMinMax(Texture2D t, out Vector4 min, out Vector4 max)
        {
            if (t == null)
            {
                min = max = Vector4.zero;
                return;
            }

            ComputeShader helperCS = Resources.Load<ComputeShader>("Shaders/ComputeShaders/GOceanHelper");

            int count = t.width;

            ComputeBuffer minBuffer = new ComputeBuffer(count, sizeof(float) * 4);
            ComputeBuffer maxBuffer = new ComputeBuffer(count, sizeof(float) * 4);

            Vector3Int threadGroupSizes = Vector3Int.one;

            int kernel = helperCS.FindKernel("GetMinMax");

            helperCS.GetKernelThreadGroupSizes(kernel, out uint x, out _, out _);
            threadGroupSizes.x = Mathf.CeilToInt(t.width / (float)x);
            threadGroupSizes.y = 1;
            threadGroupSizes.z = 1;

            helperCS.SetTexture(kernel, PropIDs.texture2D, t);
            helperCS.SetBuffer(kernel, PropIDs.minBuffer, minBuffer);
            helperCS.SetBuffer(kernel, PropIDs.maxBuffer, maxBuffer);

            helperCS.Dispatch(kernel, threadGroupSizes.x, threadGroupSizes.y, threadGroupSizes.z);

            Vector4[] minArray = new Vector4[count];
            Vector4[] maxArray = new Vector4[count];

            minBuffer.GetData(minArray);
            maxBuffer.GetData(maxArray);

            min = minArray[0];
            max = maxArray[0];

            for (int i = 1; i < count; i++)
            {
                Vector4 _min = minArray[i];
                Vector4 _max = maxArray[i];

                for (int j = 0; j < 4; j++)
                {
                    min[j] = _min[j] < min[j] ? _min[j] : min[j];
                    max[j] = _max[j] > max[j] ? _max[j] : max[j];
                }
            }

            minBuffer.Dispose();
            maxBuffer.Dispose();

            Resources.UnloadAsset(helperCS);
        }

        public static void CalculateNearClipFrustumPoints(Camera camera, out Vector4 topLeft, out Vector4 topRight, out Vector4 bottomLeft, out Vector4 bottomRight)
        {
            float nearClip = camera.nearClipPlane;
            float aspect = camera.aspect;
            float fov = camera.fieldOfView * (Mathf.PI / 180f);

            float hh = Mathf.Tan(fov / 2f) * nearClip;
            float hw = hh * aspect;

            topLeft = new Vector4(-hw, hh, nearClip, 1f);
            topRight = new Vector4(hw, hh, nearClip, 1f);
            bottomLeft = new Vector4(-hw, -hh, nearClip, 1f);
            bottomRight = new Vector4(hw, -hh, nearClip, 1f);
        }

        public static void CalculateFarClipFrustumPoints(Camera camera, out Vector4 topLeft, out Vector4 topRight, out Vector4 bottomLeft, out Vector4 bottomRight)
        {
            float farClip = camera.farClipPlane;
            float aspect = camera.aspect;
            float fov = camera.fieldOfView * (Mathf.PI / 180f);

            float hh = Mathf.Tan(fov / 2f) * farClip;
            float hw = hh * aspect;

            topLeft = new Vector4(-hw, hh, farClip, 1f);
            topRight = new Vector4(hw, hh, farClip, 1f);
            bottomLeft = new Vector4(-hw, -hh, farClip, 1f);
            bottomRight = new Vector4(hw, -hh, farClip, 1f);
        }

        public static void CalculateFrustumPlanes(Camera camera, out Plane[] outPlane, out Vector4[] outVector)
        {
            outPlane = GeometryUtility.CalculateFrustumPlanes(camera);
            outVector = new Vector4[6];

            for (int i = 0; i < 6; i++)
            {
                outVector[i] = new Vector4(outPlane[i].normal.x, outPlane[i].normal.y, outPlane[i].normal.z, outPlane[i].distance);
            }
        }

        public static void CalculateFrustumPlanes(Camera camera, out Vector4[] outVector)
        {
            Plane[] outPlane = GeometryUtility.CalculateFrustumPlanes(camera);
            outVector = new Vector4[6];

            for (int i = 0; i < 6; i++)
            {
                outVector[i] = new Vector4(outPlane[i].normal.x, outPlane[i].normal.y, outPlane[i].normal.z, outPlane[i].distance);
            }
        }

        public static Vector4 PlaneToVector4(Plane plane)
        {
            return new Vector4(plane.normal.x, plane.normal.y, plane.normal.z, plane.distance);
        }

        public static Matrix4x4 CalculateCameraViewProjectionMatrix(Camera camera)
        {
            return camera.projectionMatrix * camera.worldToCameraMatrix;
        }

        public static Matrix4x4 CalculateCameraInverseViewProjectionMatrix(Camera camera)
        {
            return camera.cameraToWorldMatrix * camera.projectionMatrix.inverse;
        }

        public static Matrix2x2 RotationMatrixWithAspectRatio(float theta, float aspect)
        {
            float c = Mathf.Cos(theta);
            float s = Mathf.Sin(theta);

            return new Matrix2x2(c, s / aspect, -aspect * s, c);
        }

        public static float NoNegativeMod(float v, float x)
        {
            v %= x;
            v = v < 0f ? v + x : v;
            return v;
        }

        public static Vector2 NoNegativeMod(Vector2 v, float x)
        {
            v.x = NoNegativeMod(v.x, x);
            v.y = NoNegativeMod(v.y, x);

            return v;
        }

        public static void InitializeAsCBuffer(ref ComputeBuffer buffer, int size, Array initialData)
        {
            bool create = false;

            if (buffer == null)
            {
                create = true;
            }
            else if (buffer.stride != size || buffer.count != 1)
            {
                buffer.Release();
                create = true;
            }

            if (create)
            {
                buffer = new ComputeBuffer(1, size, ComputeBufferType.Constant);
                buffer.SetData(initialData);
                buffer.name = buffer.ToString();
            }
        }

        public static void ReleaseBuffer(ref ComputeBuffer buffer)
        {
            if (buffer != null)
            {
                buffer.Release();
                buffer = null;
            }
        }

        public static void ReleaseBuffer(ref GraphicsBuffer buffer)
        {
            if (buffer != null)
            {
                buffer.Release();
                buffer = null;
            }
        }

        public static void ReleaseTexture(ref RenderTexture texture)
        {
            if (texture != null)
            {
                texture.Release();
                texture = null;
            }
        }

        public static void ReleaseTexture(ref RTHandle texture)
        {
            if (texture != null)
            {
                texture.Release();
                texture = null;
            }
        }

        public static void ReleaseBufferArray(ref ComputeBuffer[] bufferArray)
        {
            if (bufferArray != null)
            {
                for (int i = 0; i < bufferArray.Length; i++)
                {
                    ReleaseBuffer(ref bufferArray[i]);
                }
            }
        }

        public static void ReleaseRTHandleSystem(ref RTHandleSystem rtHandleSystem)
        {
            if (rtHandleSystem != null)
            {
                rtHandleSystem.Dispose();
                rtHandleSystem = null;
            }
        }

        public static Vector3 ColorToVector3(Color color)
        {
            return new Vector3(color.r, color.g, color.b);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns>random normalized direction vector</returns>
        public static Vector2 GetRandomDirection()
        {
            float x = UnityEngine.Random.value * Mathf.PI * 2f;
            return new Vector2(Mathf.Cos(x), Mathf.Sin(x));
        }

        /// <summary>
        /// Input should be in radians
        /// </summary>
        /// <returns>random normalized direction vector</returns>
        public static Vector2 GetRandomDirectionInRange(float min, float max)
        {
            float x = Mathf.Lerp(min, max, UnityEngine.Random.value);
            return new Vector2(Mathf.Cos(x), Mathf.Sin(x));
        }

        /// <summary>
        /// Find a tiling frequency (that is not 0) for the sin of the dot product of a direction vector and the 
        /// normalized coords of a square texture. Valid range refers to how much one component of the direction
        /// vector can be offset (+ or -) to get a new non-normalized vector that matches the tiling frequency
        /// </summary>
        /// <param name="direction"></param>
        /// <param name="minFrequency"></param>
        /// <param name="maxFrequency"></param>
        /// <param name="validRange"></param>
        /// <param name="updatedDirection"></param>
        /// <returns>frequency</returns>
        public static float CalculateTilingFrequency(Vector2 direction, out Vector2 updatedDirection, float minFrequency = TAU, float maxFrequency = 400f, float validRange = 0.01f, bool progressiveRangeIncrease = true)
        {
            updatedDirection = direction;
            minFrequency = Mathf.Max(TAU, minFrequency);

            if (direction.x == 0f || direction.y == 0f)
            {
                updatedDirection = Vector2.right;
                return Mathf.Ceil(minFrequency / TAU) * TAU;
            }

            float x = Mathf.Abs(direction.x);
            float y = Mathf.Abs(direction.y);

            float min = Mathf.Min(x, y);
            float max = Mathf.Max(x, y);

            Vector2 flip = new Vector2(direction.x < 0f ? -1f : 1f, direction.y < 0f ? -1f : 1f);

            float step = 1f;
            float frequency = step * TAU / min;

            while (true)
            {
                float candidate = Mathf.Round(frequency * max / TAU);
                candidate *= TAU / frequency;

                bool test = Mathf.Abs(max - candidate) < validRange;

                if (test && frequency >= minFrequency)
                {
                    if (x == max)
                    {
                        updatedDirection = new Vector2(candidate * flip.x, direction.y);
                    }
                    else
                    {
                        updatedDirection = new Vector2(direction.x, candidate * flip.y);
                    }
                    return frequency;
                }

                step++;
                frequency = step * TAU / min;

                if (frequency > maxFrequency)
                {
                    if (progressiveRangeIncrease)
                    {
                        validRange *= 2f;
                        step = 1f;
                        frequency = step * TAU / min;
                    }
                    else
                    {
                        break;
                    }
                }
            }

            Debug.Log("Tiling frequency below " + maxFrequency + " not found");

            if (x == max)
            {
                updatedDirection = new Vector2(1f * flip.x, 0f);
            }
            else
            {
                updatedDirection = new Vector2(0f, 1f * flip.y);
            }

            return Mathf.Ceil(minFrequency / TAU) * TAU;
        }

        public static void Clear(this RenderTexture renderTexture, Color color)
        {
            RenderTexture old = RenderTexture.active;
            RenderTexture.active = renderTexture;
            GL.Clear(true, true, color);
            RenderTexture.active = old;

            //CommandBuffer cmd = new CommandBuffer();
            //cmd.SetRenderTarget(renderTexture);
            //cmd.ClearRenderTarget(true, true, color);
            //Graphics.ExecuteCommandBuffer(cmd);
            //cmd.Clear();
            //cmd.Release();
        }

        public static void DispatchCompute(this CommandBuffer commandBuffer, ComputeShader computeShader, int kernelIndex, Vector3Int threadGroups)
        {
            commandBuffer.DispatchCompute(computeShader, kernelIndex, threadGroups.x, threadGroups.y, threadGroups.z);
        }

        public static void SetComputeTextureParam(this CommandBuffer commandBuffer, ComputeShader computeShader, int name, RenderTargetIdentifier rt, params int[] kernelIndices)
        {
            foreach (int kernel in kernelIndices)
            {
                commandBuffer.SetComputeTextureParam(computeShader, kernel, name, rt);
            }
        }

        public static void Dispatch(this ComputeShader computeShader, int kernelIndex, Vector3Int threadGroups)
        {
            computeShader.Dispatch(kernelIndex, threadGroups.x, threadGroups.y, threadGroups.z);
        }

        public static void SetConstantBuffer(int name, ComputeBuffer constantBuffer, int offset, int size, params Material[] materials)
        {
            foreach (Material m in materials)
            {
                m.SetConstantBuffer(name, constantBuffer, offset, size);
            }
        }

        public static void SetConstantBuffer(int name, ComputeBuffer constantBuffer, int offset, int size, params ComputeShader[] computeShaders)
        {
            foreach (ComputeShader cs in computeShaders)
            {
                cs.SetConstantBuffer(name, constantBuffer, offset, size);
            }
        }

        public static void SmartDestroy(UnityEngine.Object obj)
        {
            if (obj == null)
            {
                return;
            }

#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                GameObject.DestroyImmediate(obj);
            }
            else
#endif
            {
                GameObject.Destroy(obj);
            }
        }

        public static void LateUpdateSmartDestroy(UnityEngine.Object obj)
        {
#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                EditorApplication.delayCall += () =>
                {
                    SmartDestroy(obj);
                };
            }
            else
#endif
            {
                SmartDestroy(obj);
            }
        }

        public static void LateUpdateSmartDestroy(UnityEngine.Object obj, Action cleanup)
        {
#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                EditorApplication.delayCall += () =>
                {
                    cleanup?.Invoke();
                    SmartDestroy(obj);
                };
            }
            else
#endif
            {
                cleanup?.Invoke();
                SmartDestroy(obj);
            }
        }

        public static void SmartDestroy(params UnityEngine.Object[] objs)
        {
            foreach (UnityEngine.Object obj in objs)
            {
                SmartDestroy(obj);
            }
        }

        public static void UnloadAssets(params UnityEngine.Object[] objs)
        {
            foreach (UnityEngine.Object obj in objs)
            {
                Resources.UnloadAsset(obj);
            }
        }

        public static IEnumerator WaitForFrames(int frameCount)
        {
            while (frameCount > 0)
            {
                frameCount--;
                yield return null;
            }
        }

        public static Vector3 Multiply(this Vector3 vector, Vector3 v)
        {
            return new Vector3(vector.x * v.x, vector.y * v.y, vector.z * v.z);
        }
    }
}