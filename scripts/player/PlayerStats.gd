extends Node
class_name PlayerStats

# Signals
signal dampness_changed(new_value)
signal caffeine_changed(new_value)
signal stats_initialized()

# Stat parameters
@export_range(0, 100) var max_dampness := 100.0
@export_range(0, 100) var max_caffeine := 100.0
@export_range(0.1, 10.0) var caffeine_depletion_rate := 1.0  # Units per second
@export_range(0.1, 10.0) var dampness_drying_rate := 0.5     # Units per second when not in rain

# Current stat values
var dampness: float = 0.0
var caffeine: float = 100.0

# Gameplay effect thresholds
var low_caffeine_threshold := 30.0
var high_dampness_threshold := 70.0

# Movement penalties
var low_caffeine_speed_multiplier := 0.6
var high_dampness_speed_multiplier := 0.7

# Weather effects
var is_in_rain := false
var rain_intensity := 0.0  # 0.0 to 1.0

func _ready() -> void:
	# Initialize stats
	reset_stats()
	emit_signal("stats_initialized")

func _process(delta: float) -> void:
	# Update stats over time
	update_caffeine(delta)
	update_dampness(delta)

# Updates caffeine based on time
func update_caffeine(delta: float) -> void:
	# Caffeine naturally decreases over time
	var old_caffeine = caffeine
	caffeine = max(0.0, caffeine - caffeine_depletion_rate * delta)
	
	# Only emit signal if value changed
	if old_caffeine != caffeine:
		emit_signal("caffeine_changed", caffeine)

# Updates dampness based on time and rain status
func update_dampness(delta: float) -> void:
	var old_dampness = dampness
	
	if is_in_rain:
		# Increase dampness when in rain based on intensity
		dampness = min(max_dampness, dampness + rain_intensity * delta * 5.0)
	else:
		# Decrease dampness when not in rain
		dampness = max(0.0, dampness - dampness_drying_rate * delta)
	
	# Only emit signal if value changed
	if old_dampness != dampness:
		emit_signal("dampness_changed", dampness)

# Resets stats to default values
func reset_stats() -> void:
	dampness = 0.0
	caffeine = max_caffeine
	emit_signal("dampness_changed", dampness)
	emit_signal("caffeine_changed", caffeine)

# Sets the rain status and intensity
func set_rain(in_rain: bool, intensity: float = 1.0) -> void:
	is_in_rain = in_rain
	rain_intensity = clamp(intensity, 0.0, 1.0)

# Adds caffeine (from coffee shops or items)
func add_caffeine(amount: float) -> void:
	var old_caffeine = caffeine
	caffeine = min(max_caffeine, caffeine + amount)
	
	if old_caffeine != caffeine:
		emit_signal("caffeine_changed", caffeine)

# Reduces dampness (from using items like umbrellas)
func reduce_dampness(amount: float) -> void:
	var old_dampness = dampness
	dampness = max(0.0, dampness - amount)
	
	if old_dampness != dampness:
		emit_signal("dampness_changed", dampness)

# Get speed multiplier based on current stats
func get_speed_multiplier() -> float:
	var multiplier = 1.0
	
	# Apply caffeine penalty if below threshold
	if caffeine < low_caffeine_threshold:
		multiplier *= low_caffeine_speed_multiplier
	
	# Apply dampness penalty if above threshold
	if dampness > high_dampness_threshold:
		multiplier *= high_dampness_speed_multiplier
	
	return multiplier

# Get percentage values for UI display
func get_dampness_percent() -> float:
	return (dampness / max_dampness) * 100.0

func get_caffeine_percent() -> float:
	return (caffeine / max_caffeine) * 100.0

# Debug function to simulate rain
func debug_add_dampness(amount: float) -> void:
	var old_dampness = dampness
	dampness = min(max_dampness, dampness + amount)
	
	if old_dampness != dampness:
		emit_signal("dampness_changed", dampness)