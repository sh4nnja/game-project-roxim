# Manages camera panning / zooming and interaction with the blocks in the code editor.

extends Camera2D
# ---------------------------------------------------------------------------- #

# Movement.
const _cam_zoom_mult: Vector2 = Vector2(0.10, 0.10)
const _cam_zoom_limit: Vector2 = Vector2(0.15, 0.75)

var cam_sens: float = 0.5    

var _pan_enabled: bool = false
signal panning(_panning: bool)

var _target_zoom: Vector2 = zoom
var _target_pos: Vector2 = position

var _move_vector: Vector2 = Vector2.ZERO
var _zoom_vector: Vector2 = Vector2.ZERO
var _spd: float = 50

var _key_states = {
	keybinds.code_editor_keys.values()[4]: false,
	keybinds.code_editor_keys.values()[5]: false,
	keybinds.code_editor_keys.values()[6]: false,
	keybinds.code_editor_keys.values()[7]: false,
	keybinds.code_editor_keys.values()[8]: false,
	keybinds.code_editor_keys.values()[9]: false
}

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
	_manage_panning_alt()
	_manage_scrolling_alt()
	
	_lerp_values(_delta)

# ---------------------------------------------------------------------------- #
func _manage_panning(_event: InputEvent) -> void:
	# Enable camera panning.
	if _event is InputEventMouseButton:
		if _event.button_index == keybinds.code_editor_keys.values()[0]:
			_pan_enabled = _event.pressed
	
	# Pan camera.
	if _event is InputEventMouseMotion and _pan_enabled:
		_target_pos -= _event.get_relative() * cam_sens / zoom
	
	if _event is InputEventKey:
		if _event.keycode in _key_states:
			_key_states[_event.keycode] = _event.pressed

# Manage camera zoom scrolling.
func _manage_scrolling(_event: InputEvent) -> void:
	if _event is InputEventMouseButton:
		# Zooms camera.
		if _event.button_index == keybinds.code_editor_keys.values()[1] and _target_zoom.x < _cam_zoom_limit.y: 
			# Increases zoom.
			_target_zoom += _cam_zoom_mult
			
		elif _event.button_index == keybinds.code_editor_keys.values()[2] and _target_zoom.x > _cam_zoom_limit.x: 
			# Decreases zoom.
			_target_zoom -= _cam_zoom_mult
	
	if _event is InputEventKey:
		if _event.keycode in _key_states:
			_key_states[_event.keycode] = _event.pressed

# Camera QOL.
func _manage_panning_alt() -> void:
	_move_vector = Vector2.ZERO
	if _key_states[keybinds.code_editor_keys.values()[6]]:
		_move_vector.y -= 1
	if _key_states[keybinds.code_editor_keys.values()[7]]:
		_move_vector.y += 1
	if _key_states[keybinds.code_editor_keys.values()[8]]:
		_move_vector.x -= 1
	if _key_states[keybinds.code_editor_keys.values()[9]]:
		_move_vector.x += 1
	
	_target_pos += _move_vector * _spd * cam_sens / zoom

func _manage_scrolling_alt() -> void:
	_zoom_vector = Vector2.ZERO
	if _target_zoom.x < _cam_zoom_limit.y and _key_states[keybinds.code_editor_keys.values()[4]]:
		_zoom_vector += _cam_zoom_mult
	elif _target_zoom.x > _cam_zoom_limit.x and _key_states[keybinds.code_editor_keys.values()[5]]:
		_zoom_vector -= _cam_zoom_mult
	_target_zoom += _zoom_vector * cam_sens * zoom

func _lerp_values(_delta) -> void:
	# Lerp values for smooth movement.
	zoom = lerp(zoom, _target_zoom, misc_utils.lerp_weight * cam_sens)
	position = lerp(position, _target_pos, zoom.x * cam_sens / misc_utils.lerp_weight)
