extends Node2D

@onready var node = $Node

func _ready():
	node.generate_glossary()
	print(node.asset_glossary)
