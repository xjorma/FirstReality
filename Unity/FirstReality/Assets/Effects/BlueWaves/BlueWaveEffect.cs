using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlueWaveEffect : BaseEffect
{
    Material mat;
    GameObject blueWaves;
    protected new void Start()
    {
        base.Start();
        blueWaves = FindGameObjectByName(this.gameObject, "BlueWaves");
        mat = FindMaterial(blueWaves.gameObject);
    }

    protected new void Update()
    {
        base.Update();
        float iTime = (float)GetCurrentTime();
        float modulate = smoothsteplin(1.0f, 2.0f, iTime) * smoothsteplin((float)duration - 1.0f, (float)duration - 2.0f, iTime);
        float scale = 2.5f * smoothsteplin(0.0f, 1.0f, iTime) * smoothsteplin((float)duration, (float)duration - 1.0f, iTime);
        mat.SetFloat("Vector1_a7d58740c84242ca9265175cb4d43376", modulate);
        blueWaves.transform.localScale = new Vector3(scale, scale, scale);
    }
}
