using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrollingEffect : BaseEffect
{
    Material mat;
    protected new void Start()
    {
        base.Start();
        mat = FindMaterial(FindGameObjectByName(this.gameObject, "Scroller"));
    }

    protected new void Update()
    {
        base.Update();
        float iTime = (float)GetCurrentTime();
        mat.SetFloat("Vector1_3ee004c8752344dbbd772d27c7b62114", iTime);
    }
}