// Godot 4.3, Forward+ or Mobile
shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D baseImage :source_color;
uniform sampler2D depthImage :source_color;

uniform sampler2D screen_texture : source_color, hint_screen_texture;
uniform sampler2D depth_texture : source_color, hint_depth_texture, filter_nearest;
//uniform sampler2D true_depth_texture : source_color, hint_depth_texture, filter_nearest;

// These define where the depth map begins / ends. Basically a range for it.
uniform float blender_max_distance = 25.0;
uniform float blender_min_distance = 10.0;

void vertex() {
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
	// Sample the depth texture
	float depth = texture(depth_texture, SCREEN_UV).x;
	// Convert to normalized device coordinates based on renderer
	vec3 ndc;
	if (CURRENT_RENDERER == RENDERER_COMPATIBILITY){
			ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	}
	else{
		ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	}
	// Convert to view space
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	// Output raw depth
	// Calculate ranged depth (normalized between min and max)
	float min_dist = blender_min_distance;
	float max_dist = blender_max_distance;
	float ranged_depth = clamp((linear_depth - min_dist) / (max_dist - min_dist), 0.0, 1.0);
	float ranged_output = ranged_depth;
	
	
	
	
	ALBEDO = texture(baseImage, SCREEN_UV).rgb;
	
	if (ranged_output <= texture(depthImage, SCREEN_UV).r){
		ALBEDO = texture(screen_texture, SCREEN_UV).rgb;
	}
	
	// NOTE: Use this to check depthmaps
	//ALBEDO = vec3(fract(ranged_output));
	
}
