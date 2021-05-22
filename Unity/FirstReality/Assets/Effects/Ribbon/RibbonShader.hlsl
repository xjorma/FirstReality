
float hash11(float p)
{
	p = frac(p * .1031);
	p *= p + 33.33;
	p *= p + p;
	return frac(p);
}

float4 hash41(float p)
{
	float4 p4 = frac(float4(p, p, p, p) * float4(.1031, .1030, .0973, .1099));
	p4 += dot(p4, p4.wzxy + 33.33);
	return frac((p4.xxyz + p4.yzzw) * p4.zywx);

}

float smoothsteplin(in float edge0, in float edge1, float x)
{
	return clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
}

float2 pR(in float2 p, float a)
{
	return cos(a) * p + sin(a) * float2(p.y, -p.x);
}

float4 ComputeRibbon(in float2 uv, in float angle, in float scale, in float2 offset)
{
	uv = uv * 2.0 - 1.0 + offset;
	uv *= scale;
	uv = pR(uv, angle);
	float alpha = step(0.5, frac(uv.x)) * step(abs(uv.x), 5);
	float3 color = float3(1, 1, 1) * alpha;
	return float4(color, alpha);
}

void effectSelect(in float t, out float4 scales, out float4 angles, out float2 offset)
{
	int effect = (int)float(t / 13) % 3;
	effect == 0;
	if (effect == 0)
	{
		float off = 0.025;
		scales = float4(1 + hash41(t * 53) * 0.2) * 3 + lerp(0.0, 1.0, (sin(t * 0.5) + 1.0) * 0.5);
		angles = float4(hash41(t * 123)) * 0.25 + t;
		offset = float2(0, 0);
	}
	else if (effect == 1)
	{
		t *= 5;
		float scale = lerp(12.0, 3.0, (sin(t * 0.5) + 1.0) * 0.5);
		scales = float4(scale, scale, scale, scale);
		angles = float4(0, 0.1, 0.2, 0.3) * sin(t * 1.0) * 15 + sin(t * 0.2) * 10 + t;
		offset = float2(sin(t), cos(t)) * 0.01;
	}
	else
	{
		t *= 5;
		float scale = lerp(15.0, 3.0, (sin(t) + 1.0) * 0.5);
		scales = float4(scale, scale, scale, scale);
		angles = float4(0, 0.1, 0.2, 0.3) * sin(t * 1.0) * 15 + sin(t * 0.2) * 10 + t;
		offset = float2(sin(t), cos(t)) * 0.3;
	}
}

void Ribbon_float(in float2 uv, in float time, out float3 color, out float alpha)
{
	// Fadein
	const float Fadein = 48.0 / 60.0;
	if (time < Fadein)
	{
		alpha = time / Fadein;
		color = float3(alpha, alpha, alpha);
		return;
	}
	time -= Fadein;
	const float ViewMeter = 30.0 / 60.0;
	if(time < ViewMeter * 4.0)
	{
		float fractTime = frac(time / ViewMeter);
		float floorTime = floor(time / ViewMeter);
		float pixLinPos = floor(uv.x * 4.0) + (1.0 - uv.y);
		float curLinPos = floorTime + min(1, fractTime / 0.6);
		alpha = max(step(curLinPos, pixLinPos), smoothsteplin(0.6, 0.8, fractTime) * smoothsteplin(1.0, 0.8, fractTime));
		color = float3(1, 1, 1);
		return;
	}
	time -= ViewMeter * 4.0;

	float a = 0;
	float v = 0;

	float4 scales;
	float4 angles;
	float2 offset;
	effectSelect(time, scales, angles, offset);

	for ( int i = 0; i < 4; i++)
	{
		float4 nc = ComputeRibbon(uv, angles[i], scales[i], offset);
		if (nc.w > 0.5)
		{
			v += 0.25;
		}
	}
	alpha = v;
	color = lerp(float3(1,0.75,1), float3(1, 1, 1), v);
}