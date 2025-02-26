using UnityEditor;
using UnityEngine;

namespace GOcean
{
    [CustomPropertyDrawer(typeof(BuoyancyInfluence))]
    public class BuoyancyInfluencePropertyDrawer : PropertyDrawer
    {
        public const float PROPERTY_HEIGHT = 19f, PADDING_HEIGHT = 4f;
        public const float OFFSET_STEP = PROPERTY_HEIGHT + PADDING_HEIGHT;

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return OFFSET_STEP * 4f + PADDING_HEIGHT;
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SerializedProperty iterations = property.FindPropertyRelative("oceanSampler").FindPropertyRelative("iterations");
            SerializedProperty force = property.FindPropertyRelative("force");
            SerializedProperty radius = property.FindPropertyRelative("radius");
            SerializedProperty localPosition = property.FindPropertyRelative("localPosition");

            position.height = PROPERTY_HEIGHT;
            position.y += PADDING_HEIGHT;

            // Iterations
            EditorGUI.PropertyField(position, iterations);
            position.y += OFFSET_STEP;

            // Force
            EditorGUI.PropertyField(position, force);
            position.y += OFFSET_STEP;

            // Radius
            property.floatValue = Mathf.Max(property.floatValue, 0f);
            EditorGUI.PropertyField(position, radius);
            position.y += OFFSET_STEP;

            // Local Position
            EditorGUI.PropertyField(position, localPosition);
        }
    }
}