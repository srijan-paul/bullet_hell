return love.graphics.newShader [[
    // jangsy5 code
    extern float crt_bend = 4.3;
    extern float aberration_offset = 0.0025;

    // CRT screen coordinates

    vec2 crt_pos(vec2 uv) {
        uv = (uv - 0.5) * 2.0;
        uv.x *= 1.0 + pow(abs(uv.y)/ crt_bend, 2.0);
        uv.y *= 1.0 + pow(abs(uv.x)/ crt_bend, 2.0);
        return uv / 2.0 + 0.5;
    }

    // Chromatic Aberration

    vec4 aberration(Image tex, vec2 uv) {
        vec4 r_channel = Texel(tex, uv + aberration_offset);
        vec4 g_channel = Texel(tex, uv - aberration_offset);
        vec4 b_channel = Texel(tex, uv);

        float alpha = Texel(tex, uv).a;

        return vec4(r_channel.r, g_channel.g, b_channel.b, alpha);
    }

    vec4 effect(vec4 color, Image texture, vec2 uv, vec2 pc) {
        // curvature
        uv = crt_pos(uv);

        // fake chromatic aberration
        vec4 final = aberration(texture, uv);
        return final;
    }
]]