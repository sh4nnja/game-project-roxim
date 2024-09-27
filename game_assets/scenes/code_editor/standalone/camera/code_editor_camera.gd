# Manages camera pan and interaction with the blocks in the code editor.

extends Camera2D
# ---------------------------------------------------------------------------- #

# Movement.
const _cam_zoom_mult: Vector2 = Vector2(0.10, 0.10)
const _cam_zoom_limit: Vector2 = Vector2(0.15, 0.15)

var cam_sens: float = 0.5    
var _pan_enabled: bool = false

# ---------------------------------------------------------------------------- #
func _unhandled_input(_event) -> void:
	_manage_panning(_event)
	_manage_scrolling(_event)

# ---------------------------------------------------------------------------- #
func _manage_panning(_event: InputEvent) -> void:
	# Enable camera panning.
	if _event is InputEventMouseButton:
		if _event.button_index == keybinds.code_editor_keys.values()[0]:
			_pan_enabled = _event.pressed
	
	# Pan camera.
	if _event is InputEventMouseMotion and _pan_enabled:
		position -= _event.relative * cam_sens / zoom

# Manage camera zoom scrolling.
func _manage_scrolling(_event: InputEvent) -> void:
	if _event is InputEventMouseButton:
		# Zooms camera.
		if _event.button_index == keybinds.code_editor_keys.values()[1]: 
			# Increases zoom.
			zoom = lerp(zoom, zoom + _cam_zoom_mult,  misc_utils.lerp_weight)
			
		elif _event.button_index == keybinds.code_editor_keys.values()[2] and zoom >= _cam_zoom_limit: 
			# Decreases zoom.
			zoom = lerp(zoom, zoom - _cam_zoom_mult, misc_utils.lerp_weight)
