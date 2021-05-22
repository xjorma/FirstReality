using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GlenzEffect : BaseEffect
{
    GameObject blueGlenz;
    GameObject redGlenz;
    GameObject blueGlenzPivot;
    GameObject redGlenzPivot;
    // Start is called before the first frame update
    protected new void Start()
    {
        base.Start();
        blueGlenz = FindGameObjectByName(this.gameObject, "BlueGlenz");
        redGlenz = FindGameObjectByName(this.gameObject, "RedGlenz");
        blueGlenzPivot = FindGameObjectByName(this.gameObject, "BluePivot");
        redGlenzPivot = FindGameObjectByName(this.gameObject, "RedPivot");
    }

    // Update is called once per frame
    protected new void Update()
    {
        base.Update();
        float iTime = (float)GetCurrentTime();
        // Blue Glenz Bounce
        // from https://www.shadertoy.com/view/XstXRj
        float phase = fract((iTime + 0.1f) / (220.0f / 60.0f) + 0.5f);
        float height = (phase - phase * phase) * 6.0f;
        phase = fract(phase + 0.025f);
        float squish = Mathf.Exp(-phase * 1.5f) * Mathf.Sin(phase * 12.0f) * 0.5f;
        float s = Mathf.Exp(squish);
        float invs = 1.0f / s;
        blueGlenz.transform.localPosition = new Vector3(blueGlenz.transform.localPosition.x, height + 0.35f, blueGlenz.transform.localPosition.z);
        blueGlenz.transform.localScale = new Vector3(s, invs, s);
        // Rotate
        blueGlenzPivot.transform.localRotation = Quaternion.Euler(iTime * 20 + 48, iTime * 25 + 71, iTime * 23 + 13);
        redGlenzPivot.transform.localRotation = Quaternion.Euler(iTime * 30 + 48, iTime * 40 + 71, iTime * 35 + 13);
        // Scale Fade in Fade out
        float fadeOut = smoothsteplin((float)duration, (float)duration - 0.5f, iTime);
        float blueScale = 50.0f * smoothsteplin(0.0f, 0.5f, iTime) * fadeOut;
        blueGlenzPivot.transform.localScale = new Vector3(blueScale, blueScale, blueScale);
        float redStart = 11.86f;
        float RedScale = 75.0f * smoothsteplin(redStart, redStart + 2.0f, iTime) * fadeOut;
        redGlenzPivot.transform.localScale = new Vector3(RedScale, RedScale, RedScale);
        // Red rotate around blue
        redGlenz.transform.localRotation = Quaternion.Euler(0.0f, iTime * 45.0f, 0.0f);
    }
}
