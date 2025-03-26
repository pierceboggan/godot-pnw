extends Control
class_name StatsMeter

# Signals
signal value_changed(new_value, max_value)

# Export variables for customization
@export_range(0, 100) var value := 50.0
@export_range(0, 100) var max_value := 100.0
@export var meter_color_low: Color = Color(0.1, 0.8, 0.1, 1.0)  # Green
@export var meter_color_medium: Color = Color(0.9, 0.9, 0.1, 1.0)  # Yellow
@export var meter_color_high: Color = Color(0.9, 0.1, 0.1, 1.0)  # Red
@export var meter_title := "Stat"
@export var invert_colors := false  # If true, red=low, green=high (for caffeine)
@export var icon_texture: Texture2D
@export var show_percentage := true

# Node references
@onready var progress_bar = $VBoxContainer/ProgressBar
@onready var label = $VBoxContainer/HBoxContainer/Label
@onready var icon = $VBoxContainer/HBoxContainer/Icon

# Thresholds for color changes
var low_threshold := 0.3
var high_threshold := 0.7

func _ready():
	# Initialize the meter
	update_meter(value, max_value)
	
	# Set the icon if provided
	if icon_texture:
		icon.texture = icon_texture

# Update the meter with new values
func update_meter(new_value: float, new_max_value: float = max_value) -> void:
	value = clamp(new_value, 0, new_max_value)
	max_value = new_max_value
	
	# Update progress bar value
	progress_bar.max_value = max_value
	progress_bar.value = value
	
	# Update label text
	var percentage = (value / max_value) * 100
	if show_percentage:
		label.text = meter_title + ": " + str(int(percentage)) + "%"
	else:
		label.text = meter_title + ": " + str(int(value)) + "/" + str(int(max_value))
	
	# Update color based on thresholds
	var ratio = value / max_value
	var new_color
	
	if invert_colors:
		# For meters where high is good (caffeine)
		if ratio < low_threshold:
			new_color = meter_color_high
		elif ratio < high_threshold:
			new_color = meter_color_medium
		else:
			new_color = meter_color_low
	else:
		# For meters where low is good (dampness)
		if ratio < low_threshold:
			new_color = meter_color_low
		elif ratio < high_threshold:
			new_color = meter_color_medium
		else:
			new_color = meter_color_high
	
	# Apply the color
	progress_bar.modulate = new_color
	
	# Emit signal
	emit_signal("value_changed", value, max_value)

# Public method to set value
func set_value(new_value: float) -> void:
	update_meter(new_value, max_value)

# Public method to set max value
func set_max_value(new_max_value: float) -> void:
	update_meter(value, new_max_value)

# Public method to set meter title
func set_title(new_title: String) -> void:
	meter_title = new_title
	update_meter(value, max_value)