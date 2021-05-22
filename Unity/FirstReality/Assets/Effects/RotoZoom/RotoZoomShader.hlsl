float2 pR(in float2 p, float a)
{
	return cos(a) * p + sin(a) * float2(p.y, -p.x);
}

void RotoZoom_float(in float2 uv, UnityTexture2D tex, in float time, out float3 outColor, out float alpha)
{
	uv -= 0.5;
	uv = pR(uv, sin(time * 0.2) * 5.0);
	uv *= 3.0 - cos(time * 0.31) * 2.0;
	uv += 0.5;
	outColor = tex.SampleLevel(tex.samplerstate, uv, 0).rgb;
	alpha = step(0.01, dot(outColor, outColor));
}