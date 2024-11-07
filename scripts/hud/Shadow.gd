extends ColorRect


# Set illumination radius relative to width of screen
func set_radius(val: float):
	material.set_shader_param("illumination_radius", val)
	
# Set penumbra radius relative to illumination radius
func set_penumbra_size(val: float):
	material.set_shader_param("penumbra_radius", val)
	
# Set oscillate effect size relative to illumination radius
func set_oscillate_effect_size(val: float):
	material.set_shader_param("oscillate_effect_size", val)
	
# Set shadow color
func set_shadow_color(val: Color):
	material.set_shader_param("shadow_color", val)
