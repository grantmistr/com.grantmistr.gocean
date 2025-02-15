using UnityEngine;
using UnityEditor;

namespace GOcean
{
    [CustomEditor(typeof(Ocean))]
    public class OceanEditor : Editor
    {
        private SerializedProperty parametersUser;
        private Editor parametersUserEditor;
        private Ocean ocean;
        private ComponentContainer components;

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

            GUILayout.Space(14f);

            if (GUILayout.Button("Add TerrainData to all Terrains"))
            {
                components.Terrain.AddTerrainDataToAllTerrains();
            }

            if (GUILayout.Button("Remove TerrainData from all Terrains"))
            {
                components.Terrain.RemoveTerrainDataFromAllTerrains();
            }

            if (GUILayout.Button("Print Mesh Chunks to Console"))
            {
                MeshChunks.MeshChunkArray meshChunkArray = new MeshChunks.MeshChunkArray(true);
                Debug.Log(meshChunkArray.ToString());
            }
        }

        private void UpdatePropertyRefs()
        {
            parametersUser  = serializedObject.FindProperty("parametersUser");
            components      = serializedObject.FindProperty("components").managedReferenceValue as ComponentContainer;
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