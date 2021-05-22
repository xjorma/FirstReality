using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

public class MainScript : MonoBehaviour
{
    [System.Serializable]
    public class EffectEntry
    {
        public GameObject prefab;
        public Color color;
        public float start;
        public float end;
        internal GameObject spawnedEntity;
        internal Vector3 position;
        internal Quaternion rotation;
    }
    private ARRaycastManager rayManager;
    private GameObject iconInstance;
    private GameObject arInstance;
    private GameObject emulationInstance;
    private Camera curCamera;
    private Material iconMaterial;
    private int curPlacingObject;
    private bool running;
    private double startTime;
    private double prevTime;
    private AudioSource music;
    private bool emulation;
    private bool finalTap;
    public GameObject iconPrefab;
    public GameObject arPrefab;
    public GameObject emulationPrefab;
    [SerializeField]
    public EffectEntry[] effects;
    // Start is called before the first frame update
    void Start()
    {
        running = false;
        finalTap = false;
        // Disable screen dimming
        Screen.sleepTimeout = SleepTimeout.NeverSleep;

        // Music
        music = gameObject.GetComponent<AudioSource>();

        // Running on PC?
        emulation = Application.platform != RuntimePlatform.Android;

        if (emulation)
        {
            emulationInstance = Instantiate(emulationPrefab, new Vector3(0, 0, 0), Quaternion.identity);
            StartDemo();
        }
        else
        {
            arInstance = Instantiate(arPrefab, new Vector3(0, 0, 0), Quaternion.identity);
            // Get components for raycast
            rayManager = FindObjectOfType<ARRaycastManager>();
            curCamera = FindObjectOfType<ARCameraManager>().gameObject.GetComponent<Camera>();
            iconInstance = Instantiate(iconPrefab, new Vector3(0, 0, 0), Quaternion.identity);
            iconMaterial = FindMaterial(iconInstance);
            curPlacingObject = 0;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (running)
        {
            DemoUpdate();
        }
        else if (finalTap)
        {
            if (Input.touchCount > 0 && Input.touches[0].phase == TouchPhase.Began)
            {
                finalTap = false;
                StartDemo();
            }
        }
        else
        {
            PlaceObject();
        }
    }

    void StartDemo()
    {
        running = true;
        startTime = Time.timeAsDouble;
        prevTime = -1000;
        music.Play(0);
    }

    void DemoUpdate()
    {
        double curTime = Time.timeAsDouble - startTime;
        foreach (EffectEntry effect in effects)
        {
            double effectTime = (double)effect.start / 60.0;
            if (effectTime > prevTime && effectTime <= curTime)
            {
                effect.spawnedEntity = Instantiate(effect.prefab, effect.position, effect.rotation);
                effect.spawnedEntity.GetComponent<BaseEffect>().SetDuration((effect.end - effect.start) / 60.0);
            }
        }
        prevTime = curTime;
    }

    void PlaceObject()
    {
        EffectEntry curEffect = effects[curPlacingObject];
        iconMaterial.SetColor("Color_6d45492d925d4165ba3a33a2a1d54548", curEffect.color);
        // Shoot raycast
        List<ARRaycastHit> hits = new List<ARRaycastHit>();
        rayManager.Raycast(new Vector2(Screen.width / 2, Screen.height / 2), hits, TrackableType.Planes);
        if (hits.Count > 0)
        {
            Pose pose = hits[0].pose;
            if (curCamera != null)
            {
                Vector3 cameraForward = curCamera.transform.forward;
                Vector3 cameraHorizontalForward = new Vector3(cameraForward.x, 0.0f, cameraForward.z).normalized;
                pose.rotation = Quaternion.LookRotation(cameraHorizontalForward);

                iconInstance.transform.position = pose.position;
                iconInstance.transform.rotation = pose.rotation;
                if (Input.touchCount > 0 && Input.touches[0].phase == TouchPhase.Began)
                {
                    curEffect.position = pose.position;
                    curEffect.rotation = pose.rotation;
                    curPlacingObject++;
                    if(curPlacingObject == effects.Length)
                    {
                        finalTap = true;
                        Destroy(iconInstance);
                        iconMaterial = null;
                    }
                    //Instantiate(curEffect.prefab, pose.position, pose.rotation);
                }
            }
        }
    }

    Material FindMaterial(GameObject go)
    {
        Renderer curRenderer = go.GetComponent<Renderer>();
        if(curRenderer != null)
        {
            return curRenderer.material;
        }
        else
        {
            foreach (Transform child in go.transform)
            {
                Material currentMaterial = FindMaterial(child.gameObject);
                if(currentMaterial != null)
                {
                    return currentMaterial;
                }
            }
        }
        return null;
    }
}
