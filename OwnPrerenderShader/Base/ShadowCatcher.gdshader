shader_type spatial;

uniform vec3 shadow_color: source_color; //Color of the shadow

// Assume removed color is = vec3(255, 0, 255) ;

uniform float alpha: hint_range(1.0, 1.0, 0.1); //Color of the shadow


void light() {
	DIFFUSE_LIGHT = ALBEDO;
	if (ATTENUATION == 0.0){
		ALPHA = 1.0;

	}
}

void fragment() {
	// simple single color albedo.
	// start with 0 alpha so we can add multiple light shadows together in light()
	ALBEDO = shadow_color;
	ALPHA = 0.0;
}




