using UnityEditor;
using UnityEngine;

namespace GOcean
{
    [CustomPropertyDrawer(typeof(BuoyancyInfluence))]
    public class BuoyancyInfluencePropertyDrawer : PropertyDrawer
    {
        public const float PROPERTY_HEIGHT = 20f, PADDING_HEIGHT = 4f;
        public const float OFFSET_STEP = PROPERTY_HEIGHT + PADDING_HEIGHT;

        // label field counts as 1, localPosition counts as 4 with its 3 subfields
        public const int PROPERTY_COUNT = 8;

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            SerializedProperty localPosition = property.FindPropertyRelative("localPosition");

            return
                PADDING_HEIGHT + PADDING_HEIGHT
                + (EditorGUIUtility.singleLineHeight + PADDING_HEIGHT) * 4f
                + EditorGUI.GetPropertyHeight(localPosition);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SerializedProperty iterations = property.FindPropertyRelative("oceanSampler").FindPropertyRelative("iterations");
            SerializedProperty force = property.FindPropertyRelative("force");
            SerializedProperty radius = property.FindPropertyRelative("radius");
            SerializedProperty localPosition = property.FindPropertyRelative("localPosition");

            position.y += PADDING_HEIGHT;
            position.height = EditorGUIUtility.singleLineHeight;
            EditorGUI.LabelField(position, label, EditorStyles.boldLabel);

            // Iterations
            position.y += EditorGUIUtility.singleLineHeight + PADDING_HEIGHT;
            EditorGUI.PropertyField(position, iterations);

            // Force
            position.y += EditorGUIUtility.singleLineHeight + PADDING_HEIGHT;
            EditorGUI.PropertyField(position, force);

            // Radius
            position.y += EditorGUIUtility.singleLineHeight + PADDING_HEIGHT;
            radius.floatValue = Mathf.Max(radius.floatValue, 0f);
            EditorGUI.PropertyField(position, radius);

            // Local Position
            position.y += EditorGUIUtility.singleLineHeight + PADDING_HEIGHT;
            position.height = EditorGUI.GetPropertyHeight(localPosition);
            EditorGUI.PropertyField(position, localPosition);
        }
    }
}