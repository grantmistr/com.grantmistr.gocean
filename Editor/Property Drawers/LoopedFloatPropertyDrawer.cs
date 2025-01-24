using System.Reflection;
using UnityEditor;
using UnityEngine;

namespace GOcean
{
    [CustomPropertyDrawer(typeof(LoopedFloatAttribute))]
    public class LoopedFloatPropertyDrawer : PropertyDrawer
    {
        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            float max = fieldInfo.GetCustomAttribute<LoopedFloatAttribute>().max;
            if (property.floatValue < 0f)
            {
                property.floatValue = max - (-property.floatValue % max);
            }
            else
            {
                property.floatValue %= max;
            }

            EditorGUI.PropertyField(position, property);
        }
    }
}