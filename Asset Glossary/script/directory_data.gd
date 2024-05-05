class_name DirectoryData
extends Resource

@export_category("Directory Info")
@export var name: String = ""
@export_dir var dir_path: String = ""
@export var subdir_list: Array[DirectoryData]
 
@export_category("Extension Settings")
@export var allow_extension_list: Array[String]
@export var b_is_allow_impose: bool = false

@export_category("Directory Depth Settings")
@export_range(0, 8) var max_dir_depth: int = 2
var dir_depth: int = 0
@export var b_is_file_depth_max: bool = false
@export var b_is_file_dir_exclusive: bool = false
