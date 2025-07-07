shader_type canvas_item;

uniform bool blue = false;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(TEXTURE, UV);
	if (blue) {
		color.rgb = mix(color.rgb, vec3(0.5, 0.5, 1), 0.8);
	}
	COLOR = color;
}
