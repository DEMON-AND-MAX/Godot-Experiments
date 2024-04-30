class_name AssetGlossary
extends Node

"""
ASSET GLOSSARY
Parses the specified asset folder and generates a glossary containing
every single file, sorted by extension for quick ease of access to file
paths within the project.

Quick tip
	Keep "b_load_unoptimal" true until the end of production session,
	turn it off when the project needs tightening and compression to
	easily gauge what files can be converted to smaller, faster file
	types.

Export variables
	asset_dir_path: 
		base asset folder
	
	ignore_extension_list: 
		list of extensions to completely ignore
	
	unoptimal_extension_list:
		list of extensions that should not be used within the project
	
	b_load_unoptimal:
		if files with unoptimal extensions should be loaded
	
	b_print_warnings:
		if warning messages should be printed
"""

@export var asset_dir_path: String = "res://asset/"

@export var ignore_extension_list: Array = [
	"import",
]
@export var unoptimal_extension_list: Array = [
	
]

@export var b_load_unoptimal: bool = true
@export var b_print_warnings: bool = true

var asset_glossary: Dictionary

func generate_glossary() -> void:
	_parse_folder(asset_dir_path)

func _parse_folder(dir_path: String) -> void:
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			var file_path = dir.get_current_dir() + "/" + file
			if dir.current_is_dir():
				_parse_folder(file_path)
			else:
				_add_to_glossary(file_path,
				file.get_extension())
			file = dir.get_next()
		dir.list_dir_end()
	else:
		assert(false, 
		"An error occured trying to access the asset directory.")

func _add_to_glossary(file_path: String, file_extension: String = "") -> void:
	if file_extension in ignore_extension_list:
		return
	
	var file_path_split = file_path.split("/")
	var file_name = file_path_split[-1].split(".")[0]
	file_extension = file_path_split[-1].split(".")[1]
	
	if file_extension in unoptimal_extension_list:
		if b_print_warnings:
			print("Warning: " + file_path_split[-1] + 
			" is of an unused file type, consider converting this 
			to a supported file type!")
		if !b_load_unoptimal:
			return
	
	if file_extension not in asset_glossary.keys():
		asset_glossary[file_extension] = Dictionary()
	
	var current_dict = asset_glossary[file_extension]
	
	if file_path_split[3] not in current_dict.keys():
		current_dict[file_path_split[3]] = Dictionary()
	
	current_dict = current_dict[file_path_split[3]]
	
	if file_path_split[-1].contains(file_path_split[-2]):
		if file_path_split[-2] not in current_dict.keys():
			current_dict[file_path_split[-2]] = Dictionary()
		
		current_dict = current_dict[file_path_split[-2]]
	
	current_dict[file_name] = file_path
