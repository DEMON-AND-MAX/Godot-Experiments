shader_type canvas_item;

void fragment() {
	if (COLOR.a > 0.5 && COLOR.r > 0.8 && COLOR.g > 0.8 && COLOR.b > 0.8) {
		COLOR.a = 0.0;
	}
}
