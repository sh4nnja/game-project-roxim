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


# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# Manage hover of blocks.
func manage_hover(_block: CodingBlocks, _is_hovered: bool) -> void:
	if !_block.dragging_enabled:
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
	
		# Dragging Mechanic.
		if _event is InputEventMouseMotion:
			if _block.dragging_enabled:
				# Only drag the first element in order not to drag the other blocks.
				_block.position = lerp(_block.position, get_global_mouse_position(), SimulationEngine.lerp_weight / 2)

# ******************************************************************************
# Manage snapping of block to another block.
func manage_snapping(_current_block: CodingBlocks, _attaching_block: CodingBlocks) -> void:
	# Checks what type of blocks are currently snapping with each other.
	_check_attach_area(_current_block, _attaching_block)

# Helper function that checks what kind of blocks are interacting.
func _check_block_type(_current_block: CodingBlocks, _attaching_block: CodingBlocks) -> void:
	pass

# Helper function that checks if current block is above or below the attaching block.
func _check_attach_area(_current_block: CodingBlocks, _attaching_block: CodingBlocks) -> bool:
	var _output: bool = false
	if _current_block.position.y < _attaching_block.position.y:
		_output = true
	return _output
