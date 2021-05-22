using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlasmaEffect : BaseEffect
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
        mat.SetFloat("Vector1_10c53d6289c74e508a50ef792897d8d1", fade);
        mat.SetFloat("Vector1_6a413ca394c4450db6e83a6541048172", iTime);
    }
}
