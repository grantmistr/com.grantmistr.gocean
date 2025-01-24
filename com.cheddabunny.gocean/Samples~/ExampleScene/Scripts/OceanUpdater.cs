using UnityEngine;
using GOcean;

public class OceanUpdater : MonoBehaviour
{
    private Ocean ocean;

    private float windSpeed;
    private float windDirection;
    private float turbulence;

    [SerializeField]
    private float timeScale = 1f;

    void Start()
    {
        ocean = GetComponent<Ocean>();
    }

    void Update()
    {
        float t = Time.timeSinceLevelLoad * timeScale;

        windSpeed = 11f + Mathf.Sin(t * 0.01f) * 10f;
        windDirection = Mathf.Sin(t * 0.001f) * Mathf.PI;
        turbulence = Mathf.Sin(t * 0.005f + 4.33f) * 0.2f + 0.3f;

        ocean.WindSpeed = windSpeed;
        ocean.WindDirection = new Vector2(Mathf.Cos(windDirection), Mathf.Sin(windDirection));
        ocean.Turbulence = turbulence;

        ocean.UpdateOnDemandDataBuffer();
    }
}
