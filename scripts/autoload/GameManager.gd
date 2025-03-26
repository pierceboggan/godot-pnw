extends Node

# Preload the PlayerStats class to make it available in this scope
const PlayerStats = preload("res://scripts/player/PlayerStats.gd")

# Signals
signal game_started()
signal game_paused(is_paused)
signal game_over(reason)

# Global game states
var game_running := false
var is_game_paused := false  # Renamed from game_paused to avoid conflict with signal
var player_stats: PlayerStats

func _ready():
	# Initialize game state
	game_running = false
	is_game_paused = false

# Called when starting a new game
func start_game() -> void:
	game_running = true
	is_game_paused = false
	emit_signal("game_started")
	print("Game started")

# Called to pause/unpause the game
func toggle_pause() -> void:
	is_game_paused = !is_game_paused
	emit_signal("game_paused", is_game_paused)
	get_tree().paused = is_game_paused
	print("Game paused: ", is_game_paused)

# Register the player's stats object for global access
func register_player_stats(stats: PlayerStats) -> void:
	player_stats = stats
	# Connect signals to monitor critical stat levels
	player_stats.connect("dampness_changed", _on_player_dampness_changed)
	player_stats.connect("caffeine_changed", _on_player_caffeine_changed)
	print("Player stats registered")

# Get player stats instance (returns null if not registered)
func get_player_stats() -> PlayerStats:
	return player_stats

# Game over condition check for too much dampness
func _on_player_dampness_changed(value: float) -> void:
	if game_running and value >= player_stats.max_dampness:
		trigger_game_over("too_wet")

# Game over condition check for no caffeine
func _on_player_caffeine_changed(value: float) -> void:
	if game_running and value <= 0:
		trigger_game_over("no_caffeine")

# Handle game over condition - renamed from game_over to avoid conflict with signal
func trigger_game_over(reason: String) -> void:
	game_running = false
	emit_signal("game_over", reason)
	print("Game over: ", reason)

# Reset game state for a new game
func reset_game() -> void:
	if player_stats:
		player_stats.reset_stats()
	print("Game reset")