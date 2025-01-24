using UnityEngine;

namespace GOcean
{
    using PropIDs = ShaderPropertyIDs;
    using static Helper;

    public class Wind : Component
    {
        public float windSpeedMin;
        public float windSpeedMax;

        private Vector2 windDirection;
        public Vector2 WindDirection
        {
            get
            {
                return windDirection;
            }
            set
            {
                windDirection = value.normalized;
                components.Terrain.UpdateDirectionalInfluence(windDirection);
            }
        }

        private float windSpeed;
        public float WindSpeed
        {
            get
            {
                return windSpeed;
            }
            set
            {
                windSpeed = CalculateWindSpeed(value, windSpeedMin, windSpeedMax);
                components.Caustic.UpdateCausticStrength(windSpeed);
                components.Underwater.UpdateLightRayStrength(windSpeed);
            }
        }

        public Wind()
        {
        }

        public override void Initialize()
        {
            InitializeParams(ocean.parametersUser.wind);
        }

        public override void InitializeParams(BaseParamsUser userParams)
        {
            WindParamsUser u = userParams as WindParamsUser;

            WindDirection = CalculateWindDirection(u.windDirection);
            windSpeedMin = u.windSpeedMin;
            windSpeedMax = u.windSpeedMax;
            WindSpeed = u.windSpeed;
        }

        private Vector2 CalculateWindDirection(float windDirection)
        {
            return new Vector2(Mathf.Cos(windDirection), Mathf.Sin(windDirection));
        }

        private float CalculateWindSpeed(float windSpeed, float windSpeedMin, float windSpeedMax)
        {
            return Mathf.Clamp(windSpeed, windSpeedMin, windSpeedMax);
        }
    }
}