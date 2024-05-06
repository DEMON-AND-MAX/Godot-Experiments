extends Node2D

@onready var bound = $Resources/Boundary
@onready var bound_box = bound.get_global_rect()
@onready var bound_box_start = bound_box.position
@onready var bound_box_end = bound_box.end

@export_category("Images")
@export var image_texture_list: Array[Texture2D]
@export_range(0.0, 1.0) var size: float = 1.0
@export_range(0.0, 1.0) var size_jitter: float = 0.0

@export_category("Noise Settings")
@export var noise_texture: NoiseTexture2D
@onready var noise: Noise = noise_texture.noise
@export_range(0.0, 1.0) var noise_floor: float = 0.6
@export var b_is_noise_update: bool = false
@export_range(0.01, 10.0) var update_time: float = 1

@export_category("Parse / Spawn Settings")
@export_range(1, 100) var parse_step_x: int = 10
@export_range(1, 100) var parse_step_y: int = 10
@export_range(0, 1) var parse_jitter: float = 0
@export_range(0.0, 1.0) var spawn_jitter_x: float = 0.0
@export_range(0.0, 1.0) var spawn_jitter_y: float = 0.0
@export_range(0.0, 1.0) var rotation_random: float = 0.0
@export_range(0.0, 1.0) var rotation_flow: float = 0.0

@export_category("Settings")
@export var b_is_generate_on_ready: bool = true

func _ready() -> void:
	if b_is_generate_on_ready:
		generate()

func generate() -> void:
	clear()
	
	var noise_val: float
	var new_sprite: Sprite2D
	var new_sprite_position: Vector2
	var new_sprite_position_jitter: Vector2
	var current_step_jitter: Vector2
	current_step_jitter.x = int(parse_step_x + (parse_step_x / 2 * randf_range(-parse_jitter, parse_jitter)))
	
	for x in range(bound_box_start.x, bound_box_end.x, current_step_jitter.x):
		current_step_jitter.y = int(parse_step_y + (parse_step_y / 2 * randf_range(-parse_jitter, parse_jitter)))
		for y in range(bound_box_start.y, bound_box_end.y, current_step_jitter.y):
			noise_val = noise.get_noise_2d(x, y)
			noise_val = (noise_val + 1) / 2
			
			if noise_val < noise_floor:
				continue
			
			new_sprite = Sprite2D.new()
			new_sprite.texture = image_texture_list.pick_random()
			new_sprite_position_jitter.x = randf_range(0.0, spawn_jitter_x) * parse_step_x
			new_sprite_position_jitter.y = randf_range(0.0, spawn_jitter_y) * parse_step_y
			new_sprite_position.x = x + new_sprite_position_jitter.x
			new_sprite_position.y = y + new_sprite_position_jitter.y
			new_sprite.position = new_sprite_position
			
			var new_size = size + (size / 2 * randf_range(-size_jitter, size_jitter))
			new_sprite.scale = Vector2(new_size, new_size)
			
			new_sprite.rotation_degrees = (noise_val * rotation_flow) * 360
			if rotation_random > 0:
				new_sprite.rotation_degrees += randf_range(-rotation_random, rotation_random) * 180
			
			new_sprite.material = load("res://scenes/new_shader_material.tres")
			
			$Sprites.add_child(new_sprite)
	if b_is_noise_update:
		_create_generate_timer()

func clear():
	for sprite in $Sprites.get_children():
		sprite.queue_free()

func _create_generate_timer():
	var timer = get_tree().create_timer(update_time)
	noise.seed = randi_range(0, 10000)
	timer.timeout.connect(generate)
