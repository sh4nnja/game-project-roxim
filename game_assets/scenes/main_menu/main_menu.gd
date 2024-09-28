# Manage the format of lesson and link through simulation and code editor.
# Also home for exit / settings etc.
extends Control

# ---------------------------------------------------------------------------- #
func _on_simulation_editor_pressed() -> void:
	pass # Replace with function body.

func _on_code_editor_pressed() -> void:
	# Change this code. 
	get_tree().change_scene_to_file("res://game_assets/scenes/code_editor/code_editor.tscn")
