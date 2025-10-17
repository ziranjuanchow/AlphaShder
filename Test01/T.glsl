#version 330 core

out vec4 FragColor;

uniform vec2 u_resolution;
uniform float u_time;

void main() {
    // Normalize pixel coordinates to [0, 1] range
    vec2 uv = gl_FragCoord.xy / u_resolution;
    
    // Rotate coordinates by 30 degrees
    float angle = radians(30.0);
    mat2 rotation = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    uv = rotation * (uv - 0.5) + 0.5;
    
    // Calculate sin value based on x-coordinate
    float sinValue = sin(uv.x * 10.0 + u_time);
    
    // Draw the curve (white if close to sinValue, otherwise black)
    float threshold = 0.01;
    if (abs(uv.y - 0.5 - sinValue * 0.3) < threshold) {
        FragColor = vec4(1.0); // White
    } else {
        FragColor = vec4(0.0, 0.0, 0.0, 1.0); // Black
    }
}