extends Resource
class_name Level

@export var level: Array[Stage] = []

func get_stage(id: int) -> Stage:
	return level[id]

func add_stage(stage: Stage) -> void:
	level.append(stage)

func get_size() -> int:
	return level.size()
