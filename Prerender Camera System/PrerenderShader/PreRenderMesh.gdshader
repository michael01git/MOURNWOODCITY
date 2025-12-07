shader_type spatial;
render_mode unshaded, fog_disabled, ambient_light_disabled;

// Openexr texture, with the depth information stored in the alpha channel in centimeters.
//// NOTE README !!! When placing an openexr texture in a shader godot compresses it.
//// REIMPORT the texture from the import tab and make it lossless.
uniform sampler2D prerenderBackground : hint_normal;

uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture, filter_nearest;
//uniform sampler2D true_depth_texture : source_color, hint_depth_texture, filter_nearest;

void vertex() {
	// Set the mesh to be in front of active camera.
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

// Not used, function for rotating uvs.
vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
	float cosa = cos(rotation);
	float sina = sin(rotation);
	uv -= pivot;
	return vec2(
		cosa * uv.x - sina * uv.y,
		cosa * uv.y + sina * uv.x
	) + pivot;
}

// Function for testing depthmap values.
vec3 test(float test, float value){
	if ((test) < value){ // is less than
		return vec3(1,0,0); //RED
	}
	else{
		return vec3(0,0,1);
	}
}

// Get the game depth map value.
float get_linear_depth(vec2 screen_uv, mat4 projection_matrix){
	// Get pixel depth on screen
	// Sample depth texture.
	float depth = texture(depth_texture, screen_uv).r;
	// Linearize.
	depth = projection_matrix[3][2] / (depth + projection_matrix[2][2]);
	
	return depth;
}

// Main shader.
void fragment() {
	
	// Linear depth.
	float linear_depth = get_linear_depth(SCREEN_UV, PROJECTION_MATRIX);
	
	// Get alpha channel of PRBG
	float prerender_depth = texture(prerenderBackground, SCREEN_UV).a; // Currently using the centimeter version.
	
	// Get the texture.
	vec3 prerender_texture = texture(prerenderBackground, SCREEN_UV).rgb;
	vec3 game_texture = texture(screen_texture, SCREEN_UV).rgb;
	
	// First we cap the linear depth. (If there is no mesh there the shader will think the distance is 4000 ish something.)
	//// Issues arise if we dont cap this. Reduce cap if issues arise in not being able to see the player.bool
	// Then we check if the player depthmap is less than the prerender depthmap.
	if ((linear_depth < 1000.0) && (linear_depth <= prerender_depth)){
		ALBEDO = game_texture;
	}
	else{
		ALBEDO = prerender_texture;
	}
	
	//// Various test functions.
	
	// Makes overlapping areas red.
	//if ((linear_depth < 1000.0) && (linear_depth >= prerender_depth)){
	//	ALBEDO = vec3(1,0,0);
	//}
	
	
	// NOTE: Use this to check depthmaps
	//ALBEDO = test(linear_depth, 3500.0); // Red if test is less than value
	//ALBEDO = test(linear_depth, 24.0); // Red if less
	
	
	//ALBEDO = vec3((linear_depth)*.0);
	//ALBEDO = vec3(1.0);
	
}
