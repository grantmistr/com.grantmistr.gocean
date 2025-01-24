using UnityEditor;
using UnityEngine;

namespace GOcean
{
    [CustomPropertyDrawer(typeof(DisableInInspectorAttribute))]
    public class DisableInInspectorPropertyDrawer : PropertyDrawer
    {
        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            GUI.enabled = false;
            EditorGUI.PropertyField(position, property);
            GUI.enabled = true;
        }
    }
}