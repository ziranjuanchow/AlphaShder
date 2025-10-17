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

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;

    // fragColor = vec4(sinCurve(uv, radians(30.0), vec2(0.0, 0.0), 0.005), 1.0);
    fragColor = vec4(cicleVurve(uv, vec2(0.5, 0.5), 0.1, 0.003), 1.0);
}