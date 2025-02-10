class_name StatusHandler
extends Resource

@export var handler_name: String
@export var stat_list: Array[Stat]

func get_stat(name: String) -> Stat:
	for stat in stat_list:
		if stat.stat_name == name:
			return stat
	assert(false, "ERROR: There is no stat with this name.")
	return null

func update_stat(name: String, value: float) -> void:
	var stat = get_stat(name)
	stat.update_stat(value)

func update_cap(name: String, value: float) -> void:
	var stat = get_stat(name)
	assert(stat is StatCap, "ERROR: Stat is not of type StatCap.")
	stat.update_cap(value)
