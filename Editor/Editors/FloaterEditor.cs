using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEditorInternal;
using UnityEngine;

namespace GOcean
{
    [CustomEditor(typeof(Floater))]
    [CanEditMultipleObjects]
    public class FloaterEditor : Editor
    {
        private const string EDITOR_PREFS_STRING_KEY = "GOCEAN_FLOATER_EDITOR_";
        private static Color UNSELECTED_COLOR = new Color(0.1f, 0.5f, 0.7f, 0.2f);
        private static Color SELECTED_COLOR = new Color(0.7f, 0.2f, 0.1f, 0.8f);

        private Floater floater;
        private SerializedProperty buoyancyInfluences;
        private ReorderableList buoyancyInfluencesList;
        private bool prevToolHiddenState;
        private uint iterations;
        private float force;
        private float radius;

        private List<int> selectedBuoyancyInfluences = new List<int>();

        private void OnEnable()
        {
            floater = target as Floater;

            GetPropertyReferences();
            LoadData();
            SetupBuoyancyInfluencesList();

            Selection.selectionChanged += OnSelectionChanged;

            prevToolHiddenState = Tools.hidden;
        }

        private void OnDisable()
        {
            SaveData();
            CleanupBuoyancyInfluencesList();

            Selection.selectionChanged -= OnSelectionChanged;

            Tools.hidden = prevToolHiddenState;
        }

        private void GetPropertyReferences()
        {
            buoyancyInfluences = serializedObject.FindProperty("buoyancyInfluences");
        }

        private void LoadData()
        {
            iterations = (uint)EditorPrefs.GetInt($"{EDITOR_PREFS_STRING_KEY}iterations", 0);
            force = EditorPrefs.GetFloat($"{EDITOR_PREFS_STRING_KEY}force", 1f);
            radius = EditorPrefs.GetFloat($"{EDITOR_PREFS_STRING_KEY}radius", 1f);
        }

        private void SaveData()
        {
            EditorPrefs.SetInt($"{EDITOR_PREFS_STRING_KEY}iterations", (int)iterations);
            EditorPrefs.SetFloat($"{EDITOR_PREFS_STRING_KEY}force", force);
            EditorPrefs.SetFloat($"{EDITOR_PREFS_STRING_KEY}radius", radius);
        }

        private void SetupBuoyancyInfluencesList()
        {
            if (targets.Length != 1)
            {
                return;
            }

            if (buoyancyInfluencesList == null)
            {
                buoyancyInfluencesList = new ReorderableList(serializedObject, buoyancyInfluences);
            }

            buoyancyInfluencesList.drawElementCallback += DrawBuoyancyInfluencesListElement;
            buoyancyInfluencesList.elementHeightCallback += GetDrawBuoyancyInfluencesListElementHeight;
            buoyancyInfluencesList.drawHeaderCallback += DrawBuoyancyInfluencesListHeader;
            buoyancyInfluencesList.onSelectCallback += OnBuoyancyInfluencesListSelect;
        }

        private void CleanupBuoyancyInfluencesList()
        {
            if (targets.Length != 1)
            {
                return;
            }

            buoyancyInfluencesList.drawElementCallback -= DrawBuoyancyInfluencesListElement;
            buoyancyInfluencesList.elementHeightCallback -= GetDrawBuoyancyInfluencesListElementHeight;
            buoyancyInfluencesList.drawHeaderCallback -= DrawBuoyancyInfluencesListHeader;
        }

        private void OnSelectionChanged()
        {
            selectedBuoyancyInfluences.Clear();
        }

        private void DrawBuoyancyInfluencesListHeader(Rect rect)
        {
            EditorGUI.LabelField(rect, "Buoyancy Influences");
        }

        private float GetDrawBuoyancyInfluencesListElementHeight(int index)
        {
            SerializedProperty property = buoyancyInfluencesList.serializedProperty.GetArrayElementAtIndex(index);
            return EditorGUI.GetPropertyHeight(property);
        }

