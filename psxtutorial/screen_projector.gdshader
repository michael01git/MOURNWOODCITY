shader_type spatial;
render_mode unshaded, depth_draw_always;

// Maybe not right.
uniform sampler2D albedo :source_color;
uniform sampler2D depth_T;
uniform float near;
uniform float far;
uniform float constant = 0.01;

void vertex() {
	POSITION = vec4(VERTEX, 1);
}

void fragment(){
	ALBEDO = texture(albedo, UV).rgb;
	float depth = -texture(depth_T, UV).x;
	vec4 temp = vec4(0,0,(depth * (-near*constant + far*constant) + far*constant),1);
	vec4 clip_space = PROJECTION_MATRIX * temp;
	clip_space.z /= clip_space.w;
	clip_space.z = 0.5 * (clip_space.z + 1.0);
	DEPTH = clip_space.z;
}
