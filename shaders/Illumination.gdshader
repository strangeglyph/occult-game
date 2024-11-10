shader_type canvas_item;

// uv relative position of the illumination center
uniform float center_x : hint_range(0,1) = 0.5;
uniform float center_y : hint_range(0,1) = 0.5;
uniform float aspect_ratio = 1.71;
// average radius of the illumination effect relative to the width of the scren
uniform float illumination_radius : hint_range(0,1) = .125;
// penumbra size relative to the illumination radius
uniform float penumbra_size : hint_range(0,2) = 0.05;
// color outside the illumination effect
uniform vec4 shadow_color : hint_color = vec4(0,0,0,1);
// speed at which the illumination radius oscillates in seconds
uniform float oscillate_speed : hint_range(0,10) = 10;
// oscillation effect size relative to the illumination radius
uniform float oscillate_effect_size: hint_range(0,1) = 0.1;

const float PI = 3.141;

float sq_len(vec2 val) {
	return val.x*val.x + val.y*val.y;
}


void fragment() {
	float dist_sq = sq_len(vec2(UV.x - center_x, (UV.y - center_y) / aspect_ratio));
	
	float illum = illumination_radius * (1.0 + oscillate_effect_size * sin(TIME / oscillate_speed * PI));
	float penumbra_start_sq = sq_len(vec2(illum * (1.0 - penumbra_size)));
	float penumbra_end_sq = sq_len(vec2(illum * (1.0 + penumbra_size)));
	
	COLOR = vec4(shadow_color.rgb, smoothstep(penumbra_start_sq, penumbra_end_sq, dist_sq));
}