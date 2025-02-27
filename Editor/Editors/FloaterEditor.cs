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

        private SerializedProperty buoyancyInfluences;
        private ReorderableList buoyancyInfluencesList;
        private Floater floater;
        private bool prevToolHiddenState;
        private uint iterations;
        private float force;
        private float radius;

        private void OnEnable()
        {
            floater = target as Floater;

            GetPropertyReferences();
            LoadData();
            SetupBuoyancyInfluencesList();

            prevToolHiddenState = Tools.hidden;
        }

        private void OnDisable()
        {
            SaveData();
            CleanupBuoyancyInfluencesList();

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
            if (buoyancyInfluencesList == null)
            {
                buoyancyInfluencesList = new ReorderableList(serializedObject, buoyancyInfluences);
            }

            buoyancyInfluencesList.drawElementCallback += DrawBuoyancyInfluencesListElement;
            buoyancyInfluencesList.elementHeightCallback += GetDrawBuoyancyInfluencesListElementHeight;
            buoyancyInfluencesList.drawHeaderCallback += DrawBuoyancyInfluencesListHeader;
        }

        private void CleanupBuoyancyInfluencesList()
        {
            buoyancyInfluencesList.drawElementCallback -= DrawBuoyancyInfluencesListElement;
            buoyancyInfluencesList.elementHeightCallback -= GetDrawBuoyancyInfluencesListElementHeight;
            buoyancyInfluencesList.drawHeaderCallback -= DrawBuoyancyInfluencesListHeader;
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

            if (targets.Length < 2)
            {
                buoyancyInfluencesList.DoLayoutList();
            }

            serializedObject.ApplyModifiedProperties();
        }

        private void OnSceneGUI()
        {
            bool mouseUp = Event.current.type == EventType.MouseUp;
            bool mouseDrag = Event.current.type == EventType.MouseDrag;
            bool mouseButtonLeft = Event.current.button == 0;
            bool buoyancyObjectIsSelected = buoyancyInfluencesList.selectedIndices.Count > 0;

            //SerializedObject[] targetObjects = targets.Select(t => new SerializedObject(t)).ToArray();

            Color prevColor = Handles.color;

            if (buoyancyObjectIsSelected)
            {
                // this makes 'clicking off' of a buoyancy influence object first select the floater game object
                HandleUtility.AddDefaultControl(GUIUtility.GetControlID(FocusType.Passive));

                Tools.hidden = true;
            }
            else
            {
                Tools.hidden = false;
            }

            // buoyancy object de-selection
            if (mouseUp && mouseButtonLeft && buoyancyObjectIsSelected && GUIUtility.hotControl == 0)
            {
                buoyancyInfluencesList.ClearSelection();
                buoyancyObjectIsSelected = false;
                this.Repaint();
            }

            // draw non-selected buoyancy objects
            Handles.color = new Color(0.1f, 0.5f, 0.7f, 0.5f);
            for (int i = 0; i < buoyancyInfluencesList.count; i++)
            {
                // skip selected buoyancy object
                if (buoyancyObjectIsSelected)
                {
                    if (buoyancyInfluencesList.selectedIndices[0] == i)
                    {
                        continue;
                    }
                }

                BuoyancyInfluence bInfluence = floater.buoyancyInfluences[i];
                Vector3 worldPosition = floater.transform.localToWorldMatrix.MultiplyPoint(bInfluence.GetLocalPosition());
                float radius = bInfluence.GetRadius();
                float diameter = radius * 2f;

                // select new buoyancy object if it was clicked on
                if (Handles.Button(worldPosition, Quaternion.identity, diameter, radius, Handles.SphereHandleCap))
                {
                    buoyancyInfluencesList.Select(i);
                    this.Repaint();
                }
            }

            // if a buoyancy object is selected, do some stuff to it:
            //      change color
            //      draw scale / move handle
            if (buoyancyObjectIsSelected)
            {
                BuoyancyInfluence bInfluence = floater.buoyancyInfluences[buoyancyInfluencesList.selectedIndices[0]];
                Vector3 worldPosition = floater.transform.localToWorldMatrix.MultiplyPoint(bInfluence.GetLocalPosition());
                float radius = bInfluence.GetRadius();
                float diameter = radius * 2f;

                switch (Tools.current)
                {
                    case Tool.Move:
                        Vector3 newPosition = Handles.PositionHandle(worldPosition, floater.transform.rotation);
                        if (newPosition != worldPosition)
                        {
                            Undo.RecordObject(target, "Move Buoyancy Object");
                            Vector3 localPosition = floater.transform.worldToLocalMatrix.MultiplyPoint(newPosition);
                            bInfluence.SetLocalPosition(localPosition);
                            bInfluence.UpdateWorldPosition(floater.transform.localToWorldMatrix);
                        }
                        break;
                    case Tool.Scale:
                        Vector3 scale = Handles.ScaleHandle(new Vector3(radius, radius, radius), worldPosition, floater.transform.rotation);
                        for (int i = 0; i < 3; i++)
                        {
                            if (scale[i] != radius)
                            {
                                Undo.RecordObject(target, "Scale Buoyancy Object");
                                bInfluence.SetRadius(Mathf.Max(scale[i], 0f));
                                break;
                            }
                        }
                        break;
                    default:
                        break;
                }

                if (Event.current.type == EventType.Repaint)
                {
                    Handles.color = new Color(0.7f, 0.2f, 0.1f, 0.5f);
                    Handles.SphereHandleCap(-1, worldPosition, Quaternion.identity, diameter, EventType.Repaint);
                }
            }

            Handles.color = prevColor;
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

            /*float h = 0f;
            Rect r = new Rect(rect.x, rect.y, rect.width, h);

            GUI.enabled = !uniformSamplerIterations.boolValue;
            currentProp = property.FindPropertyRelative("oceanSampler").FindPropertyRelative("iterations");
            r.y += h + BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            h = EditorGUI.GetPropertyHeight(currentProp);
            r.height = h;
            EditorGUI.PropertyField(r, currentProp);

            GUI.enabled = !uniformForce.boolValue;
            currentProp = property.FindPropertyRelative("force");
            r.y += h + BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            h = EditorGUI.GetPropertyHeight(currentProp);
            r.height = h;
            EditorGUI.PropertyField(r, currentProp);

            GUI.enabled = !uniformRadius.boolValue;
            currentProp = property.FindPropertyRelative("radius");
            r.y += h + BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            h = EditorGUI.GetPropertyHeight(currentProp);
            r.height = h;
            EditorGUI.PropertyField(r, currentProp);

            GUI.enabled = true;

            currentProp = property.FindPropertyRelative("localPosition");
            r.y += h + BuoyancyInfluencePropertyDrawer.PADDING_HEIGHT;
            h = EditorGUI.GetPropertyHeight(currentProp);
            r.height = h;
            EditorGUI.PropertyField(r, currentProp);*/
        }

        private void UpdateBuoyancyInfluencesListProperty(string propertyName)
        {
            for (int i = 0; i < buoyancyInfluencesList.count; i++)
            {
                SerializedProperty prop = buoyancyInfluencesList.serializedProperty.GetArrayElementAtIndex(i).FindPropertyRelative(propertyName);
            }
        }
    }
}