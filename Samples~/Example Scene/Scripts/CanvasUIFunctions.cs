using UnityEngine;

namespace GOcean
{
    public class CanvasUIFunctions : MonoBehaviour
    {
        public void SetWaterHeight(float value)
        {
            Ocean.Instance.WaterHeight = value;
            Ocean.Instance.UpdateOnDemandDataBuffer();
        }

        public void SetWindDirection(float value)
        {
            Vector2 direction = new Vector2(Mathf.Cos(value), Mathf.Sin(value));
            Ocean.Instance.WindDirection = direction;
            Ocean.Instance.UpdateOnDemandDataBuffer();
        }

        public void SetWindSpeed(float value)
        {
            Ocean.Instance.WindSpeed = value;
            Ocean.Instance.UpdateOnDemandDataBuffer();
        }

        public void SetTurbulence(float value)
        {
            Ocean.Instance.Turbulence = value;
            Ocean.Instance.UpdateOnDemandDataBuffer();
        }
    }
}
