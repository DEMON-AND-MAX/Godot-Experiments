extends CharacterBody3D
class_name Player

@export var base_speed: float = 5.0
var current_speed: float = 0.0

@export var walk_speed: float = 1.0
@export var sprint_speed: float = 1.6
@export var crouch_speed: float = 0.6

@export var crouch_depth: float = 0.4
@onready var collision_standing: CollisionShape3D = $"Collision Standing"
@onready var collision_crouching: CollisionShape3D = $"Collision Crouching"
@onready var check_above_head: RayCast3D = $"Check Above Head"

@export var lerp_speed: float = 10.0
var direction: Vector3 = Vector3.ZERO

@export var jump_height: float = 4.5

@export var mouse_sensitivity: float = 0.1
@export var clamp_down: float = -89.0
@export var clamp_up: float = 89.0

@onready var camera: Camera3D = $Neck/Head/Camera
@onready var neck: Node3D = $Neck
@onready var head: Node3D = $Neck/Head
var head_height: float = 0.0
@export var free_look_tilt: float = 5

var walking: bool = false
var sprinting: bool = false
var crouching: bool = false
var free_looking: bool = false
var sliding: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	current_speed = base_speed
	
	head_height = head.position.y

func _input(event) -> void:
	if event is InputEventMouseMotion:
		if free_looking:
			neck.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
			neck.rotation.y = clampf(neck.rotation.y, deg_to_rad(clamp_down), deg_to_rad(clamp_up))
		else:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clampf(head.rotation.x, deg_to_rad(clamp_down), deg_to_rad(clamp_up))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("move_crouch"):
		current_speed = base_speed * crouch_speed
		head.position.y = lerp(head.position.y, head_height - crouch_depth, lerp_speed * delta)
		collision_standing.disabled = true
		collision_crouching.disabled = false
		
		walking = false
		sprinting = false
		crouching = true
	elif !check_above_head.is_colliding():
		head.position.y = lerp(head.position.y, head_height, lerp_speed * delta)
		
		collision_standing.disabled = false
		collision_crouching.disabled = true
		
		if Input.is_action_pressed("move_sprint"):
			current_speed = base_speed * sprint_speed
			walking = false
			sprinting = true
			crouching = false
		else:
			current_speed = base_speed * walk_speed
			walking = true
			sprinting = false
			crouching = false
	
	if Input.is_action_pressed("move_free_look"):
		free_looking = true
		camera.rotation.z = -deg_to_rad(neck.rotation.y * free_look_tilt)
	else:
		free_looking = false
		neck.rotation.y = lerpf(neck.rotation.y, 0.0, lerp_speed * delta)
		camera.rotation.z = lerpf(neck.rotation.z, 0.0, lerp_speed * delta)
	
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = jump_height
	
	var movement_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = lerp(direction, 
				transform.basis * Vector3(movement_dir.x, 0, movement_dir.y).normalized(), 
				lerp_speed * delta)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, lerp_speed)
		velocity.z = move_toward(velocity.z, 0, lerp_speed)
	
	move_and_slide()
