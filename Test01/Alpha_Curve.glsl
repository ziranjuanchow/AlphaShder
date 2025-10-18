// ShaderToy
// Curve
// 2025-10-17

vec3 sinCurve(vec2 p, float angle, vec2 offset, float threshold)
{
    mat2 rotateMat = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    p = rotateMat * (p - 0.5) + 0.5;
    p.x += offset.x;
    p.y += offset.y;
    float sinValue = sin(p.x * 10.0 + iTime) * 0.2 + 0.1;
    float cosValue = cos(p.x * 3.0 + iTime) * 0.2 + 0.3;
    if(abs(p.y - 0.5 - sinValue * 0.5) < threshold)
    {
        return vec3(abs(sinValue), cosValue, cosValue);
    }
    else
    {
        return vec3(0.0, 0.0, 0.0);
    }
}

vec3 cicleVurve(vec2 p, vec2 center, float radius, float thickness)
{
    vec2 dt = p - center;
    float d = length(dt);
    if(d < radius && d > radius - thickness)
    {
        return vec3(0.0, 1.0, 0.0);
    }
    else
    {
        return vec3(0.0, 0.0, 0.0);
    }   
}

vec3 spiralCurve(vec2 p, vec2 center, float a, float b, float thickness)
{
    // 阿基米德螺线：r = a + b * theta
    vec2 q = p - center;

    // 宽高比校正, 保持圆形不拉伸
    q.x *= iResolution.x / iResolution.y;

    // 轻微旋转动画
    float ang = 0.8 * iTime;
    mat2 R = mat2(cos(ang), -sin(ang), sin(ang), cos(ang));
    q = R * q;

    float r = length(q) * 0.5;
    float theta = atan(q.y, q.x) * 6.0; // [-pi, pi]

    const float PI2 = 6.28318530718;
    // 
    float k = round((r - a - b * theta) / (b * PI2)); // 圈数, 因为 theta 是 [-pi, pi] 的, 超过无法表示
    float targetR = a + b * (theta + PI2 * k); // 通过圈数,获取到正确半径

    float d = abs(r - targetR / 3.0); // 计算当前点到螺线的距离

    // 
    float aa = fwidth(r) * 1.5; // 抗锯齿（Anti-Aliasing)
    float temp1 = 1.5 * sin(2.0 * ang + 0.1);
    float temp2 = 1.5 * cos(2.0 * ang + 0.1);
    float line = 1.0 - smoothstep(thickness * temp1 - aa , thickness * temp1 + aa, d);

    //
    float t = fract((theta * temp1 ) + temp2 + 0.5);
    vec3 base = mix(vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0), t);
    return base * line; 
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;

    // fragColor = vec4(sinCurve(uv, radians(30.0), vec2(0.0, 0.0), 0.005), 1.0);
    // fragColor = vec4(cicleVurve(uv, vec2(0.5, 0.5), 0.1, 0.003), 1.0);

    vec3 col = spiralCurve(uv, vec2(0.5, 0.5), 0.02, 0.1, 0.003);
    fragColor = vec4(col, 1.0);
}