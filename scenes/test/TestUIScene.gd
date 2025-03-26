extends Node3D

# Preload required classes
const PlayerStats = preload("res://scripts/player/PlayerStats.gd")

# References
var player_stats: PlayerStats

func _ready():
	# Wait for GameManager to be ready
	await get_tree().create_timer(0.2).timeout
	
	# Get player stats reference
	player_stats = GameManager.get_player_stats()
	
	if player_stats:
		print("Test UI Scene: Player stats loaded successfully")
	else:
		print("Test UI Scene: Failed to get player stats")
	
	# Make C key add caffeine
	InputMap.add_action("debug_caffeine")
	var event = InputEventKey.new()
	event.keycode = KEY_C
	InputMap.action_add_event("debug_caffeine", event)

func _process(_delta):
	# Check for debug input
	if Input.is_action_just_pressed("debug_caffeine") and player_stats:
		_add_caffeine()

# Add dampness (rain simulation)
func _on_add_dampness_btn_pressed():
	if player_stats:
		player_stats.debug_add_dampness(20.0)
		print("Added dampness: ", player_stats.dampness)

# Add caffeine (coffee simulation)
func _on_add_caffeine_btn_pressed():
	_add_caffeine()

# Helper to add caffeine to player
func _add_caffeine():
	if player_stats:
		player_stats.add_caffeine(30.0)
		print("Added caffeine: ", player_stats.caffeine)