extends Node2D

@onready var asset_glossary_node = $"Asset Glossary"
@onready var music_manager_node = $"Music Manager"

func _ready():
	_run_asset_glossary_test()
	_run_music_manager_test()

func _run_asset_glossary_test() -> void:
	asset_glossary_node.run()
	print(asset_glossary_node.asset_glossary)

func _run_music_manager_test() -> void:
	music_manager_node.run()
	print(music_manager_node.music_player_dict)
