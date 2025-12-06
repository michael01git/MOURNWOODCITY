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

// Return distance for each pixel.
float get_pixel_depth(mat4 inv_projection_matrix, vec2 screen_uv){
	float depth = texture(depth_texture, screen_uv).x;
	vec3 ndc = vec3(screen_uv, depth) * 2.0 - 1.0;
	vec4 view = inv_projection_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	return linear_depth;
	
	// https://godotshaders.com/shader/camera-distance-uv-scaling/
	//vec3 world_camera = (inv_view_matrix * vec4(vec3(0.0), 1.0)).xyz;
	//vec4 a = inv_view_matrix * vec4(vertex, 1.0);
	//return distance(a.xyz, world_camera);
}

void fragment() {
	
	// Get pixel depth on screen
	float pixel_depth = get_pixel_depth(INV_PROJECTION_MATRIX, SCREEN_UV);
	
	// Get alpha channel of PRBG
	float prerender_depth = texture(prerenderBackground, SCREEN_UV).a;
	
	// Get the texture.
	vec3 prerender_texture = texture(prerenderBackground, SCREEN_UV).rgb;
	vec3 game_texture = texture(screen_texture, SCREEN_UV).rgb;
	
	
	if ((pixel_depth*100.0) <= (prerender_depth)){
		ALBEDO = prerender_texture;
	}
	else{
		ALBEDO = game_texture;
	}
	
	// NOTE: Use this to check depthmaps
	// NOTE README !!! For some godforsaken reason godot reimports and loses quality when textures are put to the shaders.
	//ALBEDO = vec3(max(prerender_depth, 0.0));
	//ALBEDO = vec3((pixel_depth*pixel_depth));
	
}
