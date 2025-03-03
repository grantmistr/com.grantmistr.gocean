using System.Collections.Generic;
using UnityEditor;
using UnityEditor.SearchService;
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
        private static Color SELECTED_BACKGROUND_COLOR = new Color(0.6f, 0.7f, 1f, 0.2f);
        private static Color BACKGROUND_COLOR = new Color(1f, 1f, 1f, 0.1f);
        private static GUIStyle BACKGROUND_STYLE = new GUIStyle();
        private static GUIStyle SELECTED_BACKGROUND_STYLE = new GUIStyle();
        private static GUIStyle CUSTOM_BUTTON_STYLE = new GUIStyle();

        private Floater floater;
        private SerializedProperty buoyancyInfluences;
        private bool buoyancyInfluencesFoldout;
        private uint iterations;
        private float force;
        private float radius;
        private bool prevToolHiddenState;
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
                BACKGROUND_STYLE.normal.background.SetPixel(1, 1, BACKGROUND_COLOR);
                BACKGROUND_STYLE.normal.background.Apply();
            }

            if (SELECTED_BACKGROUND_STYLE.normal.background == null)
            {
                SELECTED_BACKGROUND_STYLE.normal.background = new Texture2D(1, 1);
                SELECTED_BACKGROUND_STYLE.normal.background.SetPixel(0, 0, SELECTED_BACKGROUND_COLOR);
                SELECTED_BACKGROUND_STYLE.normal.background.Apply();
            }

            CUSTOM_BUTTON_STYLE.normal.background = BACKGROUND_STYLE.normal.background;
            CUSTOM_BUTTON_STYLE.normal.textColor = Color.white;
            CUSTOM_BUTTON_STYLE.hover.background = Texture2D.grayTexture;
            CUSTOM_BUTTON_STYLE.hover.textColor = Color.white;
            CUSTOM_BUTTON_STYLE.alignment = TextAnchor.MiddleCenter;
        }

        private void LoadData()
        {
            buoyancyInfluencesFoldout = EditorPrefs.GetBool($"{EDITOR_PREFS_STRING_KEY}buoyancyInfluencesFoldout", false);
            iterations = (uint)EditorPrefs.GetInt($"{EDITOR_PREFS_STRING_KEY}iterations", 0);
            force = EditorPrefs.GetFloat($"{EDITOR_PREFS_STRING_KEY}force", 1f);
            radius = EditorPrefs.GetFloat($"{EDITOR_PREFS_STRING_KEY}radius", 1f);
        }

        private void SaveData()
        {
            EditorPrefs.SetBool($"{EDITOR_PREFS_STRING_KEY}buoyancyInfluencesFoldout", buoyancyInfluencesFoldout);
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
            // get the base level control ID
            int baseControlID = GUIUtility.GetControlID(FocusType.Passive);

            if (GUIUtility.hotControl != 0)
            {
                int relativeControlID = GUIUtility.hotControl - baseControlID - 1;
                int buoyancyInfluenceIndex = relativeControlID / BuoyancyInfluencePropertyDrawer.PROPERTY_COUNT;

                // is a buoyancy influence object control selected
                if (relativeControlID > -1 && buoyancyInfluenceIndex < buoyancyInfluences.arraySize)
                {
                    bool isSelected = selectedBuoyancyInfluences.Contains(buoyancyInfluenceIndex);

                    if (Event.current.shift)
                    {
                        if (selectedBuoyancyInfluences.Count > 0)
                        {
                            int lastSelectedIndex = selectedBuoyancyInfluences[selectedBuoyancyInfluences.Count - 1];

                            while (lastSelectedIndex < buoyancyInfluenceIndex)
                            {
                                lastSelectedIndex++;
                                if (!selectedBuoyancyInfluences.Contains(lastSelectedIndex))
                                {
                                    selectedBuoyancyInfluences.Add(lastSelectedIndex);
                                }
                            }

                            while (lastSelectedIndex > buoyancyInfluenceIndex)
                            {
                                lastSelectedIndex--;
                                if (!selectedBuoyancyInfluences.Contains(lastSelectedIndex))
                                {
                                    selectedBuoyancyInfluences.Add(lastSelectedIndex);
                                }
                            }
                        }
                        else
                        {
                            if (!isSelected)
                            {
                                selectedBuoyancyInfluences.Add(buoyancyInfluenceIndex);
                            }
                        }
                    }
                    else if (Event.current.control)
                    {
                        if (isSelected)
                        {
                            selectedBuoyancyInfluences.Remove(buoyancyInfluenceIndex);
                        }
                        else
                        {
                            selectedBuoyancyInfluences.Add(buoyancyInfluenceIndex);
                        }
                    }
                    else
                    {
                        if (!isSelected)
                        {
                            selectedBuoyancyInfluences.Clear();
                            selectedBuoyancyInfluences.Add(buoyancyInfluenceIndex);
                        }
                    }

                    didHotControlSelectionUpdateInspector = true;
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
                    if (Event.current.shift)
                    {
                        if (selectedBuoyancyInfluences.Count > 0)
                        {
                            int lastSelectedIndex = selectedBuoyancyInfluences[selectedBuoyancyInfluences.Count - 1];

                            while (lastSelectedIndex < index)
                            {
                                lastSelectedIndex++;
                                if (!selectedBuoyancyInfluences.Contains(lastSelectedIndex))
                                {
                                    selectedBuoyancyInfluences.Add(lastSelectedIndex);
                                }
                            }

                            while (lastSelectedIndex > index)
                            {
                                lastSelectedIndex--;
                                if (!selectedBuoyancyInfluences.Contains(lastSelectedIndex))
                                {
                                    selectedBuoyancyInfluences.Add(lastSelectedIndex);
                                }
                            }
                        }
                        else
                        {
                            if (!isSelected)
                            {
                                selectedBuoyancyInfluences.Add(index);
                                isSelected = true;
                            }
                        }
                    }
                    else if (Event.current.control)
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

        private void DrawBuoyancyInfluenceInspector(Rect backgroundRect, Rect position, SerializedProperty buoyancyInfluence, int index, bool isSelected)
        {
            if (Event.current.type == EventType.Repaint)
            {
                if (isSelected)
                {
                    SELECTED_BACKGROUND_STYLE.Draw(backgroundRect, GUIContent.none, GUIUtility.GetControlID(FocusType.Passive));
                }
            }

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

        private void DrawBuoyancyInfluencesAddSubButtons(Rect boundingRect)
        {
            Rect rect = new Rect();
            rect.y = boundingRect.y + boundingRect.height - EditorGUIUtility.singleLineHeight;
            rect.x = Mathf.Max(boundingRect.x + boundingRect.width - EditorGUIUtility.singleLineHeight * 3f, boundingRect.x);
            rect.width = EditorGUIUtility.singleLineHeight;
            rect.height = EditorGUIUtility.singleLineHeight;

            // button that appends a new buoyancy influence object to array
            if (GUI.Button(rect, new GUIContent("+"), CUSTOM_BUTTON_STYLE))
            {
                Undo.RecordObject(floater, "Add Buoyancy Influence Array Element");

                BuoyancyInfluence[] resizedArray = new BuoyancyInfluence[floater.buoyancyInfluences.Length + 1];
                floater.buoyancyInfluences.CopyTo(resizedArray, 0);
                if (floater.buoyancyInfluences.Length > 0)
                {
                    resizedArray[^1] = floater.buoyancyInfluences[^1].Clone();
                }
                else
                {
                    resizedArray[^1] = new BuoyancyInfluence();
                }
                floater.buoyancyInfluences = resizedArray;
            }

            rect.x += rect.width;

            bool buttonPress = GUI.Button(rect, new GUIContent("-"), CUSTOM_BUTTON_STYLE);
            bool keyPress = Event.current.isKey;
            if (keyPress)
            {
                keyPress = Event.current.keyCode == KeyCode.Backspace || Event.current.keyCode == KeyCode.Delete;
            }

            // remove selected buoyancy objects from array
            if ((buttonPress || keyPress) && selectedBuoyancyInfluences.Count > 0)
            {
                Undo.RecordObject(floater, "Delete Buoyancy Influence Array Elements");

                selectedBuoyancyInfluences.Sort();
                BuoyancyInfluence[] resizedArray = new BuoyancyInfluence[floater.buoyancyInfluences.Length - selectedBuoyancyInfluences.Count];
                for (int i = 0, j = 0, k = 0; i < floater.buoyancyInfluences.Length; i++)
                {
                    if (k < selectedBuoyancyInfluences.Count)
                    {
                        if (i == selectedBuoyancyInfluences[k])
                        {
                            k++;
                            continue;
                        }
                    }
                
                    resizedArray[j] = floater.buoyancyInfluences[i].Clone();
                    j++;
                }
                selectedBuoyancyInfluences.Clear();
                floater.buoyancyInfluences = resizedArray;
            }
        }

        private void DrawBuoyancyInfluencesInspector()
        {
            // only draw buoyancy influences array if one floater is selected
            if (targets.Length == 1)
            {
                float height = EditorGUIUtility.singleLineHeight + 4f;
                if (buoyancyInfluences.arraySize > 0 && buoyancyInfluencesFoldout)
                {
                    height += EditorGUI.GetPropertyHeight(buoyancyInfluences.GetArrayElementAtIndex(0)) * (float)buoyancyInfluences.arraySize + EditorGUIUtility.singleLineHeight;
                }

                Rect boundingRect = GUILayoutUtility.GetRect(0f, height, GUILayout.ExpandWidth(true));
                EditorGUI.BeginProperty(boundingRect, GUIContent.none, buoyancyInfluences);

                Rect foldoutRect = new Rect(boundingRect.x, boundingRect.y, boundingRect.width, EditorGUIUtility.singleLineHeight + 4f);
                buoyancyInfluencesFoldout = EditorGUI.Foldout(foldoutRect, buoyancyInfluencesFoldout, new GUIContent(buoyancyInfluences.displayName));
                
                if (buoyancyInfluencesFoldout)
                {
                    if (Event.current.type == EventType.Repaint)
                    {
                        BACKGROUND_STYLE.Draw(
                            new Rect(foldoutRect.x, foldoutRect.y + foldoutRect.height, foldoutRect.width, boundingRect.height - foldoutRect.height - EditorGUIUtility.singleLineHeight),
                            GUIContent.none,
                            GUIUtility.GetControlID(FocusType.Passive));
                    }

                    DrawBuoyancyInfluencesAddSubButtons(boundingRect);

                    UpdateSelectionWithHotControl();

                    Rect propRect = new Rect(foldoutRect.x + 6f, foldoutRect.y + foldoutRect.height, foldoutRect.width - 12f, 0f);
                    Rect backgroundRect = new Rect(foldoutRect.x, propRect.y, foldoutRect.width, 0f);

                    for (int i = 0; i < buoyancyInfluences.arraySize; i++)
                    {
                        propRect.y += propRect.height;
                        backgroundRect.y = propRect.y;

                        SerializedProperty prop = buoyancyInfluences.GetArrayElementAtIndex(i);

                        propRect.height = EditorGUI.GetPropertyHeight(prop);
                        backgroundRect.height = propRect.height;

                        bool isSelected;
                        if (didHotControlSelectionUpdateInspector)
                        {
                            isSelected = selectedBuoyancyInfluences.Contains(i);
                        }
                        else
                        {
                            isSelected = UpdateSelection(i, backgroundRect);
                        }

                        DrawBuoyancyInfluenceInspector(backgroundRect, propRect, prop, i, isSelected);
                    }
                }

                EditorGUI.EndProperty();
            }

            if (Event.current.type == EventType.Layout && GUIUtility.hotControl == 0)
            {
                didHotControlSelectionUpdateInspector = false;
            }
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

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