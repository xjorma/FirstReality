using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotozoomEffect : BaseEffect
{
    Material mat;
    protected new void Start()
    {
        base.Start();
        mat = FindMaterial(gameObject);
    }

    protected new void Update()
    {
        base.Update();
        float iTime = (float)GetCurrentTime();
        float fade = smoothsteplin(0.0f, 0.5f, iTime) * smoothsteplin((float)duration, (float)duration - 0.5f, iTime);
        mat.SetFloat("Vector1_862e21c0cd1d47909beb0faaf87bad12", fade);
        mat.SetFloat("Vector1_4ba72aa7bdb147e7883a6d88e56eccff", iTime);
    }
}
