using UnityEditor;
using UnityEngine;

namespace GOcean
{
    [CustomEditor(typeof(MaterialResources))]
    public class MaterialResourcesEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            GUI.enabled = false;

            SerializedProperty prop = serializedObject.GetIterator();
            prop.Next(true);
            prop.NextVisible(false);

            while (prop.NextVisible(false))
            {
                DefaultLayout(prop);
            }

            serializedObject.ApplyModifiedProperties();
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