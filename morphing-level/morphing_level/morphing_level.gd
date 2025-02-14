@tool
extends Node3D
class_name MorphingLevel

@export_category("Save")
@export var save_stage: bool:
	set(value):
		if Engine.is_editor_hint():
			save_stage = false
			_on_save_stage_pressed()
@export var save_level: bool:
	set(value):
		if Engine.is_editor_hint():
			save_level = false
			_on_save_level_pressed()

@export_category("Settings")
@export var save_directory: String = "res://"
@export var save_name: String = "Level"
var stage_index: int = 0

@export_category("Level Stages")
@export var level: Level
@export var selected: int:
	set(value):
		if Engine.is_editor_hint():
			selected = value
			_on_selected_changed()

var level_nodes: Array[Node]

const _assert_missing_nodes: String = "The morphing level does not contain any nodes."
const _assert_nonexistent_level: String = "The selected level id does not exist in the levels list."
const _assert_missing_level_files: String = "There are no level files present to load in the list."

func _ready() -> void:
	level_nodes = get_children()
	assert(level_nodes.size() > 0, _assert_missing_nodes)
	
	_save_level(null)

func _on_save_stage_pressed() -> void:
	var level_dict: Dictionary
	
	for node in level_nodes:
		level_dict[node.name] = {
			"position": Vector3(node.position.x, node.position.y, node.position.z),
			"rotation": Vector3(node.rotation.x, node.rotation.y, node.rotation.z),
			"scale": Vector3(node.scale.x, node.scale.y, node.scale.z),
		}
	
	var new_stage: Stage = Stage.new()
	new_stage.stage = level_dict
	
	if not DirAccess.dir_exists_absolute(save_directory.path_join("stage")):
		DirAccess.make_dir_absolute(save_directory.path_join("stage"))
	
	ResourceSaver.save(new_stage, _get_stage_file_path())
	
	_save_level(new_stage)

func _save_level(new_stage: Stage) -> void:
	if level == null:
		level = Level.new()
	
	if new_stage != null:
		level.add_stage(new_stage)
	
	var file_path: String = save_directory.path_join(save_name + ".tres")
	
	if DirAccess.dir_exists_absolute(file_path):
		DirAccess.remove_absolute(file_path)
	
	ResourceSaver.save(level, file_path)

func _get_stage_file_path() -> String:
	var file_path: String = save_directory.path_join("stage").path_join(_get_stage_name())
	while FileAccess.file_exists(file_path):
		stage_index += 1
		file_path = save_directory.path_join("stage").path_join(_get_stage_name())
	return file_path

func _get_stage_name() -> String:
	return save_name + "_" + "stage" + "_" + str(stage_index) + ".tres"

func _on_save_level_pressed() -> void:
	_save_level(null)

func _on_selected_changed() -> void:
	transition_to_stage(selected)

func transition_to_stage(id: int) -> void:
	assert(id < level.get_size(), _assert_nonexistent_level)
	
	var next_stage: Stage = level.get_stage(selected)
	
	for node in level_nodes:
		var next_stage_data: Dictionary = next_stage.stage[node.name]
		
		var next_pos: Vector3 = next_stage_data.position
		var next_rot: Vector3 = next_stage_data.rotation
		var next_scale: Vector3 = next_stage_data.scale
		
		_tween_vector3_property(node, "position", next_pos, \
			next_stage.transition_speed, \
			next_stage.transition_type, \
			next_stage.ease_type)
		
		_tween_vector3_property(node, "rotation", next_rot, \
			next_stage.transition_speed, \
			next_stage.transition_type, \
			next_stage.ease_type)
		
		_tween_vector3_property(node, "scale", next_scale, \
			next_stage.transition_speed, \
			next_stage.transition_type, \
			next_stage.ease_type)

func _tween_vector3_property(node: Node3D, property: String, vector: Vector3, \
	transition_speed: float, \
	transition_type: Tween.TransitionType, \
	ease_type: Tween.EaseType):
	var tween: Tween = get_tree().create_tween()
	
	tween.tween_property(node, property, vector, transition_speed) \
		.set_trans(transition_type) \
		.set_ease(ease_type)

func increment_stage() -> void:
	selected += 1
	transition_to_stage(selected)

func set_stage(nr: int) -> void:
	selected = nr
	transition_to_stage(selected)
