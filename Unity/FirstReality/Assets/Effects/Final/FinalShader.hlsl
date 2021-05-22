void Deform_float(in float3 oldPosition, in float3 oldNormal,in float squish,out float3 newPosition, out float3 newNormal)
{
	float y = abs(oldPosition.y * 2.0);
	float x = sqrt(1.0 - y * y);
	newPosition = oldPosition;
	newPosition.xz *= squish * x + 1.0;
	float3 absNormal = abs(oldNormal);
	if (absNormal.y > absNormal.x && absNormal.y > absNormal.z)
	{
		newNormal = oldNormal;
	}
	else if (absNormal.x > absNormal.z)
	{
		newNormal = normalize(float3(sign(oldNormal.x) * x, sign(oldPosition.y) * y * squish, 0));
	}
	else
	{
		newNormal = normalize(float3(0, sign(oldPosition.y) * y * squish, sign(oldNormal.z) * x));
	}
}