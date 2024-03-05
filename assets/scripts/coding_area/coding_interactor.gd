# ******************************************************************************
#  coding_area_cam.gd
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

extends Camera2D
class_name CodingInteractor

# CAMERA movement.
const _cam_zoom_mult: Vector2 = Vector2(0.10, 0.10)
const _cam_zoom_limit: Vector2 = Vector2(0.5, 0.5)
const _cam_pos_limit: Vector2 = Vector2(3241, 2160)

var _pan_enabled: bool = false

# For interacting with blocks.
var interacting_blocks: Array[CodingBlocks] = []

# ******************************************************************************
# INPUT EVENTS
func _unhandled_input(_event) -> void:
	_manage_panning(_event)
	_manage_scrolling(_event)

# ******************************************************************************
# PHYSICS and ITERATIONS 
func _physics_process(_delta) -> void:
	position.x = clamp(position.x, -_cam_pos_limit.x, _cam_pos_limit.x)
	position.y = clamp(position.y, -_cam_pos_limit.y, _cam_pos_limit.y)

# *****************************************************************************
# CUSTOM METHODS AND SIGNALS
# Pan camera around.
func _manage_panning(_event: InputEvent) -> void:
	# Enable camera panning.
	if _event is InputEventMouseButton:
		if _event.button_index == Configuration.interactor_keys.values()[0] and _event.pressed:
			_pan_enabled = true
		else:
			_pan_enabled = false
	
	# Pan camera.
	if _event is InputEventMouseMotion and _pan_enabled:
		position -= _event.relative * Configuration.cam_sens / zoom
	
	# Update camera position in CompilerEngine for adding new blocks.
	CompilerEngine.cam_block_interactor = self

# Manage camera zoom scrolling.
func _manage_scrolling(_event: InputEvent) -> void:
	if _event is InputEventMouseButton:
		# Zooms camera.
		if _event.button_index == Configuration.interactor_keys.values()[1]: 
			# Increases zoom.
			zoom = lerp(zoom, zoom + _cam_zoom_mult, SimulationEngine.lerp_weight)
			
		elif _event.button_index == Configuration.interactor_keys.values()[2] and zoom >= _cam_zoom_limit: 
			# Decreases zoom.
			zoom = lerp(zoom, zoom - _cam_zoom_mult, SimulationEngine.lerp_weight)

# *****************************************************************************
