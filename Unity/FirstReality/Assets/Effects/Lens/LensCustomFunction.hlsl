void Reflection_float(in float4 ScreenSpacePosition, in float3 Normal, out float2 UV)
{
	UV = ScreenSpacePosition.xy + refract(float3(0,0,-1), Normal, 0.6).xy * 0.15;
}