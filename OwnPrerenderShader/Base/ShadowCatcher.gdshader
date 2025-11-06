shader_type spatial;

uniform vec3 shadow_color: source_color; //Color of the shadow
uniform float alpha: hint_range(1.0, 1.0, 0.1); //Color of the shadow
uniform sampler2D screen_texture : source_color, hint_screen_texture;

void light() {
	DIFFUSE_LIGHT = ALBEDO;
	if (ATTENUATION == 0.0){
		ALPHA = alpha;
	}
}

void fragment() {
	// simple single color albedo.
	// start with 0 alpha so we can add multiple light shadows together in light()
	ALBEDO = shadow_color;
	ALPHA = 0.0;

}




