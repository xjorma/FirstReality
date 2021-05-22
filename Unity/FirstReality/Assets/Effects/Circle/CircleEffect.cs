using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CircleEffect : BaseEffect
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
        float fade = smoothsteplin(0.0f, 1.0f, iTime) * smoothsteplin((float)duration, (float)duration - 1.0f, iTime);
        mat.SetFloat("Vector1_d46c0beff35f4e698e4c6374c78ba697", fade);
    }
}
