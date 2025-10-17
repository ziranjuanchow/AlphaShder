void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord / iResolution.xy;

    // Define rectangle boundaries (x, y, width, height)
    float rectX = 0.3;
    float rectY = 0.3;
    float rectWidth = 0.4;
    float rectHeight = 0.4;

    // Check if the current pixel is inside the rectangle
    if (uv.x > rectX && uv.x < rectX + rectWidth &&
        uv.y > rectY && uv.y < rectY + rectHeight) {
        fragColor = vec4(1.0, 0.0, 0.0, 1.0); // Red color for the rectangle
    } else {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0); // Black background
    }
}