# ******************************************************************************
#  interactables.gd
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

extends RigidBody3D
class_name Interactables

# This class will be the base class of all 'interactables' in the simulation engine class.
# This script will be the base script of all instances of 'interactables'.
#
# For example:
# Interactables class <- This script.
#      -> Motor class
#           -> Small Motor
#           -> Big Motor
#      -> Computing class
#
# Current Subclass that we have:
#      -> Bracket class
#
# Make sure that you don't DUPLICATE and REPEAT your codes across the project. PLEASE.
# Use classes for the same script each objects you have.

# Resource for the selected effect.
@onready var interactable_selected_res: Resource = preload("res://assets/materials/interactables/interactable_selected.tres")
@onready var interactable_to_attach_res: Resource = preload("res://assets/materials/interactables/interactable_to_attach.tres")

# Selection state.
var is_selected: bool = false

# ******************************************************************************
# PHYSICS
func _physics_process(_delta):
	pass

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# Applying a 'selected' texture in an 'interactable'.
func apply_selected_texture(apply: bool, _texture_override: Resource = interactable_selected_res) -> void:
	# Loop through the children to find the main 'texture'.
	for child_node in get_children():
		if child_node is MeshInstance3D:
			# Apply material
			if apply:
				child_node.material_overlay = _texture_override
			else:
				child_node.material_overlay = null
			# Breaks the loop early so it saves time and memory.
			break

# Enable selection.
func manage_selection(selection: bool = false) -> void:
	is_selected = selection

