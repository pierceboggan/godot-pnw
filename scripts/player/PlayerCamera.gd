extends Node3D

@export var camera_rotation_limit = 0.4 # Approximately 23 degrees in radians
@export var camera_mode := "first_person" # first_person or third_person
@export var third_person_distance := 4.0

@onready var first_person_camera = $FirstPersonCamera
@onready var third_person_camera = $ThirdPersonCamera

func _ready():
	# Set the initial camera mode
	set_camera_mode(camera_mode)

func _process(_delta):
	# Toggle between first and third person views with Tab key
	if Input.is_action_just_pressed("toggle_camera"):
		if camera_mode == "first_person":
			set_camera_mode("third_person")
		else:
			set_camera_mode("first_person")

func set_camera_mode(mode: String) -> void:
	camera_mode = mode
	
	if mode == "first_person":
		first_person_camera.current = true
		third_person_camera.current = false
	else:
		first_person_camera.current = false
		third_person_camera.current = true
		update_third_person_position()

func rotate_camera(rotation_amount: float) -> void:
	# Limit camera rotation to prevent looking too far up or down
	rotation.x = clamp(rotation.x + rotation_amount, -camera_rotation_limit, camera_rotation_limit)
	
	if camera_mode == "third_person":
		update_third_person_position()

func update_third_person_position() -> void:
	# Adjust the third person camera position based on rotation
	var offset = Vector3(
		0, 
		sin(rotation.x) * third_person_distance, 
		cos(rotation.x) * third_person_distance
	)
	
	third_person_camera.position = Vector3(0, 1.5, 0) - offset