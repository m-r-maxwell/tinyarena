shader_type canvas_item;

uniform float lerp_percent : hint_range(0.0, 1.0); // this makes it callable in gd script

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	COLOR = texture_color; //this has to end with semi colons
	vec4 final_color = mix(texture_color, vec4(1.0, 1.0, 1.0, texture_color.a), lerp_percent);
	COLOR = final_color;
}
