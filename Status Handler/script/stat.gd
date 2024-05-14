class_name Stat
extends Resource

@export var stat_value: float
@export var stat_name: String

func update_stat(val: float, b_alt: bool = false) -> void:
	stat_value += val
