return love.graphics.newShader([[
float crt_bend = 7.0;
float aberration_offset = 0.0015;
float scanline_count = 300;
float scanline_speed = -4;
uniform float time;
// CRT screen coordinates

vec2 crt_pos(vec2 uv) {
    uv = (uv - 0.5) * 2.0;
    uv.x *= 1.0 + pow(abs(uv.y)/ crt_bend, 2.0);
    uv.y *= 1.0 + pow(abs(uv.x)/ crt_bend, 2.0);
    return uv / 2.0 + 0.5;
}

// Chromatic Aberration

float scanline(vec2 uv) {
    return sin(uv.y * scanline_count + time * scanline_speed);
}

vec4 aberration(Image tex, vec2 uv) {
    vec4 r_channel = Texel(tex, uv + aberration_offset);
    vec4 g_channel = Texel(tex, uv - aberration_offset);
    vec4 b_channel = Texel(tex, uv);

    float alpha = Texel(tex, uv).a;

    return vec4(r_channel.r, g_channel.g, b_channel.b, alpha);
}

vec4 effect(vec4 _ , Image texture, vec2 uv, vec2 pc) {
    uv = crt_pos(uv);
    vec4 color = aberration(texture, uv);
    vec4 scanlines = vec4(scanline(uv));
    return mix(color, scanlines, 0.01);
}
]])

