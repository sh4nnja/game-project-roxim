# ******************************************************************************
# coding_compiler.gd
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

extends Node2D

# Base class of COMPILER ENGINE.
# Compiler Engine Tree.

# Adding Blocks in the scene.
# Camera Interactor.
var cam_block_interactor: CodingInteractor

# Block Dictionary
var _block_objects_dict: Dictionary = {
	# EVENT BLOCKS
	"EVENT_when_play_pressed": "res://assets/objects/blocks/events/when_play_pressed.tscn",
	
	# VARIABLE BLOCKS
	"VARIABLE_set_variable": "res://assets/objects/blocks/variables/set_variable.tscn"
}

# ******************************************************************************
# This is where the user will place the variables and values will be located. 
var compiler_variables: Dictionary = {
#	"my_variable": 0 
#	Can be anything.

}

# This is where the user will place the functions and what it does.
var compiler_functions: Dictionary = {
#	"my_function" : {
#		"foo": "foo"
#	}

}

# ******************************************************************************
# CUSTOM SIGNALS AND FUNCTIONS.
# Add blocks on the platform.
func add_coding_block(_block_object_id: String, _object_manager: Node2D) -> void:
	var _obj: Resource = load(_block_objects_dict.get(_block_object_id))
	var _obj_inst: Node = _obj.instantiate()
	_object_manager.add_child(_obj_inst)
	_obj_inst.global_position = cam_block_interactor.position

# Remove blocks.
func remove_coding_block(_block: CodingBlocks, _object_manager: Node2D) -> void:
	# Clears the array for safety.
	cam_block_interactor.interacting_blocks.clear()
	_object_manager.remove_child(_block)
	_block.queue_free()
