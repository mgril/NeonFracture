shader_type canvas_item;

uniform vec2 size = vec2(32.0, 28.0);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform int octave_count: hint_range(1, 20) = 10;
uniform float amp_start: hint_range(0.0, 10.0, 0.1) = 0.5;
uniform float amp_coeff: hint_range(0.0, 10.0, 0.1) = 0.5;
uniform float freq_coeff: hint_range(0.0, 10.0, 0.1) = 2.0;
uniform float shift_coeff: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float speed: hint_range(0.0, 10.0, 0.01) = 0.5;

vec2 hash22(vec2 uv) {
    uv = vec2(dot(uv, vec2(127.1, 311.7)),
              dot(uv, vec2(269.5, 183.3)));
    return 2.0 * fract(sin(uv) * 43758.5453123) - 1.0;
}

float noise(vec2 uv) {
    vec2 iuv = floor(uv);
    vec2 fuv = fract(uv);
    vec2 blur = smoothstep(0.0, 1.0, fuv);
	
    return mix(mix(dot(hash22(iuv + vec2(0.0, 0.0)), fuv - vec2(0.0, 0.0)),
                   dot(hash22(iuv + vec2(1.0, 0.0)), fuv - vec2(1.0, 0.0)), blur.x),
               mix(dot(hash22(iuv + vec2(0.0, 1.0)), fuv - vec2(0.0, 1.0)),
                   dot(hash22(iuv + vec2(1.0, 1.0)), fuv - vec2(1.0, 1.0)), blur.x),
               blur.y) + 0.5;
}

float fbm(vec2 uv, int octaves) {
    float value = 0.0;
    float amplitude = amp_start;

    for (int i = 0; i < octaves; i++) {
        value += amplitude * noise(uv);
        uv *= freq_coeff;
        amplitude *= amp_coeff;
 	}

    return value;
}
void fragment(){
	vec2 norm_size = size * SCREEN_PIXEL_SIZE;
	vec2 uv = SCREEN_UV;
	float time = TIME * speed;
	float shift = fbm(vec2(time), octave_count) * shift_coeff * 0.01; 
	
	vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	c.r = texture(screen_texture, vec2(SCREEN_UV.x + shift, uv.y)).r; 
	c.g = texture(screen_texture, vec2(SCREEN_UV.x - shift, uv.y)).g; 
	c.b = texture(screen_texture, vec2(SCREEN_UV.x , uv.y)).b; 
	
	COLOR.rgb = c;

}
