#ifndef GOCEAN_HDRP_SHADOWDEFINES
    #define GOCEAN_HDRP_SHADOWDEFINES

    #ifndef HDSHADOWMANAGER_CS_HLSL
        #define HDSHADOWMANAGER_CS_HLSL

        // mapSize = Light.shadows.shadowMap.resolution ?
        // atlasSize.x = mapSize << (cascadeCount > 1)
        // atlasSize.y = mapSize << (cascadeCount > 2)
        // atlasOffset.x = targetCascade % 2 == 0 ? 0.5 : 0.0
        // atlasOffset.y = targetCascade / 2 <  1 ? 0.0 : 0.5

        struct HDShadowData
        {
            float3 rot0;
            float3 rot1;
            float3 rot2;
            float3 pos;
            float4 proj;
            float2 atlasOffset;
            float worldTexelSize;
            float normalBias;
            float4 zBufferParam;
            float4 shadowMapSize;
            float4 shadowFilterParams0;
            float4 dirLightPCSSParams0;
            float4 dirLightPCSSParams1;
            float3 cacheTranslationDelta;
            float isInCachedAtlas;
            float4x4 shadowToWorld;
        };

        struct HDDirectionalShadowData
        {
            float4 sphereCascades[4];
            float4 cascadeDirection;
            float cascadeBorders[4];
            float fadeScale;
            float fadeBias;
        };

    #endif // HDSHADOWMANAGER_CS_HLSL

    #ifndef HD_SHADOW_CONTEXT_HLSL
        #define HD_SHADOW_CONTEXT_HLSL
        #define HAVE_HD_SHADOW_CONTEXT

        struct HDShadowContext
        {
            StructuredBuffer<HDShadowData> shadowDatas;
            HDDirectionalShadowData directionalShadowData;
        };

        Texture2D _ShadowmapAtlas;
        Texture2D _CachedShadowmapAtlas;
        Texture2D _ShadowmapCascadeAtlas;
        Texture2D _ShadowmapAreaAtlas;
        Texture2D _CachedAreaLightShadowmapAtlas;

        StructuredBuffer<HDShadowData> _HDShadowDatas;
        StructuredBuffer<HDDirectionalShadowData> _HDDirectionalShadowData;

        HDShadowContext InitShadowContext()
        {
            HDShadowContext sc;

            sc.shadowDatas = _HDShadowDatas;
            sc.directionalShadowData = _HDDirectionalShadowData[0];

            return sc;
        }

    #endif // HD_SHADOW_CONTEXT_HLSL

#endif // GOCEAN_HDRP_SHADOWDEFINES