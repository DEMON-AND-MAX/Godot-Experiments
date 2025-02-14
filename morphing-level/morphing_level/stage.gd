extends Resource
class_name Stage

@export var stage: Dictionary

@export_category("Transition")
@export var transition_speed: float = 0.3
@export var transition_type: Tween.TransitionType
@export var ease_type: Tween.EaseType

func set_stage(data: Dictionary) -> void:
	stage = data
