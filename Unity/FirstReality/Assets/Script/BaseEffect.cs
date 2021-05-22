using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BaseEffect : MonoBehaviour
{
    protected double startTime;
    protected double duration;
    // Start is called before the first frame update
    protected void Start()
    {
        startTime = Time.timeAsDouble;
    }

    // Update is called once per frame
    protected void Update()
    {
        if (GetCurrentTime() > duration)
            Destroy(gameObject);
    }

    public void SetDuration(double _duration)
    {
        duration = _duration;
    }

    public double GetCurrentTime()
    {
        return Time.timeAsDouble - startTime;
    }

    public GameObject FindGameObjectByName(GameObject go, string str)
    {
        if (go.name == str)
        {
            return go;
        }
        else
        {
            foreach (Transform child in go.transform)
            {
                GameObject currentGO = FindGameObjectByName(child.gameObject, str);
                if (currentGO != null)
                {
                    return currentGO;
                }
            }
        }
        return null;
    }

    public Material FindMaterial(GameObject go)
    {
        Renderer curRenderer = go.GetComponent<Renderer>();
        if (curRenderer != null)
        {
            return curRenderer.material;
        }
        else
        {
            foreach (Transform child in go.transform)
            {
                Material currentMaterial = FindMaterial(child.gameObject);
                if (currentMaterial != null)
                {
                    return currentMaterial;
                }
            }
        }
        return null;
    }

    public float fract(float v)
    {
        return v - Mathf.Floor(v);
    }

    public float smoothsteplin(float edge0, float edge1, float x)
    {
	    return Mathf.Clamp((x - edge0) / (edge1 - edge0), 0.0f, 1.0f);
    }
}
