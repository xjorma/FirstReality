
#define MAXDIST 100.0

float sphIntersect(in float3 ro, in float3 rd, in float3 ce, float ra)
{
    float3 oc = ro - ce;
    float b = dot(oc, rd);
    float c = dot(oc, oc) - ra * ra;
    float h = b * b - c;
    if (h < 0.0) return MAXDIST; // no intersection
    h = sqrt(h);
    float t = -b - h;
    if(t > 0)
        return -b - h;
    else
        return MAXDIST;
}

float floorIntersect(in float3 ro, in float3 rd)
{
    if (rd.y < -0.01)
    {
        return ro.y / -rd.y;
    }
    return MAXDIST;
}

float2 pR(in float2 p, float a)
{
    return cos(a) * p + sin(a) * float2(p.y, -p.x);
}


float SwordIntersect(in float3 ro, in float3 rd, float iTime, UnityTexture2D sword, out float3 color)
{
    float t = ro.z / -rd.z;
    float3 pos = ro + t * rd;
    float2 uv = pos.xy;
    uv = pR(uv, radians(- 70)) * 0.25;
    uv.y *= 8;
    uv += float2(0.5, 0.5);
    uv.x += iTime / 25.0 - 0.5;;
    color = sword.SampleLevel(sword.samplerstate, uv, 0).rgb;
    if (t > 0 && dot(color, color) > 0.05)
        return t;
    else 
        return MAXDIST;
}

float2 minVec(float2 v0, float2 v1)
{
    if (v0.x < v1.x)
    {
        return v0;
    }
    else
    {
        return v1;
    }
}

float3 getSkyColor(in float3 rd, in UnityTextureCube envMap)
{
    return envMap.Sample(envMap.samplerstate, rd).rgb * float3(0.5,0.5,1.0);
}

void intersectScene2(in float3 ro, in float3 rd, in float iTime, UnityTextureCube envMap, UnityTexture2D sword, out float3 color, out float alpha)
{
    const float3 sphCenter0 = float3(0.5, 0.20, 0.5);
    const float3 sphCenter1 = float3(0.5, 0.20, -0.5);
    float2 sph0 = float2(sphIntersect(ro, rd, sphCenter0, 0.45), 0);
    float2 sph1 = float2(sphIntersect(ro, rd, sphCenter1, 0.45), 1);
    float2 plane = float2(floorIntersect(ro, rd), 2);
    float3 swordCol;
    float2 swordInter = float2(SwordIntersect(ro, rd, iTime, sword, swordCol), 3);
    float2 t = minVec(minVec(minVec(sph0, sph1), plane), swordInter);
    float3 position = ro + t.x * rd;
    if (t.x < MAXDIST && position.y > -0.01 && max(abs(position.x), abs(position.z)) < 1.0)
    {
        float3 normal;
        if (t.y > 2.5)   // Sword
        {
            color = swordCol;
            alpha = 1;
            return;
        }
        if (t.y < 0.5)  // Sph0
        {
            normal = normalize(position - sphCenter0);
        }
        else if (t.y < 1.5) // sph1
        {
            normal = normalize(position - sphCenter1);
        }
        else // Plane
        {
            float d = length(position.xz);
            float2 dir = position.xz / d;
            float s = sin(d * 15.0 - iTime * 2.0);
            normal = normalize(float3(s * dir.x, 7.0, s * dir.y));
        }
        color = getSkyColor(reflect(rd, normal), envMap);
    }
    else
    {
        color = float3(0, 1, 0);
        alpha = 0;
    }
}


void intersectScene(in float3 ro, in float3 rd, in float iTime, UnityTextureCube envMap, UnityTexture2D sword, out float3 color, out float alpha, in float fade)
{
    const float3 sphCenter0 = float3(0.5, 0.20, 0.5);
    const float3 sphCenter1 = float3(0.5, 0.20, -0.5);
    float2 sph0 = float2(sphIntersect(ro, rd, sphCenter0, 0.45), 0);
    float2 sph1 = float2(sphIntersect(ro, rd, sphCenter1, 0.45), 1);
    float2 plane = float2(floorIntersect(ro, rd), 2);
    float3 swordCol;
    float2 swordInter = float2(SwordIntersect(ro, rd, iTime, sword, swordCol), 3);
    float2 t = minVec(minVec(minVec(sph0, sph1), plane), swordInter);
    float3 position = ro + t.x * rd;
    if (t.x < MAXDIST && position.y > -0.01 && max(abs(position.x), abs(position.z)) < fade)
    {
        float3 normal;
        if (t.y > 2.5)   // Sword
        {
            color = swordCol;
            alpha = 1;
            return;
        }
        if (t.y < 0.5)  // Sph0
        {
            normal = normalize(position - sphCenter0);
        }
        else if (t.y < 1.5) // sph1
        {
            normal = normalize(position - sphCenter1);
        }
        else // Plane
        {
            float d = length(position.xz);
            float2 dir = position.xz / d;
            float s = sin(d * 15.0 - iTime * 2.0);
            normal = normalize(float3(s * dir.x, 7.0, s * dir.y));
        }
        #if 0
            float3 nrd = reflect(rd, normal);
            color = getSkyColor(nrd, envMap);
            color = nrd;
        #else
            float3 nrd = reflect(rd, normal);
            intersectScene2(position, nrd, iTime, envMap, sword, color, alpha);
            if (alpha < 0.5)
            {
                color = getSkyColor(nrd, envMap);
                //color = float3(1, 0, 1);
            }
        #endif
        alpha = 1;
    }
    else
    {
        color = float3(0,1,0);
        alpha = 0;
    }
}


void RayMarch_float(in UnityTextureCube envMap, in UnityTexture2D sword, in float3 ro, in float3 rd, in float iTime, in float fade, out float3 color, out float alpha)
{
    /*
    if (SwordIntersect(ro, rd, iTime, sword, color) != MAXDIST)
        alpha = 1;
    else
        alpha = 0;
    */

    intersectScene(ro, rd, iTime, envMap, sword, color, alpha, fade);
/*
    float3 inter, normal;
    if(intersectScene(ro, rd, iTime, envMap, sword, inter, normal))
    {
        color = getSkyColor(reflect(rd, normal), envMap);
        alpha = 1;
    }
    else
    {
        color = float3(0,0,0);
        alpha = 0;
    }
   */ 
}