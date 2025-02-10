class_name StatCap
extends StatBase

@export var stat_cap: float

signal stat_cap_updated

func update_stat(val: float, b_alt: bool = false) -> void:
	stat_value += val
	if !b_alt:
		stat_value = clampf(stat_value, stat_min, stat_cap)
		stat_value = minf(stat_value, stat_max)
	stat_updated.emit(val)

func update_cap(val: float) -> void:
	stat_cap += val
	stat_cap = clampf(stat_cap, stat_min, stat_max)
	stat_cap = minf(stat_value, stat_cap)
	stat_cap_updated.emit(val)
