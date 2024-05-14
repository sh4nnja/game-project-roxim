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
# INITIATION
func _ready() -> void:
	# Update camera position in CompilerEngine for adding new blocks.
	CompilerEngine.cam_block_interactor = get_node("/root/coding_area/coding_interactor")

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
		if _event.button_index == Configuration.interactor_keys.values()[0]:
			_pan_enabled = _event.pressed
	
	# Pan camera.
	if _event is InputEventMouseMotion and _pan_enabled:
		position -= _event.relative * Configuration.cam_sens / zoom

# Manage camera zoom scrolling.
func _manage_scrolling(_event: InputEvent) -> void:
	if _event is InputEventMouseButton:
		# Zooms camera.
		if _event.button_index == Configuration.interactor_keys.values()[1]: 
			# Increases zoom.
			zoom = lerp(zoom, zoom + _cam_zoom_mult, Configuration.lerp_weight)
			
		elif _event.button_index == Configuration.interactor_keys.values()[2] and zoom >= _cam_zoom_limit: 
			# Decreases zoom.
			zoom = lerp(zoom, zoom - _cam_zoom_mult, Configuration.lerp_weight)

# *****************************************************************************
# TOOLS
# Check if interactor is currently interacting with blocks.
func check_interacting_blocks() -> bool:
	var _output: bool = false
	if interacting_blocks.size() > 0:
		_output = true
	return _output

# Get current interacted block.
func get_interacted_block() -> CodingBlocks:
	var _output: CodingBlocks = null
	if check_interacting_blocks():
		_output = interacting_blocks[0]
	return _output

# Edit what blocks are currently being interacted / hovered by the interactor.
func manage_hovered_blocks(_blocks: CodingBlocks, _interact_block: bool) -> void:
	if _interact_block:
		interacting_blocks.append(_blocks)
	else:
		interacting_blocks.erase(_blocks)

# Updates current block if being deselected or not.
func manage_block_selection(_is_interacted: bool) -> void:
	if check_interacting_blocks():
		var _current_block: CodingBlocks = get_interacted_block()
		# Sets the block's capability to be dragged.
		_current_block.update_dragging(_is_interacted)
		
		# Enable Monitoring status of current block.
		_current_block.monitoring = _is_interacted
		_current_block.set_collision_mask_value(1, _is_interacted)
		
		# Removes current block from currently interacting if not dragging anymore.
		if not _is_interacted and not CompilerEngine.block_on_queue_deleting:
			interacting_blocks.erase(_current_block)
