class_name StatBase
extends Stat

@export var stat_min: float = 0.0
@export var stat_max: float = 100.0

func update_stat(val: float, b_alt: bool = false) -> void:
	stat_value += val
	if !b_alt:
		stat_value = clampf(stat_value, stat_min, stat_max)
