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
const _BLOCK_SNAP_THRESHOLD: int = 5

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# Manage hover of blocks.
func manage_hover(_block: CodingBlocks, _is_hovered: bool) -> void:
	if not _block.dragging_enabled:
		# Updates the current interacted blocks.
		CompilerEngine.get_interactor().manage_hovered_blocks(_block, _is_hovered)

# Manage dragging of blocks and whenever it will be snapped and attached.
func manage_dragging(_event: InputEvent) -> void:
	# Check first if there are a block to be dragged, DUH.
	var _block: CodingBlocks = CompilerEngine.get_interactor().get_interacted_block()
	if _block:
		# Enable drag mechanic.
		# Have the size of the current interacting blocks in order to not have an error.
		if _event is InputEventMouseButton:
			if _event.button_index == Configuration.interactor_keys.values()[3]:
				_drag_and_drop_block(_block, _event)
	
		# Dragging Mechanic.
		elif _event is InputEventMouseMotion:
			_drag_and_drop_block(_block, _event)

# Manages block snapping.
func manage_block_snapping(_current_block_area: Area2D, _attaching_block_area: Area2D, _snap: bool):
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
			if not _get_block_owner(_attaching_block_area).block_connected_head and not _get_block_owner(_current_block_area).block_connected_tail:
				_get_block_owner(_current_block_area).can_snap = Configuration.VALID
			else:
				if _get_block_owner(_current_block_area).block_connected_tail == _get_block_owner(_attaching_block_area):
					_get_block_owner(_current_block_area).can_snap = Configuration.DEFAULT
				else:
					_get_block_owner(_current_block_area).can_snap = Configuration.INVALID
		
		# Tail to head connection.
		elif _attaching_block_area.is_in_group("tail") and _current_block_area.is_in_group("head"):
			# Checks if current blocks have their own connections.
			if not _get_block_owner(_attaching_block_area).block_connected_tail and not _get_block_owner(_current_block_area).block_connected_head:
				_get_block_owner(_current_block_area).can_snap = Configuration.VALID
			else:
				if _get_block_owner(_current_block_area).block_connected_head == _get_block_owner(_attaching_block_area):
					_get_block_owner(_current_block_area).can_snap = Configuration.DEFAULT
				else:
					_get_block_owner(_current_block_area).can_snap = Configuration.INVALID
		
		# The forbidden connections.
		elif (_attaching_block_area.is_in_group("head") and _current_block_area.is_in_group("head")) or (_attaching_block_area.is_in_group("tail") and _current_block_area.is_in_group("tail")):
			# Checks if current blocks have their own connections.
			_get_block_owner(_current_block_area).can_snap = Configuration.DEFAULT
		
		# Other blocks.
		else:
			pass
	
	# Whenever block is not attempting to connect / snap.
	else:
		_get_block_owner(_current_block_area).can_snap = Configuration.DEFAULT
	
	# Snap blocks.
	_snap_blocks(_current_block_area, _attaching_block_area)

# Dragging helper function.
func _drag_and_drop_block(_block: CodingBlocks, _event: InputEvent):
	# Enable dragging on mouse select.
	if _event is InputEventMouseButton:
		# Checks first if block is currently snapping.
		if _block.can_snap == Configuration.VALID:
			if !_event.pressed:
				# Released the block.
				_manage_attaching(_block, _block.attaching_connector, true)
		
		else:
			# Sets the block's capability to be dragged.
			CompilerEngine.get_interactor().manage_block_selection(_event.pressed)
		
		# Enable anchors for snapping.
		_manage_snapping_anchors(_block, _block.dragging_enabled)
	
	# Dragging mechanic.
	if _block.dragging_enabled:
		_block.global_position = lerp(_block.global_position, get_global_mouse_position() - (_block.get_child(0).shape.size / 2), SimulationEngine.lerp_weight / 2)
	
	# Enable dragging once again whenever block previously break the snap.
	# It takes the center position of the block then gets the distance of it from the mouse.
	# The amount of position is based on the height minus the threshold so it works on all blocks.
	if (_block.global_position + (_block.get_child(0).shape.size / 2)).distance_to(get_global_mouse_position()) > (_block.get_child(0).shape.size / 2).y - _BLOCK_SNAP_THRESHOLD:
		if _block.can_snap == Configuration.VALID:
			_block.dragging_enabled = true

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
			# Update visuals.
			_connection_permission(_get_block_owner(_current_block_area), Configuration.DEFAULT)
		
		Configuration.VALID:
			# VALID
			# Snap the block in the position.
			_get_block_owner(_current_block_area).attaching_connector = _attaching_block_area
			_get_block_owner(_current_block_area).position = _attaching_block_area.global_position - _current_block_area.position
			_get_block_owner(_current_block_area).dragging_enabled = false
			
			# Update visuals.
			_connection_permission(_get_block_owner(_current_block_area), Configuration.VALID)
		
		Configuration.INVALID:
			# INVALID
			# Update visuals.
			_connection_permission(_get_block_owner(_current_block_area), Configuration.INVALID)

# Attaching mechanic.
func _manage_attaching(_current_block: CodingBlocks, _connector: Area2D, _attach: bool) -> void:
	# Checks if there is an attaching block.
	# For safety purposes.
	if _connector:
		var _attached_block: CodingBlocks = _get_block_owner(_current_block.attaching_connector)
		if _attach:
			# Checks if the area is in head or tail so that it will facilitate the location.
			# If the current block's attaching block.
			if _current_block.attaching_connector.is_in_group("head"):
				_attached_block.block_connected_head = _current_block
				_current_block.block_connected_tail = _attached_block
				
			elif _current_block.attaching_connector.is_in_group("tail"):
				_attached_block.block_connected_tail = _current_block
				_current_block.block_connected_head = _attached_block
				
			# Change parent to the attached block so that it will be moved alongside.
			_current_block.reparent(_attached_block)
			
		# Removes the block.
		else:
			if _current_block.attaching_connector.is_in_group("head"):
				_attached_block.block_connected_head = null
				_current_block.block_connected_tail = null
				
			elif _current_block.attaching_connector.is_in_group("tail"):
				_attached_block.block_connected_tail = null
				_current_block.block_connected_head = null
				
			# Change parent back to the editor.
			_current_block.reparent(get_node("/root/coding_area/coding_block_objects"))

# Get the owner of the block anchor / connector.
func _get_block_owner(_block: Area2D) -> CodingBlocks:
	return _block.owner

# Visual representation of the block if its valid or not.
func _connection_permission(_current_block: CodingBlocks, _is_valid: int) -> void:
	_current_block.modulate = Configuration.permission_colors.values()[_is_valid]
