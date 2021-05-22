using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FinalBounceEffect : BaseEffect
{
    private Material finalMaterial;
    private GameObject cube;
    // Start is called before the first frame update
    protected new void Start()
    {
        base.Start();
        cube = FindGameObjectByName(this.gameObject, "Cube");
        finalMaterial = FindMaterial(cube);
    }

    // Update is called once per frame
    protected new void Update()
    {
        base.Update();
        // Compute height and scale
        // from https://www.shadertoy.com/view/XstXRj
        float iTime = (float)GetCurrentTime();
        float phase = fract(iTime * 0.5f);
        float height = (phase - phase * phase) * 6.0f;
        phase = fract(phase + 0.025f);
        float squish = Mathf.Exp(-phase * 1.5f) * Mathf.Sin(phase * 12.0f) * 0.5f;
        float s = Mathf.Exp(squish);
        float invs = 1.0f / s;
        // Set height and scale
        cube.transform.localPosition = new Vector3(cube.transform.localPosition.x, height + 0.35f, cube.transform.localPosition.z);
        float scale = smoothsteplin(0.0f, 1.0f, iTime) * smoothsteplin((float)duration, (float)duration - 1.0f, iTime);
        cube.transform.localScale = new Vector3(1, invs, 1) * scale;
        finalMaterial.SetFloat("Vector1_d57198ce5d574afe8715d37b5f26691c",s - 1.0f);
    }
}
