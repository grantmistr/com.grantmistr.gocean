using UnityEditor;
using UnityEditorInternal;
using UnityEngine;

namespace GOcean
{
    [CustomEditor(typeof(Floater))]
    public class FloaterEditor : Editor
    {
        private SerializedProperty
            uniformSamplerIterations,
            uniformForce,
            uniformRadius,
            samplerIterations,
            force,
            radius;

        private SerializedProperty buoyancyInfluences;
        private ReorderableList buoyancyInfluencesList;
        private Floater floater;

        private bool prevToolHiddenState = false;

        private void OnEnable()
        {
            floater = target as Floater;

            GetPropertyReferences();

            if (buoyancyInfluencesList == null)
            {
                buoyancyInfluencesList = new ReorderableList(serializedObject, buoyancyInfluences);
            }

            buoyancyInfluencesList.drawElementCallback += DrawBuoyancyInfluencesListElement;
            buoyancyInfluencesList.elementHeightCallback += GetDrawBuoyancyInfluencesListElementHeight;
            buoyancyInfluencesList.drawHeaderCallback += DrawBuoyancyInfluencesListHeader;

            prevToolHiddenState = Tools.hidden;
        }

        private void OnDisable()
        {
            buoyancyInfluencesList.drawElementCallback -= DrawBuoyancyInfluencesListElement;
            buoyancyInfluencesList.elementHeightCallback -= GetDrawBuoyancyInfluencesListElementHeight;
            buoyancyInfluencesList.drawHeaderCallback -= DrawBuoyancyInfluencesListHeader;

            Tools.hidden = prevToolHiddenState;
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            using (new GUILayout.HorizontalScope())
            {
                EditorGUILayout.PropertyField(uniformSamplerIterations);
                GUI.enabled = uniformSamplerIterations.boolValue;
                EditorGUILayout.PropertyField(samplerIterations, GUIContent.none);
                GUI.enabled = true;
            }
            using (new GUILayout.HorizontalScope())
            {
                EditorGUILayout.PropertyField(uniformForce);
                GUI.enabled = uniformForce.boolValue;
                EditorGUILayout.PropertyField(force, GUIContent.none);
                GUI.enabled = true;
            }
            using (new GUILayout.HorizontalScope())
            {
                EditorGUILayout.PropertyField(uniformRadius);
                GUI.enabled = uniformRadius.boolValue;
                EditorGUILayout.PropertyField(radius, GUIContent.none);
                GUI.enabled = true;
            }

            buoyancyInfluencesList.DoLayoutList();

            serializedObject.ApplyModifiedProperties();
        }

        private void OnSceneGUI()
        {
            bool mouseUp = Event.current.type == EventType.MouseUp;
            bool mouseDrag = Event.current.type == EventType.MouseDrag;
            bool mouseButtonLeft = Event.current.button == 0;
            bool buoyancyObjectIsSelected = buoyancyInfluencesList.selectedIndices.Count > 0;

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

                SerializedProperty currentElement = buoyancyInfluencesList.serializedProperty.GetArrayElementAtIndex(i);
                Vector3 localPosition = currentElement.FindPropertyRelative("localPosition").vector3Value;
                Vector3 worldPosition = floater.transform.localToWorldMatrix.MultiplyPoint(localPosition);
                float radius = uniformRadius.boolValue ? this.radius.floatValue : currentElement.FindPropertyRelative("radius").floatValue;

                // select new buoyancy object if it was clicked on
                if (Handles.Button(worldPosition, Quaternion.identity, radius, radius * 0.5f, Handles.SphereHandleCap))
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
                SerializedProperty selectedElement = buoyancyInfluencesList.serializedProperty.GetArrayElementAtIndex(buoyancyInfluencesList.selectedIndices[0]);
                SerializedProperty positionElement = selectedElement.FindPropertyRelative("localPosition");
                SerializedProperty radiusElement = selectedElement.FindPropertyRelative("radius");

                Vector3 worldPosition = floater.transform.localToWorldMatrix.MultiplyPoint(positionElement.vector3Value);

                serializedObject.Update();

                switch (Tools.current)
                {
                    case Tool.Move:
                        Vector3 newPosition = Handles.PositionHandle(worldPosition, floater.transform.rotation);
                        if (mouseDrag && mouseButtonLeft)
                        {
                            positionElement.vector3Value = floater.transform.worldToLocalMatrix.MultiplyPoint(newPosition);
                        }
                        break;
                    case Tool.Scale:
                        if (uniformRadius.boolValue)
                        {
                            break;
                        }
                        Vector3 scale = Handles.ScaleHandle(new Vector3(radiusElement.floatValue, radiusElement.floatValue, radiusElement.floatValue), worldPosition, floater.transform.rotation);
                        if (mouseDrag && mouseButtonLeft)
                        {
                            for (int i = 0; i < 3; i++)
                            {
                                if (scale[i] != radiusElement.floatValue)
                                {
                                    scale.x = scale[i];
                                    break;
                                }
                            }
                            radiusElement.floatValue = Mathf.Max(scale.x, 0.001f);
                        }
                        break;
                    default:
                        break;
                }

                serializedObject.ApplyModifiedProperties();

                if (Event.current.type == EventType.Repaint)
                {
                    Handles.color = new Color(0.7f, 0.2f, 0.1f, 0.5f);
                    float radius = uniformRadius.boolValue ? this.radius.floatValue : radiusElement.floatValue;
                    Handles.SphereHandleCap(-1, worldPosition, Quaternion.identity, radius, EventType.Repaint);
                }
            }

            Handles.color = prevColor;
        }

        private void GetPropertyReferences()
        {
            uniformSamplerIterations = serializedObject.FindProperty("uniformSamplerIterations");
            uniformForce = serializedObject.FindProperty("uniformForce");
            uniformRadius = serializedObject.FindProperty("uniformRadius");
            samplerIterations = serializedObject.FindProperty("samplerIterations");
            force = serializedObject.FindProperty("force");
            radius = serializedObject.FindProperty("radius");
            buoyancyInfluences = serializedObject.FindProperty("buoyancyInfluences");
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
            SerializedProperty currentProp;

            float h = 0f;
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
            EditorGUI.PropertyField(r, currentProp);
        }
    }
}