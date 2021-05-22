using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LensEffect : BaseEffect
{
    GameObject lens;
    protected new void Start()
    {
        base.Start();
        lens = FindGameObjectByName(this.gameObject, "Lens");
    }

    // Update is called once per frame
    protected new void Update()
    {
        base.Update();
        float iTime = (float)GetCurrentTime();
        // Blue Glenz Bounce
        // from https://www.shadertoy.com/view/XstXRj
        float phase = fract(iTime / (220.0f / 60.0f) + 0.5f);
        float height = (phase - phase * phase) * 6.0f;
        phase = fract(phase + 0.025f);
        float squish = Mathf.Exp(-phase * 1.5f) * Mathf.Sin(phase * 12.0f) * 0.5f;
        float s = Mathf.Exp(squish);
        float invs = 1.0f / s;
        lens.transform.localPosition = new Vector3(lens.transform.localPosition.x, height + 0.35f, lens.transform.localPosition.z); ;
        float fade = smoothsteplin((float)duration, (float)duration - 0.5f, iTime) * smoothsteplin(0.0f, 0.5f, iTime);
        lens.transform.localScale = new Vector3(s, invs, s) * fade;
    }
}