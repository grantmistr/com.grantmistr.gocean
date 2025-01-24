using UnityEditor;
using UnityEngine;

namespace GOcean
{
    [CustomEditor(typeof(SimpleFloater))]
    [CanEditMultipleObjects]
    public class SimpleFloaterEditor : Editor
    {
        private const float PROPERTY_HEIGHT = 16f, PADDING_HEIGHT = 4f;
        private const float OFFSET_STEP = PROPERTY_HEIGHT + PADDING_HEIGHT;

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            SerializedProperty prop = serializedObject.GetIterator();
            prop.Next(true);
            prop.NextVisible(false);

            GUI.enabled = false;
            EditorGUILayout.PropertyField(prop);
            GUI.enabled = true;

            EditorGUILayout.LabelField("This script makes an object stick to the water surface.");

            serializedObject.ApplyModifiedProperties();
        }
    }
}