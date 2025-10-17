void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalize pixel coordinates to [0, 1] range
    vec2 uv = fragCoord / iResolution.xy;
    
    // Calculate sin value based on x-coordinate
    float sinValue = sin(uv.x * 10.0 + iTime);
    
    // Draw the curve (white if close to sinValue, otherwise black)
    float threshold = 0.01;
    if (abs(uv.y - 0.5 - sinValue * 0.3) < threshold) {
        fragColor = vec4(1.0); // White
    } else {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0); // Black
    }
}