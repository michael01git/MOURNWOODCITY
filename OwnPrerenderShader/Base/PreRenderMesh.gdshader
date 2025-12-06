// Godot 4.3, Forward+ or Mobile
shader_type spatial;
render_mode unshaded, fog_disabled, ambient_light_disabled;

uniform sampler2D prerenderBackground : hint_normal;

uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture;
//uniform sampler2D true_depth_texture : source_color, hint_depth_texture, filter_nearest;

void vertex() {
	// Set the in front of view.
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
	float cosa = cos(rotation);
	float sina = sin(rotation);
	uv -= pivot;
	return vec2(
		cosa * uv.x - sina * uv.y,
		cosa * uv.y + sina * uv.x
	) + pivot;
}

void fragment() {
	
	// Get pixel depth on screen
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	float pixel_depth = (1.0/(((-linear_depth)) * 100.0) - 10.0); // Get inverse depth. Value increases furhter away.
	
	// Get alpha channel of PRBG
	float prerender_depth = texture(prerenderBackground, SCREEN_UV).a; // 1000 here because that is the maximum distance from the camera.
	
	// Get the texture.
	vec3 prerender_texture = texture(prerenderBackground, SCREEN_UV).rgb;
	vec3 game_texture = texture(screen_texture, SCREEN_UV).rgb;
	
	ALBEDO = prerender_texture;
	
	if ((pixel_depth + 2000.0) < (prerender_depth)){
		ALBEDO = game_texture;
	}
	
	// NOTE: Use this to check depthmaps
	// NOTE README !!! For some godforsaken reason godot reimports and loses quality when textures are put to the shaders.
	if ((pixel_depth) < 10000.0){
		ALBEDO = vec3(1,0,0); //RED
	}
	else{
		ALBEDO = vec3(0,0,1);
	}
	
	//ALBEDO = vec3((pixel_depth*pixel_depth));
	
}
