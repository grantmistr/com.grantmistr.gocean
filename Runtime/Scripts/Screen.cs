using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;
using UnityEngine.Experimental.Rendering;

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;
    using static Helper;

    public class Screen : Component
    {
        [ShaderParam("_ScreenWaterNoiseTexture")]
        public Texture2D screenWaterNoiseTexture;
        [ShaderParam("_ScreenWaterTiling")]
        public float screenWaterTiling;
        [ShaderParam("_ScreenWaterFadeSpeed")]
        public float screenWaterFadeSpeed;

        [ShaderParamGlobal("_OceanScreenTexture")]
        public RTHandle screenTexture;

        private int shaderPassClear, shaderPassScreenMask, shaderPassScreenMaskUnderwaterPyramid, shaderPassHorizontalBlur, shaderPassVerticalBlur,
            shaderPassDepthOnlyOcean, shaderPassDepthOnlyDistantOcean, shaderPassEncodeMasks, shaderPassClearMasks;

        public Screen()
        {
        }

        public override void Initialize()
        {
            InitializeParams(ocean.parametersUser.screen);

            InitializeRTHandles();
            GetShaderPasses();
        }

        public override void ReleaseResources()
        {
            ReleaseTexture(ref screenTexture);
        }

        public override void InitializeParams(BaseParamsUser userParams)
        {
            ScreenParamsUser u = userParams as ScreenParamsUser;

            screenWaterNoiseTexture = u.screenWaterNoiseTexture;
            screenWaterTiling = u.screenWaterTiling;
            screenWaterFadeSpeed = u.screenWaterFadeSpeed;
        }

        public override void SetShaderParams()
        {
            SetKeyword(ocean.WaterScreenMaskM, PropIDs.ShaderKeywords.UNITY_UV_STARTS_AT_TOP, SystemInfo.graphicsUVStartsAtTop);
            SetKeyword(ocean.WaterScreenMaskM, PropIDs.ShaderKeywords.UNITY_REVERSED_Z, SystemInfo.usesReversedZBuffer);

            base.SetShaderParams();
        }

        private void InitializeRTHandles()
        {
            if (screenTexture == null)
            {
                screenTexture = rtHandleSystem.Alloc(
                    Vector2.one,
                    1,
                    DepthBits.None,
                    GraphicsFormat.R8_UInt,
                    FilterMode.Bilinear,
                    TextureWrapMode.Clamp,
                    TextureDimension.Tex2D,
                    true,
                    name: "ScreenTexture"
                );
            }
        }

        private void GetShaderPasses()
        {
            shaderPassClear = ocean.WaterScreenMaskM.FindPass("Clear");
            shaderPassScreenMask = ocean.WaterScreenMaskM.FindPass("ScreenMask");
            shaderPassScreenMaskUnderwaterPyramid = ocean.WaterScreenMaskM.FindPass("UnderwaterPyramid");
            shaderPassEncodeMasks = ocean.WaterScreenMaskM.FindPass("EncodeMasks");
            shaderPassClearMasks = ocean.WaterScreenMaskM.FindPass("ClearMasks");
            shaderPassHorizontalBlur = ocean.WaterScreenMaskM.FindPass("HorizontalBlur");
            shaderPassVerticalBlur = ocean.WaterScreenMaskM.FindPass("VerticalBlur");
            shaderPassDepthOnlyOcean = ocean.WaterScreenMaskM.FindPass("DepthOnlyOcean");
            shaderPassDepthOnlyDistantOcean = ocean.WaterScreenMaskM.FindPass("DepthOnlyDistantOcean");
        }

        /// <summary>
        /// Okay, I definitely can simplify the logic here but w/e. Writes an underwater mask to the R channel of the temp color tex.
        /// The G channel is 1 wherever there is a water surface. Later, write light rays and screen water to G and B channels, then
        /// blur them with the Screen Texture as target.
        /// </summary>
        /// <param name="ctx"></param>
        public void DrawUnderwaterMask(CustomPassContext ctx)
        {
            float delta = ctx.hdCamera.camera.transform.position.y - components.Generic.waterHeight;
            bool deltaCheck = Mathf.Abs(delta) < components.Displacement.maxAmplitude;

            //ctx.propertyBlock.SetTexture(PropIDs.temporaryColorTexture, components.Generic.temporaryColorTexture);

            if (components.Mesh.DrawMesh)
            {
                if (deltaCheck)
                {
                    // set RT to temp color tex and water depth tex, clear all
                    CoreUtils.SetRenderTarget(ctx.cmd, components.Generic.temporaryColorTexture, components.Generic.waterDepthTexture, ClearFlag.All);

                    // distant water depth writes G; stencil ref 4, write mask 4
                    CoreUtils.DrawFullScreen(ctx.cmd, ocean.WaterScreenMaskM, null, shaderPassDepthOnlyDistantOcean);

                    // water mesh double sided pass; writes RG; stencil ref 3, write mask 3
                    ctx.cmd.DrawProceduralIndirect(Matrix4x4.identity, ocean.WaterScreenMaskM, shaderPassScreenMask, MeshTopology.Triangles, components.Mesh.indirectArgsBuffer, (int)Mesh.IndirectArgsOffsetsByte.VERTEX_COUNT);

                    // underwater pyramid; writes R; stencil ref 1, readmask 1, writemask 1, comp greater, pass replace
                    ctx.cmd.DrawProcedural(Matrix4x4.identity, ocean.WaterScreenMaskM, shaderPassScreenMaskUnderwaterPyramid, MeshTopology.Triangles, Mesh.UNDERWATER_MASK_VERTEX_COUNT);
                }
                else
                {
                    // set RT to temp color tex and water depth tex
                    CoreUtils.SetRenderTarget(ctx.cmd, components.Generic.temporaryColorTexture, components.Generic.waterDepthTexture, ClearFlag.None);

                    // clear; R set to 0 or 1 depending on if above or below water
                    ctx.propertyBlock.SetFloat(PropIDs.clearValue, delta > 0f ? 0f : 1f);
                    CoreUtils.DrawFullScreen(ctx.cmd, ocean.WaterScreenMaskM, ctx.propertyBlock, shaderPassClear);

                    // distant water depth writes G; stencil ref 4, write mask 4
                    CoreUtils.DrawFullScreen(ctx.cmd, ocean.WaterScreenMaskM, null, shaderPassDepthOnlyDistantOcean);

                    // water mesh depth stencil writes G; stencil ref 2, write mask 2
                    ctx.cmd.DrawProceduralIndirect(Matrix4x4.identity, ocean.WaterScreenMaskM, shaderPassDepthOnlyOcean, MeshTopology.Triangles, components.Mesh.indirectArgsBuffer, (int)Mesh.IndirectArgsOffsetsByte.VERTEX_COUNT);
                }
            }
            else
            {
                // set RT to temp color tex and water depth tex
                CoreUtils.SetRenderTarget(ctx.cmd, components.Generic.temporaryColorTexture, components.Generic.waterDepthTexture, ClearFlag.None);

                // clear; R set to 0 or 1 depending on if above or below water
                ctx.propertyBlock.SetFloat(PropIDs.clearValue, delta > 0f ? 0f : 1f);
                CoreUtils.DrawFullScreen(ctx.cmd, ocean.WaterScreenMaskM, ctx.propertyBlock, shaderPassClear);

                // distant water depth writes G; stencil ref 4, write mask 4
                CoreUtils.DrawFullScreen(ctx.cmd, ocean.WaterScreenMaskM, null, shaderPassDepthOnlyDistantOcean);
            }

            // set RT to screen tex and water depth tex
            CoreUtils.SetRenderTarget(ctx.cmd, screenTexture, components.Generic.waterDepthTexture, ClearFlag.None);

            // clear ~ cached time bits
            CoreUtils.DrawFullScreen(ctx.cmd, ocean.WaterScreenMaskM, null, shaderPassClearMasks);

            // encode bit masks and fill holes
            CoreUtils.DrawFullScreen(ctx.cmd, ocean.WaterScreenMaskM, null, shaderPassEncodeMasks);
        }

        public void BlurScreenTexture(CustomPassContext ctx)
        {
            // horizontal blur; writes RG to temp color tex
            CoreUtils.SetRenderTarget(ctx.cmd, components.Generic.temporaryColorTexture, ClearFlag.None);
            CoreUtils.DrawFullScreen(ctx.cmd, ocean.WaterScreenMaskM, ctx.propertyBlock, shaderPassHorizontalBlur);

            // vertical blur; writes RG to temp blur tex
            CoreUtils.SetRenderTarget(ctx.cmd, components.Generic.temporaryBlurTexture, ClearFlag.None);
            CoreUtils.DrawFullScreen(ctx.cmd, ocean.WaterScreenMaskM, ctx.propertyBlock, shaderPassVerticalBlur);
        }
    }
}