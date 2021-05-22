/*
float hash13(in float3 p3)
{
    p3 = frac(p3 * .1031);
    p3 += dot(p3, p3.zyx + 31.32);
    return frac((p3.x + p3.y) * p3.z);
}

// returns 3D value noise and its 3 derivatives
float4 noised(in float3 x)
{
    float3 p = floor(x);
    float3 w = frac(x);

    float3 u = w * w * w * (w * (w * 6.0 - 15.0) + 10.0);
    float3 du = 30.0 * w * w * (w * (w - 2.0) + 1.0);

    float a = hash13(p + float3(0, 0, 0));
    float b = hash13(p + float3(1, 0, 0));
    float c = hash13(p + float3(0, 1, 0));
    float d = hash13(p + float3(1, 1, 0));
    float e = hash13(p + float3(0, 0, 1));
    float f = hash13(p + float3(1, 0, 1));
    float g = hash13(p + float3(0, 1, 1));
    float h = hash13(p + float3(1, 1, 1));

    float k0 = a;
    float k1 = b - a;
    float k2 = c - a;
    float k3 = e - a;
    float k4 = a - b - c + d;
    float k5 = a - c - e + g;
    float k6 = a - b - e + f;
    float k7 = -a + b + c - d + e - f - g + h;

    return float4(-1.0 + 2.0 * (k0 + k1 * u.x + k2 * u.y + k3 * u.z + k4 * u.x * u.y + k5 * u.y * u.z + k6 * u.z * u.x + k7 * u.x * u.y * u.z),
        2.0 * du * float3(k1 + k4 * u.y + k6 * u.z + k7 * u.y * u.z,
            k2 + k5 * u.z + k4 * u.x + k7 * u.z * u.x,
            k3 + k6 * u.x + k5 * u.y + k7 * u.x * u.y));
}
*/

// 3D noise function (IQ)
float noise(in float3 p)
{
	float3 ip = floor(p);
	p -= ip;
	float3 s = float3(7, 157, 113);
	float4 h = float4(0., s.yz, s.y + s.z) + dot(ip, s);
	p = p * p * (3. - 2. * p);
	h = lerp(frac(sin(h) * 43758.5), frac(sin(h + s.x) * 43758.5), p.x);
	h.xy = lerp(h.xz, h.yw, p.y);
	return lerp(h.x, h.y, p.z) - 0.5;
}


float GetHeight(in float3 p, in float s, in float a, in float t)
{
    float2 off1 = float2(sin(t / 8 + 2.1), sin(t / 7. + 5.2));
    float2 off2 = float2(sin(t / 8.5 + 3.1), sin(t / 9.8 + 7.2)) * 1.2;
    return a * (noise(float3((p.xz + off1) * s, 0)) + noise(float3((p.xz + off2) * s, 3)));
}

void Deform_float(in float3 LocalPosition, in float Time, in float Amplitude, in float Scale, in float modulate,out float3 NewPosition, out float3 Normal)
{
	//NewPosition = float3(LocalPosition.x, Amplitude * sin(LocalPosition.x) * sin(LocalPosition.y), LocalPosition.z);
	float height = GetHeight(LocalPosition, Scale, Amplitude, Time) * modulate;
	const float eps = 0.001;
	float height_dx = GetHeight(LocalPosition + float3(eps, 0, 0), Scale, Amplitude, Time) * modulate - height;
	float height_dz = GetHeight(LocalPosition + float3(0, 0, eps), Scale, Amplitude, Time) * modulate - height;
	NewPosition = float3(LocalPosition.x, height, LocalPosition.z);
	Normal = normalize(cross(float3(eps, height_dx, 0), float3(0, height_dz, eps)));
}

void GetColor_float(in float3 Position, in float Amplitude, out float3 Color)
{
    float3 col[3] = { float3(0.5, 0.0, 0.0), // Dark red
                      float3(0.0, 0.0, 1.0), // Blue
                      float3(1.0, 1.0, 1.0)  // White
                    };
    Color =  float3(0, 1, 0);

    float f = Position.y / Amplitude;

    if (f < 0.0)
    {
        Color = lerp(col[0], col[1], 1.0 + f);
    }
    else
    {
        Color = lerp(col[1], col[2], f);
    }
}