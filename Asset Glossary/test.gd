extends Node2D

@onready var asset_glossary_node = $"Asset Glossary"

func _ready():
	_run_asset_glossary_test()

func _run_asset_glossary_test() -> void:
	asset_glossary_node.generate_glossary()
	print(asset_glossary_node.asset_glossary)
