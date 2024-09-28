# Handling of loading assets and screens.
# Make sure that the game will not lag by loading such assets.
extends Node




func start_loading() -> void:
	# Change this code. 
	get_tree().change_scene_to_file("res://game_assets/scenes/code_editor/code_editor.tscn")
