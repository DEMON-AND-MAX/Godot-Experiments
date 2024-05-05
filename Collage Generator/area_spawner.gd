extends Node2D

@onready var shape = $ColorRect.get_global_rect()

@export var sprite_list: Array[Texture2D]
@export var sprite_amount: int = 50

@export var sprite_size: float = 0.1
@export var sprite_rotation_delta: float = 0

func _ready():
	$ColorRect.color.a = 0.0
	spawn()
	pass

func spawn():
	for i in range(sprite_amount):
		var texture = sprite_list.pick_random()
		var sprite = Sprite2D.new()
		sprite.texture = texture
		sprite.position.x = randf_range(shape.position.x, shape.end.x)
		sprite.position.y = randf_range(shape.position.y, shape.end.y)
		sprite.scale = Vector2(sprite_size, sprite_size)
		sprite.rotate(randf_range(-sprite_rotation_delta, sprite_rotation_delta))
		add_child(sprite)

func _process(delta):
	for i in get_children():
		if i is Sprite2D:
			i.rotate(i.rotation/10000)
