using UnityEditor;
using UnityEngine;

namespace GOcean
{
    [CustomPropertyDrawer(typeof(PatchScaleRatios))]
    public class PatchScaleRatiosDrawer : PropertyDrawer
    {
        private const float PROPERTY_HEIGHT = 16f, PADDING_HEIGHT = 4f;
        private const float OFFSET_STEP = PROPERTY_HEIGHT + PADDING_HEIGHT;

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return EditorGUI.GetPropertyHeight(property);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            Rect controlRect = EditorGUI.PrefixLabel(position, label);

            EditorGUIUtility.labelWidth = 30f;

            property.NextVisible(true);

            float offsetX = 0f;

            for (int i = 0; i < 4; i++)
            {
                Rect propRect = new Rect(controlRect.x + offsetX, controlRect.y, controlRect.width * 0.25f, EditorGUI.GetPropertyHeight(property));
                EditorGUI.PropertyField(propRect, property);

                offsetX += controlRect.width * 0.25f;
                property.NextVisible(false);
            }
        }
    }
}