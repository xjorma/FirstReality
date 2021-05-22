using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RibbonEffect : BaseEffect
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
        float fade = smoothsteplin((float)duration, (float)duration - 1.0f, iTime);
        mat.SetFloat("Vector1_4cc311b29ba14d2aba73a4d1d4c319aa", iTime);
        mat.SetFloat("Vector1_df03cd86d8d243ac874be0277d0a753d", fade);
    }
}
