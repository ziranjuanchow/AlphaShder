// ShaderToy
// Alpha_Triangle
// 2025-10-17 15:30:44

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

    // [0, 1]
    vec2 uv = fragCoord / iResolution.xy;

    // 三角形顶点
    vec2 p0 = vec2(0.5, 0.1);
    vec2 p1 = vec2(0.1, 0.9);
    vec2 p2 = vec2(0.9, 0.9);

    // 计算重心坐标
    vec2 v0 = p1 - p0;    // 向量 v0: p0 到 p1
    vec2 v1 = p2 - p0;    // 向量 v1: p0 到 p2
    vec2 v2 = uv - p0;   // 向量 v2: p0 到当前像素点

    // 计算点积
    float dot00 = dot(v0, v0); // v0 与自身的点积
    float dot01 = dot(v0, v1); // v0 与 v1 的点积
    float dot11 = dot(v1, v1); // v1 与自身的点积
    float dot20 = dot(v2, v0); // v2 与 v0 的点积
    float dot21 = dot(v2, v1); // v2 与 v1 的点积

    // 计算重心坐标分母
    float invDenom = 1.0 / (dot00 * dot11 - dot01 * dot01);
    // 计算重心坐标 u 和 v
    float u = (dot11 * dot20 - dot01 * dot21) * invDenom;
    float v = (dot00 * dot21 - dot01 * dot20) * invDenom;

    // 检查当前像素点是否在三角形内
    if ((u >= 0.0) && (v >= 0.0) && (u + v <= 1.0)) {
        if( u == 0.0 && v > 0.0)
        {
            fragColor = vec4(0.0, 1.0, 0.0, 1.0); // 三角形内部显示红色
        }else if(u > 0.0 && v > 0.0)
        {
            fragColor = vec4(0.0, 1.0, 0.0, 1.0); 
        }
        else
        {
            fragColor = vec4(1.0, 0.0, 0.0, 1.0); // 三角形内部显示红色
        }
        
    } else {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }

}