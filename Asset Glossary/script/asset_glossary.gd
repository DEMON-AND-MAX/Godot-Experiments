class_name AssetGlossary
extends Runnable

#todo add file name checks
#todo make resource parameters functional
#todo auto generate resource for res folder

@export_category("Directory Info")
var main_dir_path: String = "res://"
var ignore_file_list: Array[String] = [
	# gd icon
	"res://icon.svg",
]
@export var dir_data_list: Array[DirectoryData]

@export_category("Settings")
@export var b_is_auto_run: bool = true

@export_category("Extension Settings")
@export var ignore_extension_list: Array[String] = [
	# default gd import
	"import",
]
@export var b_is_ignore_impose: bool = true
@export var unoptimal_extension_list: Array[String] = [
	# image
	"jpeg", "jpg",
	# animation
	"gif",
	# audio
	"wav", "mp3",
]
@export var b_is_unoptimal_impose: bool = false

@export_category("Directory Depth Settings")
@export_range(1, 8) var max_dir_depth: int = 4
@export var b_is_depth_impose: bool = false
@export var b_is_file_depth_max: bool = false
@export var b_is_file_dir_exclusive: bool = true

@export_category("Warnings")
@export var b_is_print_warning: bool = true

func _ready() -> void:
	if b_is_auto_run:
		run()

func run() -> void:
	for dir_data in dir_data_list:
		_parse_folder(dir_data)

func _parse_folder(dir_data, dir_depth: int = 0) -> void:
	var dir_path = dir_data
	if dir_data is DirectoryData:
		dir_path = dir_data.dir_path
	
	var dir = DirAccess.open(dir_path)
	_issue(!dir, "dir_error", dir_path, true)
	
	_issue(dir_depth > max_dir_depth, 
			"depth_over_max", dir_data, 
			b_is_depth_impose, b_is_print_warning)
	
	dir.list_dir_begin()
	var curr = dir.get_next()
	var b_dir: bool = false
	
	while curr != "":
		var curr_path = dir.get_current_dir() + "/" + curr
		
		if dir.current_is_dir():
			var subdir
			
			if dir_data is DirectoryData:
				subdir = _check_in_subdir(curr_path, dir_data)
				dir_data.dir_depth = max(dir_data.dir_depth, _check_depth(curr_path))
				if !subdir:
					subdir = curr_path
				_parse_folder(subdir)
				print(subdir)
				print(dir_data.dir_depth)
				break
			
			subdir = curr_path
			_parse_folder(subdir, dir_depth + 1)
			
			b_dir = true
		else:
			if b_is_ignore_impose and curr.get_extension() in ignore_extension_list:
				break
			
			_issue(b_is_file_dir_exclusive and b_dir, 
					"is_file_dir_exclusive", curr_path, 
					b_is_depth_impose, b_is_print_warning)
			
			_parse_file(curr_path, curr, dir_depth)
		curr = dir.get_next()

	dir.list_dir_end()

func _parse_file(file_path: String, file: String, dir_depth: int) -> void:
	_issue(b_is_file_depth_max and dir_depth < max_dir_depth, 
			"is_file_depth_max", file_path, 
			b_is_depth_impose, b_is_print_warning)
	
	_issue(b_is_unoptimal_impose and \
			file.get_extension() in unoptimal_extension_list, 
			"is_unoptimal_impose", file_path,
			b_is_unoptimal_impose, b_is_print_warning)

func _check_depth(path: String) -> int:
	return path.split("/").size() - 3

func _check_in_subdir(path: String, dir_data: DirectoryData) -> DirectoryData:
	for subdir in dir_data.subdir_list:
		if path == subdir.dir_path:
			return subdir
	# add logic here if file is not in list
	return null

func _issue(b_condition, error: String, data,
		b_assert: bool = false, b_warning: bool = true) -> void:
	if !b_condition:
		return
	
	var message: String
	
	match error:
		"dir_error":
			message = ("An error occured trying to access directory.\n" + 
					"Directory path: " + data)
		
		"dir_depth_over_max":
			message = ("Directory depth over maximum (" + 
					str(data.max_dir_depth) + "), with value " + 
					str(data.dir_depth) + ".\n" + 
					"Directory path: " + data.dir_path)
		
		"is_file_dir_exclusive":
			message = ("Directory already occupied by subdirectories, " +
					"move file destination to maintain hierarchy.\n" +
					"File path: " + data)
		
		"is_file_depth_max":
			message = ("File depth under maximum (" + str(max_dir_depth) +
					"), with value " + str(data.dir_depth) + ".\n" +
					"File path: " + data.dir_path)
		
		"is_unoptimal_impose":
			message = ("File type unoptimal (" + data.get_extension() +
					"), convert to a more suitable file type.\n" +
					"File path: " + data)
	
	assert(!b_assert, message)
	
	if b_warning:
		print("WARNING: " + message)
