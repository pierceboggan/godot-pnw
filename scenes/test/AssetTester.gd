extends Node3D
## Asset Tester Script
## This script verifies that all basic assets are loading correctly
## It also provides simple verification for material, audio, and UI assets

# Asset paths to verify
var asset_paths = {
	"character": "res://assets/characters/player/player_placeholder.tscn",
	"materials": {
		"ground": "res://assets/materials/ground.tres",
		"wood": "res://assets/materials/wood.tres",
		"water": "res://assets/materials/water.tres"
	},
	"ui": {
		"dampness": "res://assets/ui/meters/dampness_indicator.svg",
		"caffeine": "res://assets/ui/meters/caffeine_indicator.svg",
		"background": "res://assets/ui/meters/meter_background.svg"
	}
}

# Reference to UI elements for displaying results
@onready var status_label = $UI/StatusLabel
@onready var asset_count_label = $UI/AssetCountLabel

func _ready():
	# Wait a moment before checking assets to ensure everything is loaded
	await get_tree().create_timer(0.5).timeout
	verify_assets()
	
func verify_assets():
	var status_text = "Asset Verification Results:\n"
	var verified_count = 0
	var total_count = 0
	
	# Check individual assets
	status_text += "\nChecking character assets...\n"
	if ResourceLoader.exists(asset_paths["character"]):
		status_text += "✓ Player character placeholder found\n"
		verified_count += 1
	else:
		status_text += "✗ Player character placeholder MISSING\n"
	total_count += 1
	
	# Check materials
	status_text += "\nChecking materials...\n"
	for material_name in asset_paths["materials"]:
		total_count += 1
		if ResourceLoader.exists(asset_paths["materials"][material_name]):
			status_text += "✓ " + material_name + " material found\n"
			verified_count += 1
		else:
			status_text += "✗ " + material_name + " material MISSING\n"
	
	# Check UI elements
	status_text += "\nChecking UI elements...\n"
	for ui_name in asset_paths["ui"]:
		total_count += 1
		if ResourceLoader.exists(asset_paths["ui"][ui_name]):
			status_text += "✓ " + ui_name + " UI element found\n"
			verified_count += 1
		else:
			status_text += "✗ " + ui_name + " UI element MISSING\n"
	
	# Check for audio directory structure
	status_text += "\nChecking audio directory structure...\n"
	var dir = DirAccess.open("res://assets/audio/")
	if dir:
		var has_sfx = dir.dir_exists("sfx")
		var has_ambient = dir.dir_exists("ambient")
		var has_music = dir.dir_exists("music")
		
		if has_sfx:
			status_text += "✓ SFX directory found\n"
			verified_count += 1
		else:
			status_text += "✗ SFX directory MISSING\n"
		total_count += 1
			
		if has_ambient:
			status_text += "✓ Ambient directory found\n"
			verified_count += 1
		else:
			status_text += "✗ Ambient directory MISSING\n"
		total_count += 1
			
		if has_music:
			status_text += "✓ Music directory found\n"
			verified_count += 1
		else:
			status_text += "✗ Music directory MISSING\n"
		total_count += 1
	else:
		status_text += "✗ Cannot access audio directory\n"
	
	# Display summary
	status_text += "\nSummary: Verified " + str(verified_count) + "/" + str(total_count) + " assets"
	status_label.text = status_text
	
	# Update asset count label
	var percent = (float(verified_count) / float(total_count)) * 100
	asset_count_label.text = "Asset Test Complete\n" + str(verified_count) + "/" + str(total_count) + " assets verified (" + str(percent) + "%)"
	
	# Set color based on verification percentage
	if percent >= 90:
		asset_count_label.modulate = Color(0.2, 0.8, 0.2)  # Green
	elif percent >= 75:
		asset_count_label.modulate = Color(0.8, 0.8, 0.2)  # Yellow
	else:
		asset_count_label.modulate = Color(0.8, 0.2, 0.2)  # Red