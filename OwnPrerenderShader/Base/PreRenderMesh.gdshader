// Godot 4.3, Forward+ or Mobile
shader_type spatial;
render_mode unshaded, fog_disabled, ambient_light_disabled;

uniform sampler2D prerenderBackground : hint_normal;

uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture, filter_nearest;
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

vec3 test(float test, float value){
	if ((test) < value){ // is less than
		return vec3(1,0,0); //RED
	}
	else{
		return vec3(0,0,1);
	}
}

void fragment() {
	
	
	// Get pixel depth on screen
	// Sample depth texture.
	float depth = textureLod(depth_texture, SCREEN_UV, 0.0).r;
	// Linearize.
	vec4 upos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, depth, 1.0);
	vec3 pixel_position = upos.xyz / upos.w;
	
	// Linear depth.
	float linear_depth = (distance(pixel_position, CAMERA_POSITION_WORLD)); // * some changes because we want meters.
	
	// Get alpha channel of PRBG
	float prerender_depth = texture(prerenderBackground, SCREEN_UV).a; // Currently using non 100* version.
	
	// Get the texture.
	vec3 prerender_texture = texture(prerenderBackground, SCREEN_UV).rgb;
	vec3 game_texture = texture(screen_texture, SCREEN_UV).rgb;
	
	ALBEDO = prerender_texture;
	if ((linear_depth < 1000.0) && (linear_depth >= prerender_depth)){
		ALBEDO = game_texture;
	}
	
	if ((linear_depth < 1000.0) && (linear_depth >= prerender_depth)){
		ALBEDO = vec3(1,0,0);
	}
	
	// NOTE: Use this to check depthmaps
	// NOTE README !!! For some godforsaken reason godot reimports and loses quality when textures are put to the shaders.
	//ALBEDO = test(linear_depth, 3500.0); // Red if test is less than value
	//ALBEDO = test(linear_depth, 24.0); // Red if less
	
	
	//ALBEDO = vec3((linear_depth)*.0);
	//ALBEDO = vec3(1.0);
	
}
