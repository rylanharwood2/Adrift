shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0);
uniform float flash_modifier: hint_range(0.0, 1.0) = 0;
uniform bool blue = false;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (blue) {
		color.rgb = mix(color.rgb, vec3(0.5, 0.5, 1), 0.7);
	}
	color.rgb = mix(color.rgb, flash_color.rgb, flash_modifier);
	COLOR = color;
}
