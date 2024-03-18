# ******************************************************************************
# camera.gd
# ******************************************************************************
#                             This file is part of
#                      RESEARCH CAPSTONE PROJECT - VBlox
# ******************************************************************************
# Copyright (c) 2023-present 12 ESTEMC-3 GROUP 6
# Aicelle Claro
# Shannja Ashley Malelang
# Monique Marcos
# Nica Shane Mijares
# Precious Nina Sarol
# ******************************************************************************
# MIT License
# Copyright (c) 2023 12 ESTEMC-3 GROUP 6
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS," WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ******************************************************************************

extends Camera3D
class_name CameraSimulation

# Movement states.
@export var cam_movement_enabled: bool = false

# Camera movement physics.
const _ACCEL: float = 30.0
const _DECEL: float = -10.0
var _vel: Vector3 = Vector3(0.0, 0.0, 0.0)
var _vel_mult: float = 4.0
var _dir: Vector3 = Vector3(0.0, 0.0, 0.0)

# Mouse states.
var _mouse_pos: Vector2 = Vector2(0.0, 0.0)
var _total_pitch: float  = 0.0

# Camera movement multiplier.
const _CAM_SPRINT_MULT: float = 2.0                   
const _CAM_CROUCH_MULT: float = 0.5
const _CAM_VEL_MULT: Vector3 = Vector3(1.1, 0.2, 50) 

# Camera map clearance.
const _CAM_CLEARANCE: Vector2 = Vector2(0.6, 500)

# ******************************************************************************
# INPUT EVENTS
# Mouse input logic.
func _input(_event) -> void:
	# Camera free-lock catalyst and movement speed limiter.
	if _event is InputEventMouseButton:
		_focus_camera(_event)
		
	# Camera free-look snippet.
	elif _event is InputEventMouseMotion:
		_look_camera(_event)
	
	# Camera movement snippet.
	elif _event is InputEventKey:
		_move_camera(_event)

# ******************************************************************************
# PHYSICS and ITERATIONS
# Updates camera free-look and camera movement every physics frame.
func _physics_process(_delta) -> void:
	if cam_movement_enabled:
		_update_cam_free_look()
		_update_cam_movement(_delta)

# *****************************************************************************
# CUSTOM METHODS AND SIGNALS
# Focus camera in order to make it move and look. Also adjust its speed.
func _focus_camera(_event: InputEventMouseButton) -> void:
	if cam_movement_enabled:
		if _event.button_index == Configuration.interactor_keys.values()[0]: 
			# Only allows rotation if right mouse button is pressed.
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if _event.pressed else Input.MOUSE_MODE_VISIBLE)
			
		elif _event.button_index == Configuration.interactor_keys.values()[1]: 
			# Increases max velocity when scroll wheel is moved upwards.
			_vel_mult = clamp(_vel_mult * _CAM_VEL_MULT.x, _CAM_VEL_MULT.y, _CAM_VEL_MULT.z)
			
		elif _event.button_index == Configuration.interactor_keys.values()[2]: 
			# Decereases max velocity when scroll wheel is moved downwards.
			_vel_mult = clamp(_vel_mult / _CAM_VEL_MULT.x, _CAM_VEL_MULT.y, _CAM_VEL_MULT.z)

# Look with camera using mouse motion.
func _look_camera(_event: InputEventMouseMotion) -> void:
	_mouse_pos = _event.relative

# Move camera with keys.
func _move_camera(_event: InputEventKey) -> void:
	# Checks the cam_movement_key dictionary for the key pressed.
	for _movement_key in Configuration.cam_movement_keys.values():
		# Updates the respective state of the key pressed.
		if _movement_key[0] == _event.keycode:
			_movement_key[1] = _event.pressed

# Camera free-look mechanic.
func _update_cam_free_look() -> void:
	# Only rotates mouse if the mouse is captured.
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_mouse_pos *= Configuration.cam_sens
		var _yaw: float = _mouse_pos.x
		var _pitch: float = _mouse_pos.y
		_mouse_pos = Vector2.ZERO
		
		# Prevents camera from looking up/down too far.
		_pitch = clamp(_pitch, -120 - _total_pitch, 65 - _total_pitch)
		_total_pitch += _pitch
		
		# Rotate camera.
		rotate_y(deg_to_rad(-_yaw))
		rotate_object_local(Vector3.RIGHT, deg_to_rad(-_pitch))

# Camera movement mechanic.
func _update_cam_movement(fDelta: float) -> void:
	# Computes desired direction from the key states.
	_dir = Vector3(
		# Key state of Right and Left.
		(Configuration.cam_movement_keys.values()[5][1] as float) - (Configuration.cam_movement_keys.values()[4][1] as float),
		
		# Key state of Down and Up.
		(Configuration.cam_movement_keys.values()[1][1] as float) - (Configuration.cam_movement_keys.values()[0][1] as float),
		
		# Key state of Back and Front.
		(Configuration.cam_movement_keys.values()[3][1] as float) - (Configuration.cam_movement_keys.values()[2][1] as float)
	)
	
	# Computes the change in velocity due to desired direction and "drag".
	# The "drag" is a constant acceleration on the camera to bring it's velocity to 0.
	var _offset = _dir.normalized() * _ACCEL * _vel_mult * fDelta + _vel.normalized() * _DECEL * _vel_mult * fDelta
	
	# Compute modifiers' speed multiplier.
	var _speed: float = 1.0
	if Configuration.cam_movement_keys.values()[6][1] or Configuration.cam_movement_keys.values()[7][1]: 
		_speed *= _CAM_SPRINT_MULT
	
	# Checks if we should bother translating the camera.
	if _dir == Vector3.ZERO and _offset.length_squared() > _vel.length_squared():
		# Sets the velocity to 0 to prevent jittering due to imperfect deceleration
		_vel = Vector3.ZERO
	else:
		# Clamps speed to stay within maximum value (_vel_mult).
		_vel.x = clamp(_vel.x + _offset.x, -_vel_mult, _vel_mult)
		_vel.y = clamp(_vel.y + _offset.y, -_vel_mult, _vel_mult)
		_vel.z = clamp(_vel.z + _offset.z, -_vel_mult, _vel_mult)
		
		# Move camera.
		translate(_vel * fDelta * _speed)
	
	# Clamp camera movement so it doesn't go below or outside the platform.
	position.x = clamp(position.x, -_CAM_CLEARANCE.y, _CAM_CLEARANCE.y)
	position.y = clamp(position.y, _CAM_CLEARANCE.x, _CAM_CLEARANCE.y)
	position.z = clamp(position.z, -_CAM_CLEARANCE.y, _CAM_CLEARANCE.y)
