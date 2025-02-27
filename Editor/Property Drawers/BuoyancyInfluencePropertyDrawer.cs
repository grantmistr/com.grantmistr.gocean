using UnityEditor;
using UnityEngine;

namespace GOcean
{
    [CustomPropertyDrawer(typeof(BuoyancyInfluence))]
    public class BuoyancyInfluencePropertyDrawer : PropertyDrawer
    {
        public const float PROPERTY_HEIGHT = 20f, PADDING_HEIGHT = 3f;
        public const float OFFSET_STEP = PROPERTY_HEIGHT + PADDING_HEIGHT;

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            SerializedProperty iterations = property.FindPropertyRelative("oceanSampler").FindPropertyRelative("iterations");
            SerializedProperty force = property.FindPropertyRelative("force");
            SerializedProperty radius = property.FindPropertyRelative("radius");
            SerializedProperty localPosition = property.FindPropertyRelative("localPosition");

            return EditorGUI.GetPropertyHeight(iterations) + EditorGUI.GetPropertyHeight(force) + EditorGUI.GetPropertyHeight(radius) + EditorGUI.GetPropertyHeight(localPosition) + EditorGUIUtility.singleLineHeight;
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SerializedProperty iterations = property.FindPropertyRelative("oceanSampler").FindPropertyRelative("iterations");
            SerializedProperty force = property.FindPropertyRelative("force");
            SerializedProperty radius = property.FindPropertyRelative("radius");
            SerializedProperty localPosition = property.FindPropertyRelative("localPosition");

            position.y += PADDING_HEIGHT;

            // Iterations
            position.height = EditorGUI.GetPropertyHeight(iterations);
            EditorGUI.PropertyField(position, iterations);

            // Force
            position.y += EditorGUIUtility.singleLineHeight + PADDING_HEIGHT;
            position.height = EditorGUI.GetPropertyHeight(force);
            EditorGUI.PropertyField(position, force);

            // Radius
            position.y += EditorGUIUtility.singleLineHeight + PADDING_HEIGHT;
            position.height = EditorGUI.GetPropertyHeight(radius);
            radius.floatValue = Mathf.Max(radius.floatValue, 0f);
            EditorGUI.PropertyField(position, radius);

            // Local Position
            position.y += EditorGUIUtility.singleLineHeight + PADDING_HEIGHT;
            position.height = EditorGUI.GetPropertyHeight(localPosition);
            EditorGUI.PropertyField(position, localPosition);
        }
    }
}