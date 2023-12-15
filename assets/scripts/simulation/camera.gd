# ******************************************************************************
#  camera.gd
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

# Movement states.
@export var cam_movement_enabled: bool = false

var _accel: float = 30.0
var _decel: float = -10.0
var _vel: Vector3 = Vector3(0.0, 0.0, 0.0)
var _vel_mult: float = 4.0
var _dir: Vector3 = Vector3(0.0, 0.0, 0.0)

# Mouse states.
var _mouse_pos: Vector2 = Vector2(0.0, 0.0)
var _total_pitch: float  = 0.0

# ******************************************************************************
# INPUT EVENTS

# Mouse input logic.
func _input(_event) -> void:
	# Camera free-lock catalyst and movement speed limiter.
	if _event is InputEventMouseButton:
		if cam_movement_enabled:
			match _event.button_index:
				MOUSE_BUTTON_RIGHT: 
					# Only allows rotation if right mouse button is pressed.
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if _event.pressed else Input.MOUSE_MODE_VISIBLE)
				
				MOUSE_BUTTON_WHEEL_UP: 
					# Increases max velocity when scroll wheel is moved upwards.
					_vel_mult = clamp(_vel_mult * config.cam_vel_mult.x, config.cam_vel_mult.y, config.cam_vel_mult.z)
				
				MOUSE_BUTTON_WHEEL_DOWN: 
					# Decereases max velocity when scroll wheel is moved downwards.
					_vel_mult = clamp(_vel_mult / config.cam_vel_mult.x, config.cam_vel_mult.y, config.cam_vel_mult.z)
			
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	# Camera free-look snippet.
	if _event is InputEventMouseMotion:
		_mouse_pos = _event.relative
	
	# Camera movement snippet.
	if _event is InputEventKey:
		# Checks the cam_movement_key dictionary for the key pressed.
		for _movement_key in config.cam_movement_keys.values():
			# Updates the respective state of the key pressed.
			if _movement_key[0] == _event.keycode:
				_movement_key[1] = _event.pressed

# ******************************************************************************
# PHYSICS and ITERATIONS

# Updates camera free-look and camera movement every physics frame.
func _physics_process(_delta) -> void:
	if cam_movement_enabled:
		_update_cam_free_look()
		_update_cam_movement(_delta)

# *****************************************************************************
# CUSTOM METHODS AND SIGNALS

# Camera free-look mechanic.
func _update_cam_free_look() -> void:
	# Only rotates mouse if the mouse is captured
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_mouse_pos *= config.cam_sens
		var _yaw: float = _mouse_pos.x
		var _pitch: float = _mouse_pos.y
		_mouse_pos = Vector2.ZERO
		
		# Prevents camera from looking up/down too far
		_pitch = clamp(_pitch, -90 - _total_pitch, 90 - _total_pitch)
		_total_pitch += _pitch
		
		# Rotate camera.
		rotate_y(deg_to_rad(-_yaw))
		rotate_object_local(Vector3.RIGHT, deg_to_rad(-_pitch))

# Camera movement mechanic.
func _update_cam_movement(fDelta: float) -> void:
	# Computes desired direction from the key states.
	_dir = Vector3(
		# Key state of Right and Left
		(config.cam_movement_keys.values()[5][1] as float) - (config.cam_movement_keys.values()[4][1] as float),
		
		# Key state of Down and Up
		(config.cam_movement_keys.values()[1][1] as float) - (config.cam_movement_keys.values()[0][1] as float),
		
		# Key state of Back and Front
		(config.cam_movement_keys.values()[3][1] as float) - (config.cam_movement_keys.values()[2][1] as float)
	)
	
	# Computes the change in velocity due to desired direction and "drag"
	# The "drag" is a constant acceleration on the camera to bring it's velocity to 0
	var _offset = _dir.normalized() * _accel * _vel_mult * fDelta + _vel.normalized() * _decel * _vel_mult * fDelta
	
	# Compute modifiers' speed multiplier
	var _speed: float = 1.0
	if config.cam_movement_keys.values()[6][1]: 
		_speed *= config.cam_sprint_mult
	
	if config.cam_movement_keys.values()[7][1]: 
		_speed *= config.cam_crouch_mult
	
	# Checks if we should bother translating the camera
	if _dir == Vector3.ZERO and _offset.length_squared() > _vel.length_squared():
		# Sets the velocity to 0 to prevent jittering due to imperfect deceleration
		_vel = Vector3.ZERO
	else:
		# Clamps speed to stay within maximum value (_vel_mult)
		_vel.x = clamp(_vel.x + _offset.x, -_vel_mult, _vel_mult)
		_vel.y = clamp(_vel.y + _offset.y, -_vel_mult, _vel_mult)
		_vel.z = clamp(_vel.z + _offset.z, -_vel_mult, _vel_mult)
		
		# Move camera.
		translate(_vel * fDelta * _speed)
	
	# Clamp camera movement so it doesn't go below or outside the platform.
	position.x = clamp(position.x, -config.cam_clearance.y, config.cam_clearance.y)
	position.y = clamp(position.y, config.cam_clearance.x, config.cam_clearance.y)
	position.z = clamp(position.z, -config.cam_clearance.y, config.cam_clearance.y)