        private void DrawBuoyancyInfluencesListElement(Rect rect, int index, bool isActive, bool isFocused)
        {
            SerializedProperty property = buoyancyInfluencesList.serializedProperty.GetArrayElementAtIndex(index);
            EditorGUI.PropertyField(rect, property);
        }

        private void OnBuoyancyInfluencesListSelect(ReorderableList list)
        {
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            using (new GUILayout.HorizontalScope())
            {
                bool update = GUILayout.Button("Set Iterations", GUILayout.Width(200f));
                iterations = (uint)EditorGUILayout.IntField((int)iterations);
                if (update)
                {
                    for (int i = 0; i < buoyancyInfluencesList.count; i++)
                    {
                        buoyancyInfluencesList.serializedProperty.GetArrayElementAtIndex(i).FindPropertyRelative("oceanSampler").FindPropertyRelative("iterations").uintValue = iterations;
                    }
                }
            }
            using (new GUILayout.HorizontalScope())
            {
                bool update = GUILayout.Button("Set Force", GUILayout.Width(200f));
                force = EditorGUILayout.FloatField(force);
                if (update)
                {
                    for (int i = 0; i < buoyancyInfluencesList.count; i++)
                    {
                        buoyancyInfluencesList.serializedProperty.GetArrayElementAtIndex(i).FindPropertyRelative("force").floatValue = force;
                    }
                }
            }
            using (new GUILayout.HorizontalScope())
            {
                bool update = GUILayout.Button("Set Radius", GUILayout.Width(200f));
                radius = EditorGUILayout.FloatField(radius);
                if (update)
                {
                    for (int i = 0; i < buoyancyInfluencesList.count; i++)
                    {
                        buoyancyInfluencesList.serializedProperty.GetArrayElementAtIndex(i).FindPropertyRelative("radius").floatValue = radius;
                    }
                }
            }

            if (targets.Length == 1)
            {
                buoyancyInfluencesList.DoLayoutList();
            }

            serializedObject.ApplyModifiedProperties();
        }

        /// <param name="floater"></param>
        /// <param name="floaterTransform"></param>
        /// <param name="selectedBuoyancyInfluences"></param>
        /// <returns>
        /// True if any buoyancy influences on this floater are selected.
        /// </returns>
        public bool DrawBuoyancyInfluences(Floater floater, Transform floaterTransform, List<int> selectedBuoyancyInfluences, bool anyBuoyancyInfluenceSelected, bool singleObjectSelected)
        {
            for (int i = 0; i < floater.buoyancyInfluences.Length; i++)
            {
                BuoyancyInfluence bInfluence = floater.buoyancyInfluences[i];

                Vector3 worldPosition = floaterTransform.localToWorldMatrix.MultiplyPoint(bInfluence.GetLocalPosition());
                float radius = bInfluence.GetRadius();
                float diameter = radius * 2f;

                bool isSelected = selectedBuoyancyInfluences.Contains(i);

                if (isSelected)
                {
                    Handles.color = SELECTED_COLOR;
                }
                else
                {
                    Handles.color = UNSELECTED_COLOR;
                }

                // add / remove buoyancy influences to / from selected influences list
                if (Handles.Button(worldPosition, Quaternion.identity, diameter, radius, Handles.SphereHandleCap))
                {
                    if (!Event.current.shift)
                    {
                        selectedBuoyancyInfluences.Clear();
                        selectedBuoyancyInfluences.Add(i);

                        if (singleObjectSelected)
                        {
                            buoyancyInfluencesList.ClearSelection();
                            buoyancyInfluencesList.Select(i);
                            Repaint();
                        }

                        return true;
                    }
                    else
                    {
                        if (isSelected)
                        {
                            selectedBuoyancyInfluences.Remove(i);

                            if (singleObjectSelected)
                            {
                                buoyancyInfluencesList.Deselect(i);
                                Repaint();
                            }

                            return selectedBuoyancyInfluences.Count > 0;
                        }
                        else
                        {
                            selectedBuoyancyInfluences.Add(i);

                            if (singleObjectSelected)
                            {
                                buoyancyInfluencesList.Select(i, true);
                                Repaint();
                            }

                            return true;
                        }
                    }
                }
            }

            return anyBuoyancyInfluenceSelected;
        }

