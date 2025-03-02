using System.Collections.Generic;
using UnityEditor;
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
        private static Color BACKGROUND_COLOR = new Color(0.6f, 0.7f, 1f, 0.2f);
        private static GUIStyle BACKGROUND_STYLE = new GUIStyle();

        private Floater floater;
        private SerializedProperty buoyancyInfluences;
        private bool prevToolHiddenState;
        private uint iterations;
        private float force;
        private float radius;
        private int baseControlID;
        private bool didHotControlSelectionUpdateInspector = false;

        private List<int> selectedBuoyancyInfluences = new List<int>();

        private void OnEnable()
        {
            floater = target as Floater;

            SetupStyles();
            GetPropertyReferences();
            LoadData();

            Selection.selectionChanged += OnSelectionChanged;

            prevToolHiddenState = Tools.hidden;
        }

        private void OnDisable()
        {
            SaveData();

            Selection.selectionChanged -= OnSelectionChanged;

            Tools.hidden = prevToolHiddenState;
        }

        private void GetPropertyReferences()
        {
            buoyancyInfluences = serializedObject.FindProperty("buoyancyInfluences");
        }

        private void SetupStyles()
        {
            if (BACKGROUND_STYLE.normal.background == null)
            {
                BACKGROUND_STYLE.normal.background = new Texture2D(1, 1);
                BACKGROUND_STYLE.normal.background.SetPixel(0, 0, BACKGROUND_COLOR);
                BACKGROUND_STYLE.normal.background.Apply();
            }
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

        private void OnSelectionChanged()
        {
            selectedBuoyancyInfluences.Clear();
        }

        private void UpdateSelectionWithHotControl()
        {
            if (GUIUtility.hotControl != 0)
            {
                int relativeControlID = GUIUtility.hotControl - (baseControlID + 8);
                int buoyancyInfluenceIndex = relativeControlID / BuoyancyInfluencePropertyDrawer.PROPERTY_COUNT;

                // is a buoyancy influence object control selected
                if (relativeControlID > -1 && buoyancyInfluenceIndex < buoyancyInfluences.arraySize)
                {
                    didHotControlSelectionUpdateInspector = true;

                    /*if (selectedBuoyancyInfluences.Contains(buoyancyInfluenceIndex))
                    {
                        if (Event.current.shift || Event.current.control)
                        {
                            if (Event.current.delta.magnitude == 0 && Event.current.type == EventType.MouseUp)
                            {
                                selectedBuoyancyInfluences.Remove(buoyancyInfluenceIndex);
                            }
                        }
                    }
                    else
                    {
                        if (!(Event.current.shift || Event.current.control))
                        {
                            selectedBuoyancyInfluences.Clear();
                        }
                    
                        selectedBuoyancyInfluences.Add(buoyancyInfluenceIndex);
                    }*/

                    if (!selectedBuoyancyInfluences.Contains(buoyancyInfluenceIndex))
                    {
                        if (!(Event.current.shift || Event.current.control))
                        {
                            selectedBuoyancyInfluences.Clear();
                        }
                    
                        selectedBuoyancyInfluences.Add(buoyancyInfluenceIndex);
                    }
                }
            }
        }

        private bool UpdateSelection(int index, Rect selectionRect)
        {
            bool isSelected = selectedBuoyancyInfluences.Contains(index);

            if (Event.current.type == EventType.MouseUp && Event.current.button == 0)
            {
                if (selectionRect.Contains(Event.current.mousePosition))
                {
                    if (Event.current.shift || Event.current.control)
                    {
                        if (isSelected)
                        {
                            selectedBuoyancyInfluences.Remove(index);
                            isSelected = false;
                        }
                        else
                        {
                            selectedBuoyancyInfluences.Add(index);
                            isSelected = true;
                        }
                    }
                    else
                    {
                        selectedBuoyancyInfluences.Clear();
                        selectedBuoyancyInfluences.Add(index);
                        isSelected = true;
                    }
                }
                else
                {
                    if (!(Event.current.shift || Event.current.control))
                    {
                        selectedBuoyancyInfluences.Remove(index);
                        isSelected = false;
                    }
                }

                Repaint();
            }

            return isSelected;
        }

        private void DrawBuoyancyInfluenceInspector(Rect position, SerializedProperty buoyancyInfluence, int index)
        {
            SerializedProperty iterations = buoyancyInfluence.FindPropertyRelative("oceanSampler").FindPropertyRelative("iterations");
            SerializedProperty force = buoyancyInfluence.FindPropertyRelative("force");
            SerializedProperty radius = buoyancyInfluence.FindPropertyRelative("radius");
            SerializedProperty localPosition = buoyancyInfluence.FindPropertyRelative("localPosition");

            position.y += BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            position.height = EditorGUIUtility.singleLineHeight;
            EditorGUI.LabelField(position, new GUIContent($"Buoyancy Influence {index}"), EditorStyles.boldLabel);

            // Iterations
            position.y += EditorGUIUtility.singleLineHeight + BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            uint newIterations = (uint)EditorGUI.IntField(position, new GUIContent(iterations.displayName), (int)iterations.uintValue);
            if (newIterations != iterations.uintValue)
            {
                foreach (int i in selectedBuoyancyInfluences)
                {
                    buoyancyInfluences.GetArrayElementAtIndex(i).FindPropertyRelative("oceanSampler").FindPropertyRelative("iterations").uintValue = newIterations;
                }
            }

            // Force
            position.y += EditorGUIUtility.singleLineHeight + BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            float newForce = EditorGUI.FloatField(position, new GUIContent(force.displayName), force.floatValue);
            if (newForce != force.floatValue)
            {
                foreach (int i in selectedBuoyancyInfluences)
                {
                    buoyancyInfluences.GetArrayElementAtIndex(i).FindPropertyRelative("force").floatValue = newForce;
                }
            }

            // Radius
            position.y += EditorGUIUtility.singleLineHeight + BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            float newRadius = EditorGUI.FloatField(position, new GUIContent(radius.displayName), radius.floatValue);
            newRadius = Mathf.Max(newRadius, 0f);
            if (newRadius != radius.floatValue)
            {
                foreach (int i in selectedBuoyancyInfluences)
                {
                    buoyancyInfluences.GetArrayElementAtIndex(i).FindPropertyRelative("radius").floatValue = newRadius;
                }
            }

            // Local Position
            position.y += EditorGUIUtility.singleLineHeight + BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            position.height = EditorGUI.GetPropertyHeight(localPosition);
            Vector3 newLocalPosition = EditorGUI.Vector3Field(position, new GUIContent(localPosition.displayName), localPosition.vector3Value);
            bool updateX = newLocalPosition.x != localPosition.vector3Value.x;
            bool updateY = newLocalPosition.y != localPosition.vector3Value.y;
            bool updateZ = newLocalPosition.z != localPosition.vector3Value.z;
            if (updateX || updateY || updateZ)
            {
                foreach (int i in selectedBuoyancyInfluences)
                {
                    SerializedProperty p = buoyancyInfluences.GetArrayElementAtIndex(i).FindPropertyRelative("localPosition");
                    Vector3 v;
                    v.x = updateX ? newLocalPosition.x : p.vector3Value.x;
                    v.y = updateY ? newLocalPosition.y : p.vector3Value.y;
                    v.z = updateZ ? newLocalPosition.z : p.vector3Value.z;
                    p.vector3Value = v;
                }
            }
        }

        private void DrawBuoyancyInfluencesInspector()
        {
            // only draw buoyancy influences array if one floater is selected
            if (targets.Length == 1)
            {
                UpdateSelectionWithHotControl();

                Rect boundingRect = GUILayoutUtility.GetRect(0f, EditorGUI.GetPropertyHeight(buoyancyInfluences), GUILayout.ExpandWidth(true));
                EditorGUI.BeginProperty(boundingRect, GUIContent.none, buoyancyInfluences);

                Rect propRect = new Rect(boundingRect.x + 6f, 0f, boundingRect.width - 12f, 0f);
                Rect backgroundRect = new Rect(boundingRect.x, 0f, boundingRect.width, 0f);

                for (int i = 0; i < buoyancyInfluences.arraySize; i++)
                {
                    SerializedProperty prop = buoyancyInfluences.GetArrayElementAtIndex(i);
                    propRect.height = EditorGUI.GetPropertyHeight(prop);
                    propRect.y += propRect.height;

                    backgroundRect.height = propRect.height;
                    backgroundRect.y += propRect.height;

                    bool isSelected;
                    if (didHotControlSelectionUpdateInspector)
                    {
                        isSelected = selectedBuoyancyInfluences.Contains(i);
                    }
                    else
                    {
                        isSelected = UpdateSelection(i, backgroundRect);
                    }

                    if (Event.current.type == EventType.Repaint)
                    {
                        if (isSelected)
                        {
                            BACKGROUND_STYLE.Draw(backgroundRect, GUIContent.none, GUIUtility.GetControlID(FocusType.Passive));
                        }
                    }

                    DrawBuoyancyInfluenceInspector(propRect, prop, i);
                    //EditorGUI.PropertyField(propRect, prop, new GUIContent($"Buoyancy Influence {i}"));
                }

                EditorGUI.EndProperty();
            }
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            // get the base level control ID
            baseControlID = GUIUtility.GetControlID(FocusType.Passive);

            using (new GUILayout.HorizontalScope())
            {
                bool update = GUILayout.Button(new GUIContent("Set Iterations", "Set iterations for all buoyancy influences on all selected floaters"), GUILayout.Width(200f));
                iterations = (uint)EditorGUILayout.IntField((int)iterations);
                if (update)
                {
                    for (int i = 0; i < buoyancyInfluences.arraySize; i++)
                    {
                        buoyancyInfluences.GetArrayElementAtIndex(i).FindPropertyRelative("oceanSampler").FindPropertyRelative("iterations").uintValue = iterations;
                    }
                }
            }

            using (new GUILayout.HorizontalScope())
            {
                bool update = GUILayout.Button(new GUIContent("Set Force", "Set force for all buoyancy influences on all selected floaters"), GUILayout.Width(200f));
                force = EditorGUILayout.FloatField(force);
                if (update)
                {
                    for (int i = 0; i < buoyancyInfluences.arraySize; i++)
                    {
                        buoyancyInfluences.GetArrayElementAtIndex(i).FindPropertyRelative("force").floatValue = force;
                    }
                }
            }

            using (new GUILayout.HorizontalScope())
            {
                bool update = GUILayout.Button(new GUIContent("Set Radius", "Set radius for all buoyancy influences on all selected floaters"), GUILayout.Width(200f));
                radius = EditorGUILayout.FloatField(radius);
                if (update)
                {
                    for (int i = 0; i < buoyancyInfluences.arraySize; i++)
                    {
                        buoyancyInfluences.GetArrayElementAtIndex(i).FindPropertyRelative("radius").floatValue = radius;
                    }
                }
            }

            DrawBuoyancyInfluencesInspector();

            if (Event.current.type == EventType.Layout && GUIUtility.hotControl == 0)
            {
                didHotControlSelectionUpdateInspector = false;
            }

            serializedObject.ApplyModifiedProperties();
        }

        /// <param name="floater"></param>
        /// <param name="floaterTransform"></param>
        /// <param name="selectedBuoyancyInfluences"></param>
        /// <returns>
        /// True if any buoyancy influences on this floater are selected.
        /// </returns>
        private bool DrawBuoyancyInfluencesScene(Floater floater, Transform floaterTransform, bool anyBuoyancyInfluenceSelected, bool singleObjectSelected)
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
                                Repaint();
                            }

                            return selectedBuoyancyInfluences.Count > 0;
                        }
                        else
                        {
                            selectedBuoyancyInfluences.Add(i);

                            if (singleObjectSelected)
                            {
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
                        float radiusDifference = newRadius - radius;
                        if (radius == 0f) { radius = 1f; }
                        float radiusMultiplier = newRadius / radius;

                        foreach (int i in selectedBuoyancyInfluences)
                        {
                            BuoyancyInfluence b = floater.buoyancyInfluences[i];
                            float r = b.GetRadius() * radiusMultiplier;
                            b.SetRadius(r);
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
                    Repaint();
                }
            }

            anyBuoyancyInfluenceSelected = DrawBuoyancyInfluencesScene(floater, floaterTransform, anyBuoyancyInfluenceSelected, singleObjectSelected);

            DrawTransformHandlesAndUpdateValues(floater, floaterTransform, anyBuoyancyInfluenceSelected);
        }
    }
}