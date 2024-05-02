class_name AssetGlossary
extends Runnable

@export var asset_dir_path: String = "res://asset/music/"

#@export var ignore_extension_list: Array[String] = [
	#"import",
#]
#@export var unoptimal_extension_list: Array[String] = [
	#"wav", "mp3"
#]

@export_category("Directory Depth Settings")
@export_range(0, 8) var max_dir_depth: int = 2
@export var b_is_depth_imposed: bool = false
@export var b_is_file_depth_max: bool = true
@export var b_is_file_dir_exclusive: bool = true

#@export var b_load_unoptimal: bool = true

@export_category("Warnings")
@export var b_is_print_warning: bool = true

#var asset_glossary: Dictionary

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
	"), with value " + str(dir_depth) + ". Folder path: " + dir_path)
	
	_issue(condition, message, b_is_depth_imposed, b_is_print_warning)
	
	dir.list_dir_begin()
	var file = dir.get_next()
	
	while file != "":
		var file_path = dir.get_current_dir() + "/" + file
		if dir.current_is_dir():
			_parse_folder(file_path, dir_depth + 1)
		else:
			condition = b_is_file_depth_max and dir_depth < max_dir_depth
			message = ("File depth under maximum (" + str(max_dir_depth) +
			"), with value " + str(dir_depth) + ". File path: " + 
			dir_path + "/" + file)
			
			_issue(condition, message, b_is_depth_imposed, b_is_print_warning)
			
			# todo check file extension
			
		file = dir.get_next()
	
	dir.list_dir_end()

func _issue(b_condition: bool, message: String, 
		b_is_assert: bool = false, b_is_print_warning: bool = true) -> void:
	if b_condition:
		assert(!b_is_assert, message)
		
		if b_is_print_warning:
			print("WARNING: " + message)

#func _add_to_glossary(file_path: String, file_extension: String = "") -> void:
	#if file_extension in ignore_extension_list:
		#return
	#
	#var file_path_split = file_path.split("/")
	#var file_name = file_path_split[-1].split(".")[0]
	#file_extension = file_path_split[-1].split(".")[1]
	#
	#if file_extension in unoptimal_extension_list:
		#if b_print_warnings:
			#print("WARNING: " + file_path_split[-1] + 
			#" is of an unoptimal file type, consider converting " +
			#"to a different type!")
		#if !b_load_unoptimal:
			#return
	#
	#if file_extension not in asset_glossary.keys():
		#asset_glossary[file_extension] = Dictionary()
	#
	#var current_dict = asset_glossary[file_extension]
	#
	#if file_path_split[3] not in current_dict.keys():
		#current_dict[file_path_split[3]] = Dictionary()
	#
	#current_dict = current_dict[file_path_split[3]]
	#
	#if file_name.contains(file_path_split[-2]):
		#if file_path_split[-2] not in current_dict.keys():
			#current_dict[file_path_split[-2]] = Dictionary()
		#
		#current_dict = current_dict[file_path_split[-2]]
	#
	## remove parent folder name from the child
	#if file_name.find(file_path_split[-2]) != -1:
		#file_name = file_name.erase(file_name.find(file_path_split[-2]), file_path_split[-2].length() + 1)
	#
	#current_dict[file_name] = file_path
