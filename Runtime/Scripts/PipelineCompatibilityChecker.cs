using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;

namespace GOcean
{
    public static class PipelineCompatibilityChecker
    {
        public static bool IsValid()
        {
            return PipelineSupportCustomPass();
        }

        private static bool PipelineSupportCustomPass()
        {
            HDRenderPipelineAsset a = GraphicsSettings.currentRenderPipeline as HDRenderPipelineAsset;

            if (!a.currentPlatformRenderPipelineSettings.supportCustomPass)
            {
                throw new System.Exception("GOcean requires custom pass be enabled in your HDRP asset.");
            }

            return a.currentPlatformRenderPipelineSettings.supportCustomPass;
        }
    }
}