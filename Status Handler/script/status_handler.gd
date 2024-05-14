class_name StatusHandler
extends Resource

@export var handler_name: String
@export var stat_list: Array[Stat]

signal stat_updated
signal stat_cap_updated

func get_stat(name: String) -> Stat:
	for stat in stat_list:
		if stat.stat_name == name:
			return stat
	return null

func update_stat(val: Stat) -> void:
	var stat = get_stat(val.stat_name)
	stat.update_stat(val.stat_value)
	stat_updated.emit(stat)

func update_cap(val: Stat) -> void:
	var stat = get_stat(val.stat_name)
	if val is StatCap:
		stat.update_cap(val.stat_value)
		stat_cap_updated.emit(stat)
