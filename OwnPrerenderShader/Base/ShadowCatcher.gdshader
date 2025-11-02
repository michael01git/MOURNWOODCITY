shader_type spatial;
uniform vec3 shadow_color: source_color; //Color of the shadow

void fragment() {
	// simple single color albedo.
	ALBEDO = shadow_color;
	// start with 0 alpha so we can add multiple light shadows together in light()
	ALPHA = 0.0;
}

void light() {
	DIFFUSE_LIGHT = ALBEDO;
	if (ATTENUATION == 0.0){
		ALPHA = 1.0;
	}
	else{
		ALPHA = 0.0;
	}
}