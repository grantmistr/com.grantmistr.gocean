using UnityEngine.Rendering.HighDefinition;
using UnityEngine.Rendering;
using UnityEngine;

// a bunch of functions copied from some unity file

namespace GOcean
{
    class DirectionalLightData
    {
        public void ExtractDirectionalLightData(Light light, Vector2 viewportSize, uint cascadeIndex, int cascadeCount, float[] cascadeRatios, float nearPlaneOffset, CullingResults cullResults, int lightIndex,
                out Matrix4x4 view, out Matrix4x4 invViewProjection, out Matrix4x4 projection, out Matrix4x4 deviceProjection, out Matrix4x4 deviceProjectionYFlip, out ShadowSplitData splitData)
        {
            Vector4 lightDir;

            Debug.Assert((uint)viewportSize.x == (uint)viewportSize.y, "Currently the cascaded shadow mapping code requires square cascades.");
            splitData = new ShadowSplitData();
            splitData.cullingSphere.Set(0.0f, 0.0f, 0.0f, float.NegativeInfinity);
            splitData.cullingPlaneCount = 0;

            // This used to be fixed to .6f, but is now configureable.
            splitData.shadowCascadeBlendCullingFactor = .6f;

            // get lightDir
            lightDir = light.transform.forward;
            // TODO: At some point this logic should be moved to C#, then the parameters cullResults and lightIndex can be removed as well
            //       For directional lights shadow data is extracted from the cullResults, so that needs to be somehow provided here.
            //       Check ScriptableShadowsUtility.cpp ComputeDirectionalShadowMatricesAndCullingPrimitives(...) for details.
            Vector3 ratios = new Vector3();
            for (int i = 0, cnt = cascadeRatios.Length < 3 ? cascadeRatios.Length : 3; i < cnt; i++)
                ratios[i] = cascadeRatios[i];
            cullResults.ComputeDirectionalShadowMatricesAndCullingPrimitives(lightIndex, (int)cascadeIndex, cascadeCount, ratios, (int)viewportSize.x, nearPlaneOffset, out view, out projection, out splitData);
            // and the compound (deviceProjection will potentially inverse-Z)
            deviceProjection = GL.GetGPUProjectionMatrix(projection, false);
            deviceProjectionYFlip = GL.GetGPUProjectionMatrix(projection, true);
            InvertOrthographic(ref deviceProjection, ref view, out invViewProjection);
        }

        private void InvertOrthographic(ref Matrix4x4 proj, ref Matrix4x4 view, out Matrix4x4 vpinv)
        {
            Matrix4x4 invview;
            InvertView(ref view, out invview);

            Matrix4x4 invproj = Matrix4x4.zero;
            invproj.m00 = 1.0f / proj.m00;
            invproj.m11 = 1.0f / proj.m11;
            invproj.m22 = 1.0f / proj.m22;
            invproj.m33 = 1.0f;
            invproj.m03 = proj.m03 * invproj.m00;
            invproj.m13 = proj.m13 * invproj.m11;
            invproj.m23 = -proj.m23 * invproj.m22;

            vpinv = invview * invproj;
        }

        private void InvertView(ref Matrix4x4 view, out Matrix4x4 invview)
        {
            invview = Matrix4x4.zero;
            invview.m00 = view.m00; invview.m01 = view.m10; invview.m02 = view.m20;
            invview.m10 = view.m01; invview.m11 = view.m11; invview.m12 = view.m21;
            invview.m20 = view.m02; invview.m21 = view.m12; invview.m22 = view.m22;
            invview.m33 = 1.0f;
            invview.m03 = -(invview.m00 * view.m03 + invview.m01 * view.m13 + invview.m02 * view.m23);
            invview.m13 = -(invview.m10 * view.m03 + invview.m11 * view.m13 + invview.m12 * view.m23);
            invview.m23 = -(invview.m20 * view.m03 + invview.m21 * view.m13 + invview.m22 * view.m23);
        }

        private Matrix4x4 viewMatrix;
        private Matrix4x4 projMatrix;
        private Matrix4x4 viewProjMatrix;
        private Matrix4x4 deviceProjMatrix;

        public void UpdateMainLightData(CustomPassContext ctx)
        {
            HDShadowSettings shadowSettings = ctx.hdCamera.volumeStack.GetComponent<HDShadowSettings>();

            int splitCount = shadowSettings.cascadeShadowSplitCount.value;

            Vector3 ratios = new Vector3();
            for (int i = 0, count = splitCount < 3 ? splitCount : 3; i < count; i++)
            {
                ratios[i] = shadowSettings.cascadeShadowSplits[i];
            }

            ShadowSplitData shadowSplitData = new ShadowSplitData();
            shadowSplitData.cullingSphere.Set(0.0f, 0.0f, 0.0f, float.NegativeInfinity);
            shadowSplitData.cullingPlaneCount = 0;
            shadowSplitData.shadowCascadeBlendCullingFactor = 0.6f;

            // idk why shadow plane near offset is 3, nor where the value comes from
            ctx.cullingResults.ComputeDirectionalShadowMatricesAndCullingPrimitives(0, 1, splitCount, ratios, 512, 3f, out viewMatrix, out projMatrix, out shadowSplitData);
            deviceProjMatrix = GL.GetGPUProjectionMatrix(projMatrix, false);

            viewProjMatrix = deviceProjMatrix * viewMatrix;
        }
    }
}