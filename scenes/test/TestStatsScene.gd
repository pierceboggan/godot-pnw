extends Node3D

# Preload PlayerStats class to make it available in this scope
const PlayerStats = preload("res://scripts/player/PlayerStats.gd")

# UI references
@onready var stats_label = $UI/StatsPanel/StatsLabel
@onready var debug_output = $UI/DebugOutput

# Reference to player and stats
var player
var player_stats: PlayerStats

# Debug message queue
var debug_messages = []
var max_debug_messages = 10

func _ready():
	# Get reference to player node
	player = $Player
	
	# Wait a moment for stats to initialize
	await get_tree().create_timer(0.5).timeout
	
	# Get player stats from game manager
	player_stats = GameManager.get_player_stats()
	
	if player_stats:
		# Connect signals to update UI
		player_stats.connect("dampness_changed", _on_dampness_changed)
		player_stats.connect("caffeine_changed", _on_caffeine_changed)
		
		# Add a debug message
		add_debug_message("Player stats initialized")
		
		# Update UI immediately
		_update_stats_display()
	else:
		stats_label.text = "Error: Player stats not found"
		add_debug_message("ERROR: Could not get player stats")

func _process(_delta):
	# Update stats display every frame to show real-time changes
	if player_stats:
		_update_stats_display()

# Update the stats display with current values
func _update_stats_display():
	var speed_mult = player_stats.get_speed_multiplier()
	var caffeine_percent = player_stats.get_caffeine_percent()
	var dampness_percent = player_stats.get_dampness_percent()
	
	var stats_text = "Player Stats:\n"
	stats_text += "Dampness: %.1f / %.1f (%.1f%%)\n" % [player_stats.dampness, player_stats.max_dampness, dampness_percent]
	stats_text += "Caffeine: %.1f / %.1f (%.1f%%)\n" % [player_stats.caffeine, player_stats.max_caffeine, caffeine_percent]
	stats_text += "Speed Multiplier: %.2f\n" % speed_mult
	stats_text += "In Rain: %s\n" % ("Yes" if player_stats.is_in_rain else "No")
	
	stats_label.text = stats_text

# Handle dampness change
func _on_dampness_changed(value):
	add_debug_message("Dampness changed: %.1f" % value)
	
	# Check if dampness is at critical level
	if value > player_stats.high_dampness_threshold:
		add_debug_message("WARNING: Dampness critical!")

# Handle caffeine change
func _on_caffeine_changed(value):
	add_debug_message("Caffeine changed: %.1f" % value)
	
	# Check if caffeine is low
	if value < player_stats.low_caffeine_threshold:
		add_debug_message("WARNING: Caffeine low!")

# Add a debug message to the queue and update display
func add_debug_message(message):
	# Get current time for timestamp
	var time = Time.get_time_dict_from_system()
	var timestamp = "%02d:%02d:%02d" % [time.hour, time.minute, time.second]
	
	# Format message with timestamp
	var formatted_message = "[%s] %s" % [timestamp, message]
	
	# Add to queue
	debug_messages.append(formatted_message)
	
	# Remove oldest message if we exceed the max
	while debug_messages.size() > max_debug_messages:
		debug_messages.pop_front()
	
	# Update debug display
	var debug_text = "Debug Output:\n"
	for msg in debug_messages:
		debug_text += msg + "\n"
	
	debug_output.text = debug_text