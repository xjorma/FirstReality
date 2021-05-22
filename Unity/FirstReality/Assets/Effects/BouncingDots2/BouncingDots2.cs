using UnityEngine;
using System.Collections;

public class BouncingDots2 : BaseEffect
{
    public int instanceCount = 512;
    public Mesh instanceMesh;
    public Material instanceMaterial;
    public int subMeshIndex = 0;
    public ComputeShader compute;

    private ComputeBuffer simulationBuffer;
    private ComputeBuffer positionBuffer;
    private ComputeBuffer argsBuffer;

    private int frame = 0;
    private int lastFrame = 0;
    private int groupSize = 0;
    private int kernelSimulate;

    protected new void Start()
    {
        base.Start();
        // Arg Buffer
        uint[] args = new uint[5] { 0, 0, 0, 0, 0 };
        args[0] = (uint)instanceMesh.GetIndexCount(subMeshIndex);
        args[1] = (uint)instanceCount;
        args[2] = (uint)instanceMesh.GetIndexStart(subMeshIndex);
        args[3] = (uint)instanceMesh.GetBaseVertex(subMeshIndex);
        argsBuffer = new ComputeBuffer(1, args.Length * sizeof(uint), ComputeBufferType.IndirectArguments);
        argsBuffer.SetData(args);
        // Instance Position
        simulationBuffer = new ComputeBuffer(instanceCount, sizeof(float) * 4);
        positionBuffer = new ComputeBuffer(instanceCount, sizeof(float) * 4);
        instanceMaterial.SetBuffer("positionBuffer", positionBuffer);
        // Init compute
        kernelSimulate = compute.FindKernel("Simulate");
        uint gX, gY, gZ;
        compute.GetKernelThreadGroupSizes(kernelSimulate, out gX, out gY, out gZ);
        groupSize = (int)gX;
        UpdateSimulation(0);
    }
    void UpdateSimulation(int curFrame)
    {
        compute.SetBuffer(kernelSimulate, "simulationBuffer", simulationBuffer);
        compute.SetBuffer(kernelSimulate, "positionBuffer", positionBuffer);
        compute.SetInt("iFrame", curFrame);
        compute.Dispatch(kernelSimulate, instanceCount / groupSize, 1, 1);
    }
    protected new void Update()
    {
        frame = (int)(GetCurrentTime() * 60.0);
        for (int i = lastFrame; i < frame; i++)
        {
            UpdateSimulation(i);
        }
        lastFrame = frame;
        Vector3 position = transform.position;
        instanceMaterial.SetVector("_WorldPosition", new Vector4(position.x, position.y, position.z, 0));
        Graphics.DrawMeshInstancedIndirect(instanceMesh, subMeshIndex, instanceMaterial, new Bounds(Vector3.zero, new Vector3(100.0f, 100.0f, 100.0f)), argsBuffer);
        base.Update();
    }

    void OnDisable()
    {
        simulationBuffer.Release();
        simulationBuffer = null;
        positionBuffer.Release();
        positionBuffer = null;
        argsBuffer.Release();
        argsBuffer = null;
    }
}