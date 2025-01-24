using UnityEditor;
using UnityEngine;

namespace GOcean
{
    public class BaseParamsUserDrawer : PropertyDrawer
    {
        private const float PROPERTY_HEIGHT = 16f, PADDING_HEIGHT = 4f;
        private const float OFFSET_STEP = PROPERTY_HEIGHT + PADDING_HEIGHT;

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return EditorGUI.GetPropertyHeight(property);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            Rect foldoutRect = new Rect(position.x, position.y, position.width, PROPERTY_HEIGHT);
            property.isExpanded = EditorGUI.Foldout(foldoutRect, property.isExpanded, label);

            if (property.isExpanded)
            {
                int previousIndentLevel = EditorGUI.indentLevel;
                EditorGUI.indentLevel++;

                int foldoutDepth = property.depth;
                float offset = OFFSET_STEP;

                if (property.NextVisible(true))
                {
                    Rect propRect;

                    do
                    {
                        propRect = new Rect(position.x, position.y + offset, position.width, EditorGUI.GetPropertyHeight(property));
                        EditorGUI.PropertyField(propRect, property);

                        offset += OFFSET_STEP;
                    }
                    while (property.NextVisible(false) && property.depth > foldoutDepth);
                }

                EditorGUI.indentLevel = previousIndentLevel;
            }
        }

        protected void SetManagedReferenceValueIfNull<T>(SerializedProperty property) where T : BaseParamsUser
        {
            if (property.managedReferenceValue == null)
            {
                property.managedReferenceValue = System.Activator.CreateInstance<T>();
            }
        }
    }

    [CustomPropertyDrawer(typeof(GenericParamsUser))]
    public class GenericParamsUserDrawer : BaseParamsUserDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return base.GetPropertyHeight(property, label);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SetManagedReferenceValueIfNull<GenericParamsUser>(property);
            base.OnGUI(position, property, label);
        }
    }

    [CustomPropertyDrawer(typeof(WindParamsUser))]
    public class WindParamsUserDrawer : BaseParamsUserDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return base.GetPropertyHeight(property, label);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SetManagedReferenceValueIfNull<WindParamsUser>(property);
            base.OnGUI(position, property, label);
        }
    }

    [CustomPropertyDrawer(typeof(DisplacementParamsUser))]
    public class DisplacementParamsUserDrawer : BaseParamsUserDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return base.GetPropertyHeight(property, label);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SetManagedReferenceValueIfNull<DisplacementParamsUser>(property);
            base.OnGUI(position, property, label);
        }
    }

    [CustomPropertyDrawer(typeof(SurfaceParamsUser))]
    public class SurfaceParamsUserDrawer : BaseParamsUserDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return base.GetPropertyHeight(property, label);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SetManagedReferenceValueIfNull<SurfaceParamsUser>(property);
            base.OnGUI(position, property, label);
        }
    }

    [CustomPropertyDrawer(typeof(FoamParamsUser))]
    public class FoamParamsUserDrawer : BaseParamsUserDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return base.GetPropertyHeight(property, label);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SetManagedReferenceValueIfNull<FoamParamsUser>(property);
            base.OnGUI(position, property, label);
        }
    }

    [CustomPropertyDrawer(typeof(TerrainParamsUser))]
    public class TerrainParamsUserDrawer : BaseParamsUserDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return base.GetPropertyHeight(property, label);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SetManagedReferenceValueIfNull<TerrainParamsUser>(property);
            base.OnGUI(position, property, label);
        }
    }

    [CustomPropertyDrawer(typeof(ScreenParamsUser))]
    public class ScreenParamsUserDrawer : BaseParamsUserDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return base.GetPropertyHeight(property, label);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SetManagedReferenceValueIfNull<ScreenParamsUser>(property);
            base.OnGUI(position, property, label);
        }
    }

    [CustomPropertyDrawer(typeof(CausticParamsUser))]
    public class CausticParamsUserDrawer : BaseParamsUserDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return base.GetPropertyHeight(property, label);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SetManagedReferenceValueIfNull<CausticParamsUser>(property);
            base.OnGUI(position, property, label);
        }
    }

    [CustomPropertyDrawer(typeof(UnderwaterParamsUser))]
    public class UnderwaterParamsUserDrawer : BaseParamsUserDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return base.GetPropertyHeight(property, label);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SetManagedReferenceValueIfNull<UnderwaterParamsUser>(property);
            base.OnGUI(position, property, label);
        }
    }

    [CustomPropertyDrawer(typeof(MeshParamsUser))]
    public class MeshParamsUserDrawer : BaseParamsUserDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return base.GetPropertyHeight(property, label);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            SetManagedReferenceValueIfNull<MeshParamsUser>(property);

            if (property.isExpanded)
            {
                if (GUILayout.Button("Print Mesh Chunks to Console"))
                {
                    MeshChunks.MeshChunkArray meshChunkArray = new MeshChunks.MeshChunkArray(true);
                    Debug.Log(meshChunkArray.ToString());
                }
            }

            base.OnGUI(position, property, label);
        }
    }
}