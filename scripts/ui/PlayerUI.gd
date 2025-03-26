extends Control

# Preload PlayerStats class to ensure it's available
const PlayerStats = preload("res://scripts/player/PlayerStats.gd")

# References to UI elements
@onready var dampness_meter = $StatsContainer/DampnessMeter
@onready var caffeine_meter = $StatsContainer/CaffeineMeter
@onready var status_message = $StatusMessage
@onready var message_timer = $MessageTimer

# Player Stats reference
var player_stats: PlayerStats

func _ready():
	# Hide status message by default
	status_message.hide()
	
	# Wait a moment for GameManager to be ready
	await get_tree().create_timer(0.1).timeout
	
	# Get player stats from game manager
	player_stats = GameManager.get_player_stats()
	
	if player_stats:
		# Connect to player stats signals
		player_stats.connect("dampness_changed", _on_dampness_changed)
		player_stats.connect("caffeine_changed", _on_caffeine_changed)
		
		# Initialize meters with current values
		_on_dampness_changed(player_stats.dampness)
		_on_caffeine_changed(player_stats.caffeine)
		
		# Show message that UI is connected
		show_message("Status meters initialized")
	else:
		# Show error if player stats not found
		show_message("ERROR: Could not find player stats!", 5.0)

# Handle dampness value changes
func _on_dampness_changed(new_value: float) -> void:
	if dampness_meter:
		dampness_meter.set_value(new_value)
		
		# Show warning message if dampness is critically high
		if new_value >= player_stats.high_dampness_threshold:
			show_message("WARNING: Dampness critical! Find cover!")

# Handle caffeine value changes
func _on_caffeine_changed(new_value: float) -> void:
	if caffeine_meter:
		caffeine_meter.set_value(new_value)
		
		# Show warning message if caffeine is critically low
		if new_value <= player_stats.low_caffeine_threshold:
			show_message("WARNING: Caffeine low! Find coffee soon!")

# Show a status message for a duration
func show_message(text: String, duration: float = 3.0) -> void:
	status_message.text = text
	status_message.show()
	message_timer.wait_time = duration
	message_timer.start()

# Hide the status message
func _on_message_timer_timeout() -> void:
	status_message.hide()