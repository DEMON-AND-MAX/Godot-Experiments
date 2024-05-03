class_name AssetGlossary
extends Runnable

@export var asset_dir_path: String = "res://asset/music/"

@export_category("Extension Settings")
@export var ignore_extension_list: Array[String] = [
	"import",
]
@export var b_is_ignore_impose: bool = true
@export var unoptimal_extension_list: Array[String] = [
	"wav", "mp3"
]
@export var b_is_unoptimal_impose: bool = false

@export_category("Directory Depth Settings")
@export_range(0, 8) var max_dir_depth: int = 2
@export var b_is_depth_impose: bool = false
@export var b_is_file_depth_max: bool = false
@export var b_is_file_dir_exclusive: bool = true

@export_category("Warnings")
@export var b_is_print_warning: bool = true

func run() -> void:
	_parse_glossary()

func _parse_glossary() -> void:
	_parse_folder(asset_dir_path)

func _parse_folder(dir_path: String, dir_depth: int = 0) -> void:
	var dir = DirAccess.open(dir_path)
	
	assert(dir, "An error occured trying to access directory:" + dir_path)
	
	var message: String
	var condition: bool
	
	condition = dir_depth > max_dir_depth
	message = ("Directory depth over maximum (" + str(max_dir_depth) +
	"), with value " + str(dir_depth) + ".\n" + 
	"Directory path: " + dir_path)
	
	_issue(condition, message, b_is_depth_impose, b_is_print_warning)
	
	dir.list_dir_begin()
	var file = dir.get_next()
	var b_dir: bool = false
	
	while file != "":
		var file_path = dir.get_current_dir() + "/" + file
		if dir.current_is_dir():
			_parse_folder(file_path, dir_depth + 1)
			b_dir = true
		else:
			if b_is_ignore_impose and file.get_extension() in ignore_extension_list:
				break
			
			condition = b_is_file_dir_exclusive and b_dir
			message = ("Directory already occupied by subdirectories, " +
			"move file destination to maintain hierarchy.\n" +
			"File path: " + file_path)
			
			_issue(condition, message, b_is_depth_impose, b_is_print_warning)
			
			_parse_file(file_path, file, dir_depth)
		file = dir.get_next()
	
	dir.list_dir_end()

func _parse_file(dir_path: String, file: String, dir_depth: int) -> void:
	var condition: bool
	var message: String
	
	condition = b_is_file_depth_max and dir_depth < max_dir_depth
	message = ("File depth under maximum (" + str(max_dir_depth) +
	"), with value " + str(dir_depth) + ".\n" +
	"File path: " + dir_path)
	
	_issue(condition, message, b_is_depth_impose, b_is_print_warning)
	
	condition = b_is_unoptimal_impose and \
			file.get_extension() in unoptimal_extension_list
	message = ("File type unoptimal (" + file.get_extension() +
	"), convert to a more suitable file type.\n" +
	"File path: " + dir_path)
	
	_issue(condition, message, b_is_unoptimal_impose, b_is_print_warning)

func _issue(b_condition: bool, message: String, 
		b_assert: bool = false, b_warning: bool = true) -> void:
	if b_condition:
		assert(!b_assert, message)
		
		if b_warning:
			print("WARNING: " + message)
