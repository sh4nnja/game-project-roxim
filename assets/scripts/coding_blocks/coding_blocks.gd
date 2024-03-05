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

# Interactor Node.
var _interactor: CodingInteractor

# ******************************************************************************
# INITIATION
func _ready() -> void:
	# Get absolute path of Interactor.
	_interactor = get_node("/root/coding_area/coding_interactor")

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# Manage hover of blocks.
func manage_hover(_block: CodingBlocks, is_hovered: bool) -> void:
	if is_hovered and !_block.dragging_enabled:
		# Appends and removes the block.
		_interactor.interacting_blocks.append(_block)
	else:
		if !_block.dragging_enabled:
			_interactor.interacting_blocks.erase(_block)

# Manage dragging of blocks.
func manage_dragging(_event: InputEvent) -> void:
	# Enable drag mechanic.
	# Have the size of the current interacting blocks in order to not have an error.
	if _event is InputEventMouseButton and _interactor.interacting_blocks.size() > 0:
		if _event.button_index == Configuration.interactor_keys.values()[3] and _event.pressed:
			# Sets the block's capability to be dragged.
			_interactor.interacting_blocks[0].dragging_enabled = true
		else:
			_interactor.interacting_blocks[0].dragging_enabled = false
	
	# Dragging Mechanic
	if _event is InputEventMouseMotion and _interactor.interacting_blocks.size() > 0:
		if _interactor.interacting_blocks[0].dragging_enabled:
			# Only drag the first element in order not to drag the other blocks.
			_interactor.interacting_blocks[0].position = lerp(_interactor.interacting_blocks[0].position, get_global_mouse_position(), SimulationEngine.lerp_weight / 2)
