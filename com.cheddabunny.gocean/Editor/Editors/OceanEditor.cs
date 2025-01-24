using UnityEngine;
using UnityEditor;

namespace GOcean
{
    [CustomEditor(typeof(Ocean))]
    public class OceanEditor : Editor
    {
        private SerializedProperty
            parametersUser,
            components;

        private Editor parametersUserEditor;
        private Ocean ocean;

        private void OnEnable()
        {
            UpdatePropertyRefs();
            ocean = target as Ocean;

            Undo.undoRedoPerformed += OnUndoRedoPerformed;
        }

        private void OnDisable()
        {
            Undo.undoRedoPerformed -= OnUndoRedoPerformed;
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            if (parametersUser.objectReferenceValue == null)
            {
                parametersUser.objectReferenceValue = Resources.Load<ParametersUser>(ParametersUser.RESOURCE_STRING);
                Debug.Log("Getting default ocean parameters.");
            }

            DefaultLayout(parametersUser);

            if (parametersUser.objectReferenceValue != null)
            {
                CreateCachedEditor(parametersUser.objectReferenceValue, typeof(ParametersUserEditor), ref parametersUserEditor);
                (parametersUserEditor as ParametersUserEditor).SetOcean(ocean);
                (parametersUserEditor as ParametersUserEditor).SetComponents(components.managedReferenceValue as ComponentContainer);
                parametersUserEditor.OnInspectorGUI();
            }

            if (serializedObject.ApplyModifiedProperties())
            {
                EditorUtility.SetDirty(ocean);
                ocean.Initialize();
            }

            if (GUILayout.Button("Re-Initialize"))
            {
                EditorUtility.SetDirty(ocean);
                ocean.ReInitialize();
            }
        }

        private void UpdatePropertyRefs()
        {
            parametersUser  = serializedObject.FindProperty("parametersUser");
            components      = serializedObject.FindProperty("components");
        }

        private void OnUndoRedoPerformed()
        {
            ocean.Initialize();
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