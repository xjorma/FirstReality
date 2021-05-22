

void UpdatePosition_float(in float3 OrgPosition, in float Time, in float Depth, out float3 NewPosition)
{
	Time += Depth * 4.0;
	float2 offset = float2(sin(Time * 1.2 + 2.56), sin(Time * 0.9 + 4.67)) * float2(0.6, 0.4);
	NewPosition = float3(OrgPosition.xy + offset, OrgPosition.z);
}