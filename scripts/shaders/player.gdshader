shader_type canvas_item;

uniform vec2 border_threshold = vec2(0.1, 0.1);

uniform bool is_buff = false;
uniform vec4 damage_flash_color : source_color;
uniform vec4 buff_color : source_color;
uniform float flash_value : hint_range(0.0, 1.0, 0.1) = 0.0;

bool is_on_border(sampler2D TEXTURE2, vec2 uv) {
	vec4 color_above = texture(TEXTURE2, uv + vec2(0.0, border_threshold.y));
	vec4 color_down = texture(TEXTURE2, uv + vec2(0.0, -border_threshold.y));
	vec4 color_left = texture(TEXTURE2, uv + vec2(-border_threshold.x, 0.0));
	vec4 color_right = texture(TEXTURE2, uv + vec2(border_threshold.x, 0.0));
	
	bool is_next_to_transparent = color_above.a < 1.0 || color_down.a < 1.0 || 
									color_left.a < 1.0 || color_right.a < 1.0;
	bool is_next_to_solid = color_above.a == 1.0 || color_down.a == 1.0 || 
									color_left.a == 1.0 || color_right.a == 1.0;
	
	return is_next_to_transparent && is_next_to_solid;
}

void fragment() {
	/*vec4 texture_color = texture(TEXTURE, UV);
	
	if (is_on_border(TEXTURE, UV)) {
		COLOR = mix(texture_color, damage_flash_color, flash_value);
		
		COLOR = mix(COLOR, buff_color, flash_value);
		
		COLOR.a = texture_color.a;
	} else {
		COLOR = mix(texture_color, damage_flash_color, flash_value);
		
		COLOR.a = texture_color.a;
	}*/
	
	if (is_buff) {
		vec4 texture_color = texture(TEXTURE, UV);
		if (is_on_border(TEXTURE, UV)) {
			COLOR = mix(texture_color, buff_color, flash_value);
		}
	} else {
		// Get texture color...
		vec4 texture_color = texture(TEXTURE, UV);
		// Combine to get the necessary color...
		COLOR = mix(texture_color, damage_flash_color, flash_value);
		// Set alpha channel
		COLOR.a = texture_color.a;
	}
}