shader_type canvas_item;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

// Smoothed noise by interpolating 4 corners
float smooth_noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));

    vec2 u = smoothstep(0.0, 1.0, f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void fragment() {
    float noise = smooth_noise(UV * 10.0 + vec2(TIME * 0.5, 0.0)); // animate in x
    float cutoff = 0.5 + (noise - 0.6) * 0.2; // 0.2 = strength of distortion
    if (UV.y > cutoff) {
        discard;
    }
}
