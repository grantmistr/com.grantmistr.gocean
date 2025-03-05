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
        private static Color SELECTED_BACKGROUND_COLOR = new Color(0.6f, 0.7f, 1f, 0.2f);
        private static Color BACKGROUND_COLOR = new Color(1f, 1f, 1f, 0.1f);
        private static GUIStyle CUSTOM_BUTTON_STYLE = new GUIStyle();

        private Floater floater;
        private SerializedProperty buoyancyInfluences;
        private bool buoyancyInfluencesFoldout;
        private uint iterations;
        private float force;
        private float radius;
        private bool onlyDrawSelected;
        private bool prevToolHiddenState;
        private bool didMouseDown = false;
        private bool didHotControlSelectionUpdateInspector = false;

        private List<int> selectedBuoyancyInfluences = new List<int>();

        private void OnEnable()
        {
            floater = target as Floater;

            SetupStyles();
            GetPropertyReferences();
            LoadData();

            Selection.selectionChanged += OnSelectionChanged;
            Undo.undoRedoPerformed += OnUndoRedoPerformed;

            prevToolHiddenState = Tools.hidden;
        }

        private void OnDisable()
        {
            SaveData();

            Selection.selectionChanged -= OnSelectionChanged;
            Undo.undoRedoPerformed -= OnUndoRedoPerformed;

            Tools.hidden = prevToolHiddenState;
        }

        private void OnSelectionChanged()
        {
            selectedBuoyancyInfluences.Clear();
        }

        private void OnUndoRedoPerformed()
        {
            for (int i = 0; i < selectedBuoyancyInfluences.Count; i++)
            {
                if (selectedBuoyancyInfluences[i] >= floater.buoyancyInfluences.Length)
                {
                    selectedBuoyancyInfluences.RemoveAt(i);
                }
            }
        }

        private void GetPropertyReferences()
        {
            buoyancyInfluences = serializedObject.FindProperty("buoyancyInfluences");
        }

        private void SetupStyles()
        {
            if (CUSTOM_BUTTON_STYLE.normal.background == null)
            {
                CUSTOM_BUTTON_STYLE.normal.background = new Texture2D(1, 1);
                CUSTOM_BUTTON_STYLE.normal.background.SetPixel(1, 1, BACKGROUND_COLOR);
                CUSTOM_BUTTON_STYLE.normal.background.Apply();
            }

            CUSTOM_BUTTON_STYLE.normal.textColor = Color.white;
            CUSTOM_BUTTON_STYLE.hover.background = Texture2D.grayTexture;
            CUSTOM_BUTTON_STYLE.hover.textColor = Color.white;
            CUSTOM_BUTTON_STYLE.alignment = TextAnchor.MiddleCenter;
            CUSTOM_BUTTON_STYLE.fontStyle = FontStyle.Bold;
        }

        private void LoadData()
        {
            buoyancyInfluencesFoldout = EditorPrefs.GetBool($"{EDITOR_PREFS_STRING_KEY}buoyancyInfluencesFoldout", false);
            iterations = (uint)EditorPrefs.GetInt($"{EDITOR_PREFS_STRING_KEY}iterations", 0);
            force = EditorPrefs.GetFloat($"{EDITOR_PREFS_STRING_KEY}force", 1f);
            radius = EditorPrefs.GetFloat($"{EDITOR_PREFS_STRING_KEY}radius", 1f);
            onlyDrawSelected = EditorPrefs.GetBool($"{EDITOR_PREFS_STRING_KEY}onlyDrawSelected", false);
        }

        private void SaveData()
        {
            EditorPrefs.SetBool($"{EDITOR_PREFS_STRING_KEY}buoyancyInfluencesFoldout", buoyancyInfluencesFoldout);
            EditorPrefs.SetInt($"{EDITOR_PREFS_STRING_KEY}iterations", (int)iterations);
            EditorPrefs.SetFloat($"{EDITOR_PREFS_STRING_KEY}force", force);
            EditorPrefs.SetFloat($"{EDITOR_PREFS_STRING_KEY}radius", radius);
            EditorPrefs.SetBool($"{EDITOR_PREFS_STRING_KEY}onlyDrawSelected", onlyDrawSelected);
        }

        /// <summary>
        /// Updates selected buoyancy influences list with slightly different logic to account for hot controls
        /// </summary>
        /// <returns>
        /// True if a buoyancy influence object control was selected
        /// </returns>
        private bool UpdateSelectionWithHotControl()
        {
            // Need to cache mouse down event bc hot control will always be 0 during mouse down.
            // Do selection updates on the first layout event after mouse down.
            if (!didMouseDown)
            {
                didMouseDown = (Event.current.type == EventType.MouseDown) && (Event.current.button == 0);
            }

            int baseControlID = GUIUtility.GetControlID(FocusType.Passive);

            if ((GUIUtility.hotControl != 0) && (Event.current.type == EventType.Layout) && (Event.current.button == 0) && didMouseDown)
            {
                didMouseDown = false;

                int relativeControlID = GUIUtility.hotControl - baseControlID - 1;
                int buoyancyInfluenceIndex = relativeControlID / BuoyancyInfluencePropertyDrawer.PROPERTY_COUNT;

                // is a buoyancy influence object control selected
                if ((relativeControlID > -1) && (buoyancyInfluenceIndex < buoyancyInfluences.arraySize))
                {
                    bool isSelected = selectedBuoyancyInfluences.Contains(buoyancyInfluenceIndex);

                    // SHIFT: if there are other buoyancy objects selected, add to selected array the buoyancy objects from the last selected
                    // index to the current selected index
                    if (Event.current.shift)
                    {
                        if (selectedBuoyancyInfluences.Count > 0)
                        {
                            int lastSelectedIndex = selectedBuoyancyInfluences[^1];

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

                            // if this index was already selected, re-add it to make transform handles draw at its position
                            if (isSelected)
                            {
                                selectedBuoyancyInfluences.Remove(buoyancyInfluenceIndex);
                                selectedBuoyancyInfluences.Add(buoyancyInfluenceIndex);
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

                    // CTRL: add / remove current index if it was un-selected / selected
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

                    // NORMAL CLICK: since using the hotControl for selection, only clear if this index wasn't already selected;
                    // this makes it so that multiple buoyancy objects can be edited at the same time
                    else
                    {
                        // if this index was already selected, re-add it to make transform handles draw at its position
                        if (isSelected)
                        {
                            selectedBuoyancyInfluences.Remove(buoyancyInfluenceIndex);
                            selectedBuoyancyInfluences.Add(buoyancyInfluenceIndex);
                        }
                        else
                        {
                            selectedBuoyancyInfluences.Clear();
                            selectedBuoyancyInfluences.Add(buoyancyInfluenceIndex);
                        }
                    }

                    didHotControlSelectionUpdateInspector = true;

                    return true;
                }
            }

            return false;
        }

        /// <summary>
        /// Updates the selectedBuoyancyInfluences list with differing logic based on the buoyancy influence
        /// object selected, where the user clicked, and if they're holding SHIFT or CTRL
        /// </summary>
        /// <param name="index"></param>
        /// <param name="selectionRect"></param>
        /// <returns>
        /// True if this index is selected
        /// </returns>
        private bool UpdateSelection(int index, Rect selectionRect)
        {
            bool isSelected = selectedBuoyancyInfluences.Contains(index);

            if ((Event.current.type == EventType.MouseUp) && (Event.current.button == 0))
            {
                if (selectionRect.Contains(Event.current.mousePosition))
                {
                    // SHIFT: if there are other buoyancy objects selected, add to selected array the buoyancy objects from the last selected
                    // index to the current selected index
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

                            // if this index was already selected, re-add it to make transform handles draw at its position
                            if (isSelected)
                            {
                                selectedBuoyancyInfluences.Remove(index);
                                selectedBuoyancyInfluences.Add(index);
                            }
                        }
                        else
                        {
                            // if this index was already selected, re-add it to make transform handles draw at its position
                            if (isSelected)
                            {
                                selectedBuoyancyInfluences.Remove(index);
                                selectedBuoyancyInfluences.Add(index);
                            }
                            else
                            {
                                selectedBuoyancyInfluences.Add(index);
                                isSelected = true;
                            }
                        }
                    }

                    // CTRL: add / remove current index if it was un-selected / selected
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

                    // NORMAL CLICK: de-select all other indices except current
                    else
                    {
                        selectedBuoyancyInfluences.Clear();
                        selectedBuoyancyInfluences.Add(index);
                        isSelected = true;

                    }
                }
                
                // if clicked outside property rect w/o holding SHIFT or CTRL, remove current index
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

        /// <summary>
        /// Handles the logic to draw a buoyancy influence object
        /// </summary>
        /// <param name="backgroundRect"></param>
        /// <param name="position"></param>
        /// <param name="buoyancyInfluence"></param>
        /// <param name="index"></param>
        private void DrawBuoyancyInfluenceInspector(Rect backgroundRect, Rect position, SerializedProperty buoyancyInfluence, int index)
        {
            bool isSelected;

            // if selection was already updated with hot control, just check if index is in selected array
            if (didHotControlSelectionUpdateInspector)
            {
                isSelected = selectedBuoyancyInfluences.Contains(index);
            }
            else
            {
                isSelected = UpdateSelection(index, backgroundRect);
            }

            SerializedProperty iterations = buoyancyInfluence.FindPropertyRelative("oceanSampler").FindPropertyRelative("iterations");
            SerializedProperty force = buoyancyInfluence.FindPropertyRelative("force");
            SerializedProperty radius = buoyancyInfluence.FindPropertyRelative("radius");
            SerializedProperty localPosition = buoyancyInfluence.FindPropertyRelative("localPosition");

            position.y += BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            position.height = EditorGUIUtility.singleLineHeight;

            if ((Event.current.type == EventType.Repaint) && isSelected)
            {
                EditorGUI.DrawRect(backgroundRect, SELECTED_BACKGROUND_COLOR);
            }
            
            // Modified fields will update the corresponding field on all selected buoyancy influence objects

            EditorGUI.LabelField(position, new GUIContent($"Buoyancy Influence {index}"), EditorStyles.boldLabel);

            // Iterations
            position.y += EditorGUIUtility.singleLineHeight + BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            uint newIterations = (uint)EditorGUI.IntField(position, new GUIContent(iterations.displayName), (int)iterations.uintValue);

            // Force
            position.y += EditorGUIUtility.singleLineHeight + BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            float newForce = EditorGUI.FloatField(position, new GUIContent(force.displayName), force.floatValue);

            // Radius
            position.y += EditorGUIUtility.singleLineHeight + BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            float newRadius = EditorGUI.FloatField(position, new GUIContent(radius.displayName), radius.floatValue);
            newRadius = Mathf.Max(newRadius, 0f);

            // Local Position
            position.y += EditorGUIUtility.singleLineHeight + BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            position.height = EditorGUI.GetPropertyHeight(localPosition);
            Vector3 newLocalPosition = EditorGUI.Vector3Field(position, new GUIContent(localPosition.displayName), localPosition.vector3Value);

            // update during used event
            if ((Event.current.type == EventType.Used) && isSelected)
            {
                if (newIterations != iterations.uintValue)
                {
                    foreach (int i in selectedBuoyancyInfluences)
                    {
                        buoyancyInfluences.GetArrayElementAtIndex(i).FindPropertyRelative("oceanSampler").FindPropertyRelative("iterations").uintValue = newIterations;
                    }
                }
                else if (newForce != force.floatValue)
                {
                    foreach (int i in selectedBuoyancyInfluences)
                    {
                        buoyancyInfluences.GetArrayElementAtIndex(i).FindPropertyRelative("force").floatValue = newForce;
                    }
                }
                else if (newRadius != radius.floatValue)
                {
                    foreach (int i in selectedBuoyancyInfluences)
                    {
                        buoyancyInfluences.GetArrayElementAtIndex(i).FindPropertyRelative("radius").floatValue = newRadius;
                    }
                }
                else
                {
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
            }
        }

        private void DuplicateSelectedBuoyancyInfluences(Floater floater)
        {
            if (selectedBuoyancyInfluences.Count > 0)
            {
                Undo.RecordObject(floater, "Duplicate Selected Buoyancy Influences");

                BuoyancyInfluence[] resizedArray = new BuoyancyInfluence[floater.buoyancyInfluences.Length + selectedBuoyancyInfluences.Count];
                for (int i = 0; i < floater.buoyancyInfluences.Length; i++)
                {
                    resizedArray[i] = floater.buoyancyInfluences[i].Clone();
                }
                for (int i = 0; i < selectedBuoyancyInfluences.Count; i++)
                {
                    int j = i + floater.buoyancyInfluences.Length;

                    // clone and append selected indices
                    resizedArray[j] = floater.buoyancyInfluences[selectedBuoyancyInfluences[i]].Clone();

                    // replace prev selected index with new one
                    selectedBuoyancyInfluences[i] = j;
                }
                floater.buoyancyInfluences = resizedArray;
            }
        }

        /// <summary>
        /// Add new buoyancy influence to end of buoyancyInfluences array
        /// </summary>
        /// <param name="floater"></param>
        private void AppendNewBuoyancyInfluence(Floater floater)
        {
            Undo.RecordObject(floater, "Add Buoyancy Influence Array Element");

            BuoyancyInfluence[] resizedArray = new BuoyancyInfluence[floater.buoyancyInfluences.Length + 1];
            for (int i = 0; i < floater.buoyancyInfluences.Length; i++)
            {
                resizedArray[i] = floater.buoyancyInfluences[i];
            }
            if (floater.buoyancyInfluences.Length > 0)
            {
                resizedArray[^1] = floater.buoyancyInfluences[^1].Clone();
            }
            else
            {
                resizedArray[^1] = new BuoyancyInfluence();
            }
            selectedBuoyancyInfluences.Clear();
            selectedBuoyancyInfluences.Add(resizedArray.Length - 1);
            floater.buoyancyInfluences = resizedArray;
        }

        /// <summary>
        /// Remove selected buoyancy influences from array
        /// </summary>
        /// <param name="floater"></param>
        private void RemoveSelectedBuoyancyInfluences(Floater floater)
        {
            if (selectedBuoyancyInfluences.Count > 0)
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

        /// <summary>
        /// + , - buttons for adding / removing buoyancy influences
        /// </summary>
        /// <param name="boundingRect"></param>
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
                AppendNewBuoyancyInfluence(floater);
            }

            rect.x += rect.width;

            // button to remove selected indices
            if (GUI.Button(rect, new GUIContent("-"), CUSTOM_BUTTON_STYLE))
            {
                RemoveSelectedBuoyancyInfluences(floater);
            }
        }

        private void DrawBuoyancyInfluencesInspector()
        {
            // only draw buoyancy influences array if one floater is selected
            if (targets.Length == 1)
            {
                const float padding = 8f;
                float height = EditorGUIUtility.singleLineHeight + padding;

                if (buoyancyInfluencesFoldout)
                {
                    // add space for + , - buttons
                    height += EditorGUIUtility.singleLineHeight;

                    if (buoyancyInfluences.arraySize > 0)
                    {
                        height += EditorGUI.GetPropertyHeight(buoyancyInfluences.GetArrayElementAtIndex(0)) * (float)buoyancyInfluences.arraySize;
                    }
                    else
                    {
                        height += EditorGUIUtility.singleLineHeight;
                    }
                }

                Rect boundingRect = GUILayoutUtility.GetRect(0f, height, GUILayout.ExpandWidth(true));

                // ********** BEGIN PROP ********** //
                EditorGUI.BeginProperty(boundingRect, GUIContent.none, buoyancyInfluences);

                Rect foldoutRect = new Rect(boundingRect.x, boundingRect.y, 130f, EditorGUIUtility.singleLineHeight + padding);
                buoyancyInfluencesFoldout = EditorGUI.Foldout(foldoutRect, buoyancyInfluencesFoldout, new GUIContent(buoyancyInfluences.displayName), true);

                EditorGUI.LabelField(
                    new Rect(foldoutRect.x + 130f, foldoutRect.y + 4f, 40f, EditorGUIUtility.singleLineHeight),
                    new GUIContent(buoyancyInfluences.arraySize.ToString(), "Array Size"),
                    GUI.skin.textField);

                if (buoyancyInfluencesFoldout)
                {
                    if (Event.current.type == EventType.Repaint)
                    {
                        EditorGUI.DrawRect(
                            new Rect(boundingRect.x, foldoutRect.y + foldoutRect.height, boundingRect.width, boundingRect.height - foldoutRect.height - EditorGUIUtility.singleLineHeight),
                            BACKGROUND_COLOR);
                    }

                    DrawBuoyancyInfluencesAddSubButtons(boundingRect);

                    if (Event.current.type == EventType.KeyDown)
                    {
                        // del / backspace remove
                        if ((Event.current.keyCode == KeyCode.Backspace) || (Event.current.keyCode == KeyCode.Delete))
                        {
                            RemoveSelectedBuoyancyInfluences(floater);
                            Event.current.Use();
                        }

                        // duplicate selected with CTRL+D
                        else if (Event.current.control && (Event.current.keyCode == KeyCode.D))
                        {
                            DuplicateSelectedBuoyancyInfluences(floater);
                            Event.current.Use();
                        }
                    }

                    UpdateSelectionWithHotControl();

                    Rect propRect = new Rect(boundingRect.x + 6f, foldoutRect.y + foldoutRect.height, boundingRect.width - 12f, 0f);
                    Rect backgroundRect = new Rect(boundingRect.x, propRect.y, boundingRect.width, 0f);

                    for (int i = 0; i < buoyancyInfluences.arraySize; i++)
                    {
                        propRect.y += propRect.height;
                        backgroundRect.y = propRect.y;

                        SerializedProperty prop = buoyancyInfluences.GetArrayElementAtIndex(i);

                        propRect.height = EditorGUI.GetPropertyHeight(prop);
                        backgroundRect.height = propRect.height;

                        DrawBuoyancyInfluenceInspector(backgroundRect, propRect, prop, i);
                    }
                }

                EditorGUI.EndProperty();
                // *********** END PROP *********** //
            }

            if ((Event.current.type == EventType.Layout) && (GUIUtility.hotControl == 0))
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

            using (new GUILayout.HorizontalScope())
            {
                EditorGUILayout.LabelField("Only Draw Selected");

                Rect rect = GUILayoutUtility.GetRect(EditorGUIUtility.singleLineHeight, EditorGUIUtility.singleLineHeight, GUILayout.ExpandWidth(true));
                rect.x = 148f;
                rect.y += 2f;
                onlyDrawSelected = EditorGUI.Toggle(rect, onlyDrawSelected);
            }

            DrawBuoyancyInfluencesInspector();

            serializedObject.ApplyModifiedProperties();
        }

        private void DrawBuoyancyInfluencesScene(Floater floater, Transform floaterTransform, bool singleObjectSelected)
        {
            for (int i = 0; i < floater.buoyancyInfluences.Length; i++)
            {
                bool isSelected = selectedBuoyancyInfluences.Contains(i);

                if (!isSelected && onlyDrawSelected)
                {
                    continue;
                }

                BuoyancyInfluence bInfluence = floater.buoyancyInfluences[i];

                Vector3 worldPosition = floaterTransform.localToWorldMatrix.MultiplyPoint(bInfluence.GetLocalPosition());
                float radius = bInfluence.GetRadius();
                float diameter = radius * 2f;

                if (isSelected)
                {
                    Handles.color = SELECTED_COLOR;
                }
                else
                {
                    Handles.color = UNSELECTED_COLOR;
                }

                // add / remove buoyancy influences to / from selected influences list
                if (Handles.Button(worldPosition, Quaternion.identity, diameter, radius, Handles.SphereHandleCap) && (Event.current.type == EventType.Used))
                {
                    if (Event.current.shift)
                    {
                        if (isSelected)
                        {
                            selectedBuoyancyInfluences.Remove(i);
                            selectedBuoyancyInfluences.Add(i);
                        }
                        else
                        {
                            selectedBuoyancyInfluences.Add(i);
                            if (singleObjectSelected)
                            {
                                Repaint();
                            }
                        }
                    }
                    else if (Event.current.control)
                    {
                        if (isSelected)
                        {
                            selectedBuoyancyInfluences.Remove(i);
                            if (singleObjectSelected)
                            {
                                Repaint();
                            }
                        }
                        else
                        {
                            selectedBuoyancyInfluences.Add(i);
                            if (singleObjectSelected)
                            {
                                Repaint();
                            }
                        }
                    }
                    else
                    {
                        selectedBuoyancyInfluences.Clear();
                        selectedBuoyancyInfluences.Add(i);
                        if (singleObjectSelected)
                        {
                            Repaint();
                        }
                    }
                }
            }
        }

        private void DrawTransformHandlesAndUpdateValues(Floater floater, Transform floaterTransform)
        {
            if (selectedBuoyancyInfluences.Count < 1)
            {
                return;
            }

            // use the last selected influence to draw tranform handles
            BuoyancyInfluence bInfluence = floater.buoyancyInfluences[selectedBuoyancyInfluences[^1]];
            Vector3 localPosition = bInfluence.GetLocalPosition();
            Vector3 worldPosition = floaterTransform.localToWorldMatrix.MultiplyPoint(localPosition);
            float radius = bInfluence.GetRadius();

            switch (Tools.current)
            {
                case Tool.Move:
                    Vector3 newPosition = Handles.PositionHandle(worldPosition, floaterTransform.rotation);
                    if (newPosition != worldPosition && (Event.current.type == EventType.Used))
                    {
                        Undo.RecordObject(target, "Move Buoyancy Object");

                        // calculate a delta that will be added to each buoyancy influence local position
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
                    if (newRadius != radius && (Event.current.type == EventType.Used))
                    {
                        Undo.RecordObject(target, "Scale Buoyancy Object");

                        // keeps object scale relative when objects with different radii are scaled together
                        if (radius == 0f) { radius = 1f; }
                        float radiusMultiplier = newRadius / radius;

                        foreach (int i in selectedBuoyancyInfluences)
                        {
                            BuoyancyInfluence b = floater.buoyancyInfluences[i];
                            b.SetRadius(b.GetRadius() * radiusMultiplier);
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

            // only draw stuff for active game object
            if (!(Selection.activeGameObject == floater.gameObject))
            {
                return;
            }

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
            if ((Event.current.type == EventType.MouseUp) && (Event.current.button == 0) && anyBuoyancyInfluenceSelected && (GUIUtility.hotControl == 0))
            {
                selectedBuoyancyInfluences.Clear();

                if (singleObjectSelected)
                {
                    Repaint();
                }

                return;
            }

            if (Event.current.type == EventType.KeyDown)
            {
                // handle keyboard input delete
                if ((Event.current.keyCode == KeyCode.Backslash) || (Event.current.keyCode == KeyCode.Delete))
                {
                    RemoveSelectedBuoyancyInfluences(floater);
                    Event.current.Use();
                }

                // handle keyboard input duplicate
                else if (Event.current.control && (Event.current.keyCode == KeyCode.D))
                {
                    DuplicateSelectedBuoyancyInfluences(floater);
                    Event.current.Use();
                }
            }

            DrawBuoyancyInfluencesScene(floater, floaterTransform, singleObjectSelected);

            DrawTransformHandlesAndUpdateValues(floater, floaterTransform);
        }
    }
}