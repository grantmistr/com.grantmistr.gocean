using UnityEditor;

namespace GOcean
{
    [CustomEditor(typeof(ParametersUser))]
    public class ParametersUserEditor : Editor
    {
        private Ocean ocean;

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            SerializedProperty prop = serializedObject.GetIterator();
            prop.Next(true);
            prop.NextVisible(false);

            while (prop.NextVisible(false))
            {
                DefaultLayout(prop);
                if (serializedObject.ApplyModifiedProperties())
                {
                    BaseParamsUser p = prop.managedReferenceValue as BaseParamsUser;
                    if (ocean != null && ocean.IsInitialized)
                    {
                        EditorUtility.SetDirty(ocean);
                        p.Update();
                        ocean.UpdateOnDemandDataBuffer();
                        ocean.UpdateConstantDataBuffer();
                    }
                }
            }
        }

        public void SetOcean(Ocean ocean)
        {
            this.ocean = ocean;
        }

        private void DefaultLayout(SerializedProperty property)
        {
            EditorGUILayout.PropertyField(property);
        }

        private void DefaultLayout(params SerializedProperty[] properties)
        {
            foreach (SerializedProperty prop in properties)
            {
                EditorGUILayout.PropertyField(prop);
            }
        }
    }
}
