# ******************************************************************************
#  brackets.gd
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

extends Interactables
class_name Brackets

# This class will be the base class of all 'brackets' in the simulation mechanics.
# This script will be the base script of all instances of 'brackets'.
#
# For example:
# Brackets class <- This script.
#      -> 2x Bracket
#      -> 3x Bracket
#      -> 4x Bracket
#
# And more...

# ******************************************************************************
# The variables below will be the guidelines of what kind of bracket its currently inherited.

# > bracket_type -> this variable is just the slot count of the bracket, maybe 2 slot bracket, 3 slot bracket or more.
#
# > slots -> an array, each index, which is the slot count holds another array that has boolean and x position values.
#            those values determine the position of the slot and if the slot is occupied or to be occupied.
#
# > attaching_bracket -> this variable essentially is the bracket that the current bracket to be attached.

# Detailed comments per variable are available.
# ******************************************************************************

# Type of bracket.
var bracket_type: int

# Array of 'slots' of the bracket. Each index indicates the 'slot' occupied by a bracket.
# It means that the size of 'slots' is based on the holes of a bracket.
var slots: Array[Array]

# The bracket 'B' the current bracket 'A" you are interacting to.
# This will help for connecting the brackets.
var attaching_bracket: Brackets = null

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# Initiate 'slot' size function. This will vary by each bracket.
# Setting up this function is a must for clean code I suppose.
func initiate_brackets(_bracket: Brackets, _slot_array: Array, _bracket_size: int) -> void:
	# Update the bracket, its slots, the slots position etc.
	for _slot_idx in range(_bracket.get_child_count()):
		var _slot: Node3D = _bracket.get_child(_slot_idx)
		# Checks if the slot is an Area3D.
		if _slot is Area3D:
			# Append false, meaning the slot is not occupied.
			# Append '_slot' position.
			_slot_array.append([false, _slot.position.x])
	
	# Changes what type of bracket currently have.
	bracket_type = _bracket_size

# Manage slot detection for the bracket signals.
func manage_slot_detection(_idx: int, _is_bracket_detected: bool, _detected_bracket: Area3D) -> void:
	# Set the true or false of the slots array.
	slots[_idx][0] = _is_bracket_detected
	if _is_bracket_detected:
		# Sets the attaching bracket as the bracket the current bracket attempts to attach to.
		# The Area3D parent 
		attaching_bracket = _detected_bracket.get_parent()
	else:
		attaching_bracket = null

# Managing bracket mechanics such as attaching and disappearing.
func manage_mechanics(_bracket: Brackets, _is_enabled: bool) -> void:
	# Make the bracket active for attachment when selected.
	# This will save performance for unnecessary detections.
	for _child in _bracket.get_children():
		if _child is Area3D:
			# Sets the collision and monitoring status to detect other brackets.
			if _is_enabled:
				_child.monitoring = true
				_child.set_collision_mask_value(1, true)
			else:
				_child.monitoring = false
				_child.set_collision_mask_value(1, false)
	
	# All statements must be under here so that it doesn't work whenever the bracket is not selected.
	# This code should save performance by not doing unnecessary calculations when not selected.
	if _is_enabled:
		# Manage bracket visibility when hovered.
		_manage_bracket_hover(_bracket, _is_enabled)
		
		# Manage attachment of brackets.
		_manage_bracket_attachment(_bracket)
		
		# Manage detachment of brackets.
		_manage_bracket_detachment(_bracket)

# Bracket will change overlay color and revert whenever it hovers in another bracket.
func _manage_bracket_hover(_bracket: Brackets, _is_enabled: bool) -> void:
	# This just means that if a slot has detected a possible slot.
	# Apply 'can_attach' texture.
	for _slot in slots:
		if _slot.has(true):
			apply_selected_texture(true, interactable_to_attach_res)

# Bracket attaches into another bracket mechanic.
func _manage_bracket_attachment(_bracket: Brackets) -> void:
	for _slot in slots:
		if _slot[0]:
			_bracket.position.x = _slot[1]

# Bracket detaches from another bracket mechanic.
func _manage_bracket_detachment(_bracket: Brackets) -> void:
	pass

# ******************************************************************************
# DEBUG
func manage_debug() -> void:
	# Removes the index of the debug so it doesn't clutter the interface. Only when hovered / selected.
	if is_selected:
		simulation.add_debug_entry(str("     Bracket Slot States of " + str(self.name)), str(slots))
	else:
		simulation.remove_debug_entry(str("     Bracket Slot States of " + str(self.name)))
