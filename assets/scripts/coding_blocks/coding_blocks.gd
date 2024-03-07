# ******************************************************************************
# coding_blocks.gd
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

extends Area2D
class_name CodingBlocks

# This class will be the base class of all 'coding blocks' in the coding_blocks class.
# This script will be the base script of all instances of 'coding blocks'.
#
# For example:
# CodingBlocks class <- This script.
#      -> Events class
#           -> Start 
#           -> When 'key' pressed
#      -> Control class
#
# Current Subclass that we have:
#      -> Events class
#
# Make sure that you don't DUPLICATE and REPEAT your codes across the project. PLEASE.
# Use classes for the same script each objects you have.
# ******************************************************************************

# Mouse to block distance threshold in pixels in order to break snap.
const _BLOCK_SNAP_THRESHOLD: int = 25

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# Manage hover of blocks.
func manage_hover(_block: CodingBlocks, _is_hovered: bool) -> void:
	if not _block.dragging_enabled:
		# Updates the current interacted blocks.
		CompilerEngine.get_interactor().manage_hovered_blocks(_block, _is_hovered)

# Manage dragging of blocks.
func manage_dragging(_event: InputEvent) -> void:
	# Check first if there are a block to be dragged, DUH.
	var _block: CodingBlocks = CompilerEngine.get_interactor().get_interacted_block()
	if _block:
		# Enable drag mechanic.
		# Have the size of the current interacting blocks in order to not have an error.
		if _event is InputEventMouseButton:
			if _event.button_index == Configuration.interactor_keys.values()[3]:
				# Sets the block's capability to be dragged.
				CompilerEngine.get_interactor().manage_block_selection(_event.pressed)
				
				# Enable anchors.
				_manage_snapping_anchors(_block, _block.dragging_enabled)
	
		# Dragging Mechanic.
		elif _event is InputEventMouseMotion:
			if _block.dragging_enabled:
				_block.position = lerp(_block.position, get_global_mouse_position(), SimulationEngine.lerp_weight / 2)
			
			# Enable dragging once again whenever block previously break the snap.
			if _block.position.distance_to(get_global_mouse_position()) > _BLOCK_SNAP_THRESHOLD and _block.can_snap == Configuration.VALID:
				_block.dragging_enabled = true

# ******************************************************************************
# Manages block snapping.
func manage_block_snapping(_current_block_area: Area2D, _attaching_block_area: Area2D, _snap: bool):
#	print(_current_block_area, " ", _get_block_owner(_current_block_area), " | ", _attaching_block_area, " ", _get_block_owner(_attaching_block_area))
	# Snaps the block on another one.
	if _snap:
		# This segment is dedicated to head-tail contact of blocks.
		# For safety that whenever a block doesn't have a tail or a head.
		# This makes sure that head will only connect to tails and vice versa.
		# Head to Tail connection.
		if _attaching_block_area.is_in_group("head") and _current_block_area.is_in_group("tail"):
			# Checks if current blocks have their own connections.
			# This is why they are separated. 'block_connected_head' doesn't exist in other blocks.
			# Ternary statement for block checking, might be dirty technique.
			_get_block_owner(_current_block_area).can_snap = Configuration.VALID if not _get_block_owner(_attaching_block_area).block_connected_head and not _get_block_owner(_current_block_area).block_connected_tail else Configuration.INVALID
		
		# Tail to head connection.
		elif _attaching_block_area.is_in_group("tail") and _current_block_area.is_in_group("head"):
			# Checks if current blocks have their own connections.
			_get_block_owner(_current_block_area).can_snap = Configuration.VALID if not _get_block_owner(_attaching_block_area).block_connected_tail and not _get_block_owner(_current_block_area).block_connected_head else Configuration.INVALID
		
		# Other blocks.
		else:
			pass
	
	# Whenever block is not attempting to connect / snap.
	else:
		_get_block_owner(_current_block_area).can_snap = Configuration.DEFAULT
	
	# Snap blocks.
	_snap_blocks(_current_block_area, _attaching_block_area)

# Enable snapping anchors so that the blocks can detect others.
# Useful for performance.
func _manage_snapping_anchors(_block: CodingBlocks, _enabled: bool) -> void:
	for _child in _block.get_children():
		if _child is Area2D:
			_child.monitoring = _enabled
			_child.set_collision_mask_value(2, _enabled)

func _snap_blocks(_current_block_area: Area2D, _attaching_block_area: Area2D) -> void:
	match _get_block_owner(_current_block_area).can_snap:
		Configuration.DEFAULT:
			# DEFAULT
			_get_block_owner(_current_block_area).dragging_enabled = true
			
			# Update visuals.
			_connection_permission(_get_block_owner(_current_block_area), Configuration.DEFAULT)
		
		Configuration.VALID:
			# VALID
			# Snap the block in the position.
			_get_block_owner(_current_block_area).position = _attaching_block_area.global_position - _current_block_area.position
			_get_block_owner(_current_block_area).dragging_enabled = false
		
			# Update visuals.
			_connection_permission(_get_block_owner(_current_block_area), Configuration.VALID)
		
		Configuration.INVALID:
			# INVALID
			# Update visuals.
			_connection_permission(_get_block_owner(_current_block_area), Configuration.INVALID)

# Get the owner of the block anchor / connector.
func _get_block_owner(_block: Area2D) -> CodingBlocks:
	return _block.owner

# Visual representation of the block if its valid or not.
func _connection_permission(_current_block: CodingBlocks, _is_valid: int) -> void:
	_current_block.modulate = Configuration.permission_colors.values()[_is_valid]
