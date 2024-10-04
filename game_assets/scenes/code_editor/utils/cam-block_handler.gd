# Manages block's states with regards to the code editor scene.
# Manages mouse input when panning and release on blocks.

extends Node2D

@onready var _camera: Camera2D = get_parent().get_node("camera")

# ---------------------------------------------------------------------------- #
func _ready() -> void:
	# Connect signals of camera to the script.
	_camera.connect("panning", Callable(self, "_manage_block_cam_interaction"))

# ---------------------------------------------------------------------------- #
# Manage the block's interaction in regards with the camera.
# If the camera is panning, it will disable all mouse interactions of the blocks.
func _manage_block_cam_interaction(mode: bool) -> void:
	for _block in get_children():
		_block.manage_mouse_interaction(mode)
