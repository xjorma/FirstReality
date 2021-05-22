using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlasmaCubeEffect : BaseEffect
{
    GameObject cube;
    protected new void Start()
    {
        base.Start();
        cube = FindGameObjectByName(this.gameObject, "PlasmaCube");
    }

    // Update is called once per frame
    protected new void Update()
    {
        base.Update();
        float iTime = (float)GetCurrentTime();
        cube.transform.localRotation = Quaternion.Euler(iTime * 30 + 48, iTime * 40 + 71, iTime * 35 + 13);
        float scale = 1.0f * smoothsteplin(0.0f, 0.5f, iTime) * smoothsteplin((float)duration, (float)duration - 0.5f, iTime);
        cube.transform.localScale = new Vector3(scale, scale, scale);
    }
}