        private void DrawTransformHandlesAndUpdateValues(Floater floater, Transform floaterTransform, bool anyBuoyancyInfluenceSelected)
        {
            if (!anyBuoyancyInfluenceSelected)
            {
                return;
            }

            BuoyancyInfluence bInfluence = floater.buoyancyInfluences[selectedBuoyancyInfluences[selectedBuoyancyInfluences.Count - 1]];
            Vector3 localPosition = bInfluence.GetLocalPosition();
            Vector3 worldPosition = floaterTransform.localToWorldMatrix.MultiplyPoint(localPosition);
            float radius = bInfluence.GetRadius();

            switch (Tools.current)
            {
                case Tool.Move:
                    Vector3 newPosition = Handles.PositionHandle(worldPosition, floaterTransform.rotation);
                    if (newPosition != worldPosition)
                    {
                        Undo.RecordObject(target, "Move Buoyancy Object");
                        Vector3 newLocalPosition = floaterTransform.worldToLocalMatrix.MultiplyPoint(newPosition);
                        Vector3 localPositionDelta = newLocalPosition - localPosition;

                        foreach (int i in selectedBuoyancyInfluences)
                        {
                            BuoyancyInfluence b = floater.buoyancyInfluences[i];
                            Vector3 v = b.GetLocalPosition() + localPositionDelta;
                            b.SetLocalPosition(v);
                            b.UpdateWorldPosition(floaterTransform.localToWorldMatrix);
                        }
                    }
                    break;
                case Tool.Scale:
                    Handles.color = Handles.centerColor;
                    float newRadius = Handles.ScaleValueHandle(radius, worldPosition, floaterTransform.rotation, HandleUtility.GetHandleSize(worldPosition), Handles.CubeHandleCap, 0f);
                    if (newRadius != radius)
                    {
                        Undo.RecordObject(target, "Scale Buoyancy Object");
                        bInfluence.SetRadius(Mathf.Max(newRadius, 0f));

                        foreach (int i in selectedBuoyancyInfluences)
                        {
                            BuoyancyInfluence b = floater.buoyancyInfluences[i];
                            b.SetRadius(newRadius);
                        }
                    }
                    break;
                default:
                    break;
            }
        }

        private void OnSceneGUI()
        {
            Floater floater = target as Floater;
            Transform floaterTransform = floater.transform;

            bool isActiveObject = Selection.activeGameObject == floater.gameObject;
            
            if (!isActiveObject)
            {
                return;
            }

            bool mouseUp = Event.current.type == EventType.MouseUp;
            bool mouseDrag = Event.current.type == EventType.MouseDrag;
            bool mouseButtonLeft = Event.current.button == 0;
            bool anyBuoyancyInfluenceSelected = selectedBuoyancyInfluences.Count > 0;

            // whenever a single floater object is selected, update the editor GUI selection
            bool singleObjectSelected = Selection.count == 1;

            if (anyBuoyancyInfluenceSelected)
            {
                // this makes 'clicking off' of a buoyancy influence first select the floater object it is attached to
                HandleUtility.AddDefaultControl(GUIUtility.GetControlID(FocusType.Passive));

                // hide the floater move / scale tools while buoyancy influence is selected
                Tools.hidden = true;
            }
            else
            {
                Tools.hidden = false;
            }

            // buoyancy influence de-selection; need to do this since called AddDefaultControl above
            if (mouseUp && mouseButtonLeft && anyBuoyancyInfluenceSelected && GUIUtility.hotControl == 0)
            {
                selectedBuoyancyInfluences.Clear();
                anyBuoyancyInfluenceSelected = false;

                if (singleObjectSelected)
                {
                    buoyancyInfluencesList.ClearSelection();
                    Repaint();
                }
            }

            anyBuoyancyInfluenceSelected = DrawBuoyancyInfluences(floater, floaterTransform, selectedBuoyancyInfluences, anyBuoyancyInfluenceSelected, singleObjectSelected);

            DrawTransformHandlesAndUpdateValues(floater, floaterTransform, anyBuoyancyInfluenceSelected);
        }
    }
}