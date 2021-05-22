using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

public class GetCameraTexture : MonoBehaviour
{
    private ARCameraBackground cameraBackground;
    private RenderTexture cameraTexture;
    private MeshRenderer meshRenderer;
    public Texture TestTexture;
    // Start is called before the first frame update
    void Start()
    {
        if (Application.platform == RuntimePlatform.Android)
        {
            cameraBackground = FindObjectOfType<ARCameraBackground>();
            cameraTexture = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGB32);
            meshRenderer = gameObject.GetComponent<MeshRenderer>();
            //meshRenderer.material.SetColor("Color_9125ff2d5da74008a280570cd6ce254c", new Color(0.8f, 0.8f, 0.1f));
            meshRenderer.material.SetTexture("Texture2D_86b77d9a79f743e181d4aff84e826b04", cameraTexture);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (Application.platform == RuntimePlatform.Android)
        {
            Graphics.Blit(null, cameraTexture, cameraBackground.material);
        }
    }
}
