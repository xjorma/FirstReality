using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RisingSwordScript : BaseEffect
{
    private Material swordMaterial;
    protected new void Start()
    {
        base.Start();
        swordMaterial = FindMaterial(gameObject);
    }

    // Update is called once per frame
    protected new void Update()
    {
        base.Update();
        float iTime = (float)GetCurrentTime();
        float fade = smoothsteplin(0.0f, 1.0f, iTime) * smoothsteplin((float)duration, (float)duration - 1.0f, iTime);
        swordMaterial.SetFloat("Vector1_abbf859e97484345b84e971d62e58cbb", iTime);
        swordMaterial.SetFloat("Vector1_54f31a255f574dae9c3d7e9fa6836b2d", fade);
    }
}