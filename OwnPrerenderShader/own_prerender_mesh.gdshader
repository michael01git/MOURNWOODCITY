// Godot 4.3, Forward+ or Mobile
shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D baseImage :source_color;
uniform sampler2D depthImage;

uniform sampler2D screen_texture : source_color, hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture;

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
	vec4 screen = texture(screen_texture, SCREEN_UV);
	
	float depth_raw = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth_raw);
	vec4 position_view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	position_view.xyz /= position_view.w;
	float depth = texture(depth_texture, SCREEN_UV).x;
	float linear_depth = mix(-10, 10, depth);
	
	//Boost
	float smallBoost = 2.5;
	
	vec4 depthMapRotated = texture(depthImage, rotateUV(UV, vec2(0.5), PI));
	float depthMapValue = (depthMapRotated.r + depthMapRotated.g + depthMapRotated.b) / 3.0;
	float linearDepthValue = smallBoost*(vec3(fract(linear_depth)).r + vec3(fract(linear_depth)).g + vec3(fract(linear_depth)).b) / 3.0; 
	
	if (linearDepthValue > depthMapValue){
		ALBEDO = screen.rgb;
	}
	else{
		ALBEDO = texture(baseImage, UV).rgb;
		//ALBEDO = vec3(fract(linear_depth));
		}
	
	//These are always done
	//ALBEDO.rgb = vec3(fract(linear_depth));
	
}
