return love.graphics.newShader ([[
    uniform float crt_bend = 4.3;
    uniform float aberration_offset = 0.0022;
    uniform float scanline_count = 200.0;
    uniform float time;
    uniform float scanline_speed = -10.0;
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
        // curvature
        uv = crt_pos(uv);

        // aberration

        // fake chromatic aberration
        vec4 color = aberration(texture, uv);
        float line = scanline(uv);
        return mix(color, vec4(line), 0.08);
    }
]])


