using UnityEditor;
using UnityEditor.Rendering;
using UnityEditor.Rendering.HighDefinition;

namespace GOcean
{
    public class CausticUIBlock : MaterialUIBlock
    {
        private MaterialProperty enableCaustic;
        private new ExpandableBit expandableBit = new ExpandableBit();

        public CausticUIBlock(ExpandableBit expandableBit)
        {
            this.expandableBit = expandableBit;
        }

        public override void LoadMaterialProperties()
        {
            enableCaustic = FindProperty("_EnableCaustic");
        }

        public override void OnGUI()
        {
            MaterialHeaderScope header = new MaterialHeaderScope("Caustic Options", (uint)expandableBit, materialEditor);

            using (header)
            {
                if (header.expanded)
                {
                    materialEditor.ShaderProperty(enableCaustic, "Enable Caustic");
                }
            }
        }
    }
}
