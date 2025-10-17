// ShaderToy
// 矩形线框
// 2025-10-17

void mainImage( out vec4 fragColor, in vec2 fragCoord )

{
    vec2 uv = fragCoord.xy / iResolution.xy;

    // 位置和大小
    vec2 pos = vec2(0.5, 0.5);
    vec2 size = vec2(0.4, 0.3);

    // 矩形边界
    vec2 min = pos - size * 0.5;
    vec2 max = pos + size * 0.5;

    bool insideRect = (uv.x > min.x && uv.x < max.x) && (uv.y > min.y && uv.y < max.y);

    // 绘制矩形线框
    float borderWidth = 0.01;
    bool isBorder = (uv.x > min.x - borderWidth && uv.x < max.x + borderWidth) 
                        && (uv.y > min.y - borderWidth && uv.y < max.y + borderWidth)
                        && !insideRect;
    if(isBorder)
    {
        fragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
    else
    {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
}
