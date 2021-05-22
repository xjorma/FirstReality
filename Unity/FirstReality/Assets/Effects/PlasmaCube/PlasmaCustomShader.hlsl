void Plasma_float(in float2 uv, in float time, in float4 vertexColor,out float3 color)
{
    const float tile = 32.0;
    //uv = floor(uv * tile) / tile;
    time += vertexColor.y;
	float k = .1 + cos(uv.y + sin(.148 - time)) + 2.4 * time;
	float w = .9 + sin(uv.x + cos(.628 + time)) - 0.7 * time;
	float d = length(uv);
	float s = 7. * cos(d+w) * sin(k+w);

    float3 col[9] = {   float3(0.5, 0.0, 0.0), // Dark red
                        float3(1.0, 0.0, 0.0), // Red
                        float3(1.0, 1.0, 0.0), // Yellow
                        float3(0.0, 0.0, 0.5), // Dark blue
                        float3(0.0, 0.0, 1.0), // Blue
                        float3(1.0, 1.0, 1.0), // White
                        float3(0.2, 0.025, 0.125),// Dark purple
    	                float3(0.4, 0.05,  0.25), // Purple
    	                float3(0.0, 0.6,   0.24)  // Green
                    };
	
    float f = cos(s);
    int b = round(vertexColor.x * 2.0) * 3.0;
    if(f < 0.0)
        color = lerp(col[b + 0], col[b + 1], 1.0 + f);
    else
        color = lerp(col[b + 1], col[b + 2], f);
}