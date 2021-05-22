Shader "BouncingDots2/BouncingDots2Shader"
{
    Properties
    {
        _WorldPosition("World Position", Vector) = (0, 2, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline" }
        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            StructuredBuffer<float4> positionBuffer;

            float4 _WorldPosition;

            struct Attributes
            {
                float4  positionOS  : POSITION;
                float3  normal      : NORMAL;
                uint    instanceID  : SV_InstanceID;
            };

            struct v2f
            {
                float4 pos          : SV_POSITION;
                float3 normal       : NORMAL0;
            };

            v2f vert(Attributes v, uint instanceID : SV_InstanceID)
            {
                float4 data = positionBuffer[instanceID];

                float3 worldPosition = data.xyz + v.positionOS.xyz * data.w + _WorldPosition;

                v2f o;
                o.pos = mul(UNITY_MATRIX_VP, float4(worldPosition, 1.f));
                o.normal = v.normal;
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                Light light = GetMainLight();
                float lightDir = light.direction;
                float v = max(0, dot(i.normal, light.direction)) + 0.4;
                half4   output = half4(float3(v, v, v), 1.);
                return output;
            }

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            StructuredBuffer<float4> positionBuffer;

            float4 _WorldPosition;

            struct Attributes
            {
                float4  positionOS  : POSITION;
                uint    instanceID  : SV_InstanceID;
            };

            struct v2f
            {
                float4 pos          : SV_POSITION;
            };

            v2f vert(Attributes v, uint instanceID : SV_InstanceID)
            {
                float4 data = positionBuffer[instanceID];

                float3 worldPosition = data.xyz + v.positionOS.xyz * data.w + _WorldPosition;

                v2f o;
                o.pos = mul(UNITY_MATRIX_VP, float4(worldPosition, 1.f));
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                return half4(1, 1, 1, 1);
            }

            ENDHLSL
        }
    }
}