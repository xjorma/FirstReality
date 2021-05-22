float mod(float x, float y)
{
    return x - y * floor(x / y);
}

void Circle_float(in float2 uv, in float time, out float3 color, out float alpha)
{
    uv *= 2.0;
    float2 board1Center = float2(1.0 + 0.6 * sin(1.4 * time), 0.5 + 0.5 * cos(1.4 * time));
    float2 board2Center = float2(1.2 + 0.5 * sin(2.2 * time), 0.3 + 0.4 * cos(2.2 * time));

    float board1RingSize = 0.07;
    float board1PulseSpeed = 5.0f;
    float board2RingSize = 0.07;

    float intensity = 1.0 - mod(-board1PulseSpeed * time + distance(board1Center, uv) / board1RingSize, 1.0);

    float intensityXor = mod(-board1PulseSpeed * time + distance(board1Center, uv) / board1RingSize, 1.0); 

    float2 board2DistortUv = float2(uv.x + 0.2 * sin(time + 3.0 * uv.x), uv.y + 0.2 * sin(1.1 * time + 2.0 * uv.y));
    float xorPhase = floor(mod(distance(board2Center, board2DistortUv) / board2RingSize, 2.0));

    color = float3(intensity * xorPhase + intensityXor * (1.0 - xorPhase), 0.8 * intensity * xorPhase + intensityXor * (1.0 - xorPhase), intensity * xorPhase + intensityXor * (1.0 - xorPhase));
    alpha = color.r * smoothstep(1.0, 0.9, distance(uv, float2(1,1)));
}