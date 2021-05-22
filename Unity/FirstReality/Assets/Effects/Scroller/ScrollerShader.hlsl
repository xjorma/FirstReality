
float height(in float3 position, in float iTime)
{
	const float waveHeight = 0.008;
	float height = 0.0;
	height += sin(position.x * 10 - iTime * 1) * waveHeight * 1.0;
	height += sin(position.x * 12 + position.z * 5 - iTime * 1.2) * waveHeight * 1.2;
	height += sin(position.x * 13 - position.z * 4 - iTime * 0.8) * waveHeight * 0.8;
	return height;
}

void Deform_float(in float3 position, in float iTime, out float3 newPosition, out float3 normal)
{
	float2 eps = float2(0.01,0);
	float h = height(position, iTime);
	float dx = height(position + eps.xyy, iTime) - h;
	float dy = height(position + eps.yyx, iTime) - h;
	position.y += h;
	newPosition = position;
	normal = normalize(cross(float3(eps.x, dx, 0), float3(0, dy, eps.x)));
}



void Scroller_float(in UnityTexture2D text,in float iTime, float3 position,out float3 color, out float alpha)
{
	float2 uv = position.xz;
	uv.y += 0.5;
	uv.x *= 64.0/1024.0;			// Texture Ratio
	uv.x += iTime * 0.02;
	color = text.SampleLevel(text.samplerstate, uv, 0).rgb;
	alpha = step(0.01, dot(color.xyz, color.xyz));
}