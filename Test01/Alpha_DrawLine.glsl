// ShaderToy
// DrawLine
// 2025-10-17

float drawLine(vec2 p, vec2 a, vec2 b, float width)
{
    // 计算点到线段的距离
    vec2 pa = p - a;
    vec2 ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    // 根据距离绘制线条
    float distance = length(pa - ba * h);

    return smoothstep(width, width - 0.01, distance);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    vec2 start = vec2(0.2, 0.5);
    vec2 end = vec2(0.8, 0.3);
    
    float line = drawLine(uv, start, end, 0.005);

    fragColor = vec4(vec3(line), 1.0);
}