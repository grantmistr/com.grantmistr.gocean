using UnityEditor;
using UnityEngine;

namespace GOcean
{
    [CustomPropertyDrawer(typeof(PowTwoVector4))]
    public class PowTwoVector4Drawer : PropertyDrawer
    {
        private const float PROPERTY_HEIGHT = 16f, PADDING_HEIGHT = 4f;
        private const float OFFSET_STEP = PROPERTY_HEIGHT + PADDING_HEIGHT;

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return EditorGUI.GetPropertyHeight(property);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            EditorGUI.LabelField(position, label);

            EditorGUIUtility.labelWidth = position.width / 14f;

            float offsetX = 0f;

            property.NextVisible(true);

            for (int i = 0; i < 4; i++)
            {
                Rect propRect;
                propRect = new Rect(position.x + offsetX, position.y, position.width * 0.25f, EditorGUI.GetPropertyHeight(property));
                EditorGUI.PropertyField(propRect, property);

                offsetX += position.width * 0.25f;
                property.NextVisible(false);
            }
        }
    }
}