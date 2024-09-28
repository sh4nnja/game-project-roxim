# Manages camera panning / zooming and interaction with the blocks in the code editor.

extends Camera2D
# ---------------------------------------------------------------------------- #

# Movement.
const _cam_zoom_mult: Vector2 = Vector2(0.10, 0.10)
const _cam_zoom_limit: Vector2 = Vector2(0.15, 0.15)

var cam_sens: float = 0.5    

var _pan_enabled: bool = false
signal panning(_panning: bool)

var _target_zoom: Vector2 = zoom
var _target_pos: Vector2 = position

# ---------------------------------------------------------------------------- #
func _unhandled_input(_event) -> void:
	# Activate inputs.
	_manage_panning(_event)
	_manage_scrolling(_event)
	
	# Activate physics for lerping.
	set_physics_process(true if _event else false)
	
	# Activate panning mode.
	# This will disable interactions with the blocks when 
	# panning to prevent accidental linking / unlinking.
	panning.emit(_pan_enabled)

func _physics_process(_delta: float) -> void:
	_lerp_values(_delta)

# ---------------------------------------------------------------------------- #
func _manage_panning(_event: InputEvent) -> void:
	# Enable camera panning.
	if _event is InputEventMouseButton:
		if _event.button_index == keybinds.code_editor_keys.values()[0]:
			_pan_enabled = _event.pressed
	
	# Pan camera.
	if _event is InputEventMouseMotion and _pan_enabled:
		_target_pos -= _event.relative * cam_sens / zoom

# Manage camera zoom scrolling.
func _manage_scrolling(_event: InputEvent) -> void:
	if _event is InputEventMouseButton:
		# Zooms camera.
		if _event.button_index == keybinds.code_editor_keys.values()[1]: 
			# Increases zoom.
			_target_zoom = zoom + _cam_zoom_mult
			
		elif _event.button_index == keybinds.code_editor_keys.values()[2] and zoom >= _cam_zoom_limit: 
			# Decreases zoom.
			_target_zoom = zoom - _cam_zoom_mult

func _lerp_values(_delta) -> void:
	# Lerp values for smooth movement.
	zoom = lerp(zoom, _target_zoom, misc_utils.lerp_weight * cam_sens)
	position = lerp(position, _target_pos, zoom.x * cam_sens / misc_utils.lerp_weight)
