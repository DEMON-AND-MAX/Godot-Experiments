class_name Stat
extends Resource

@export var stat_value: float
@export var stat_name: String

signal stat_updated

func update_stat(val: float, b_alt: bool = false) -> void:
	stat_value += val
	stat_updated.emit(val)
