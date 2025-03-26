extends CharacterBody3D

# Preload the PlayerStats class to make it available in this scope
const PlayerStats = preload("res://scripts/player/PlayerStats.gd")

# Player movement parameters
@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var MOUSE_SENSITIVITY = 0.002
@export var ACCELERATION = 10.0
@export var DECELERATION = 15.0

# Stats system
@onready var stats: PlayerStats = $PlayerStats

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_controller: Node3D
var base_speed: float

func _ready():
	# Get reference to the camera controller
	camera_controller = $CameraController
	
	# Store base speed for stats modifiers
	base_speed = SPEED
	
	# Register player stats with game manager
	if stats:
		GameManager.register_player_stats(stats)
	
	# Capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	# Handle mouse input for camera rotation
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera_controller.rotate_camera(-event.relative.y * MOUSE_SENSITIVITY)
	
	# Toggle mouse capture with Esc key
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Debug key for increasing dampness (simulating rain)
	if event.is_action_pressed("debug_rain") and stats:
		stats.debug_add_dampness(10.0)
		print("Debug: Added dampness. Current dampness: ", stats.dampness)

func _physics_process(delta):
	# Update speed based on player stats
	update_speed_from_stats()
	
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Handle acceleration and deceleration
	if direction:
		# Calculate target velocity
		var target_velocity = direction * SPEED
		
		# Interpolate current velocity towards target for smooth acceleration
		velocity.x = lerp(velocity.x, target_velocity.x, ACCELERATION * delta)
		velocity.z = lerp(velocity.z, target_velocity.z, ACCELERATION * delta)
	else:
		# Slow down when no input is given
		velocity.x = lerp(velocity.x, 0.0, DECELERATION * delta)
		velocity.z = lerp(velocity.z, 0.0, DECELERATION * delta)

	move_and_slide()

# Update movement speed based on player stats
func update_speed_from_stats() -> void:
	if stats:
		var speed_multiplier = stats.get_speed_multiplier()
		SPEED = base_speed * speed_multiplier