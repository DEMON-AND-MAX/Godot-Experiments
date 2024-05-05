shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D gradient;
uniform float amount;

void fragment() {
	COLOR = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec4 gradient_color = texture(gradient, UV);
	COLOR = mix(COLOR, COLOR * gradient_color, amount);
}
