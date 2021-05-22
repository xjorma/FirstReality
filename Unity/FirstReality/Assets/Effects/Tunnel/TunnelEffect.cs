using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TunnelEffect : BaseEffect
{
    GameObject tunnel;
    Material mat;
    protected new void Start()
    {
        base.Start();
        tunnel = FindGameObjectByName(this.gameObject, "Tunnel");
        mat = FindMaterial(tunnel.gameObject);
    }

    protected new void Update()
    {
        base.Update();
        float iTime = (float)GetCurrentTime();
        tunnel.transform.localPosition = new Vector3(tunnel.transform.localPosition.x, tunnel.transform.localPosition.y, - iTime * 1.5f);
        mat.SetFloat("Vector1_31c9d857310e4611b3257b2c27f24669", iTime);
    }
}