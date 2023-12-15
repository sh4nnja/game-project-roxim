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

# Array of 'slots' of the bracket. Each index indicates the 'slot' occupied by a bracket.
# It means that the size of 'slots' is based on the holes of a bracket.
var slots: Array[bool]

# The bracket 'B' the current bracket 'A" you are interacting to.
# This will help for connecting the brackets.
var attaching_bracket: Brackets = null

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# Initiate 'slot' size function. This will vary by each bracket.
# Setting up this function is a must for clean code I suppose.
func initiate_bracket_size(slot_array: Array, bracket_size: int) -> void:
	for _slot in range(bracket_size):
		slot_array.append(false)

# Managing bracket mechanics such as attaching and disappearing.
func manage_mechanics(bracket: Brackets, enabled: bool) -> void:
	# Make the bracket active for attachment when selected.
	# This will save performance for unnecessary detections.
	for _child in bracket.get_children():
		if _child is Area3D:
			# Sets the collision and monitoring status to detect other brackets.
			if enabled:
				_child.monitoring = true
				_child.set_collision_mask_value(1, true)
			else:
				_child.monitoring = false
				_child.set_collision_mask_value(1, false)
	
	# All statements must be under here so that it doesn't work whenever the bracket is not selected.
	# This code should save performance by not doing unnecessary calculations when not selected.
	if enabled:
		# Manage bracket visibility when hovered.
		_manage_bracket_visibility(bracket)
		
		# Manage bracket placeholder for attaching.
		_manage_bracket_placeholder(bracket, attaching_bracket) 

# Bracket will disappear visually and revert whenever it hovers in another bracket.
func _manage_bracket_visibility(_bracket: Brackets) -> void:
	if slots.has(true):
		_bracket.visible = false
	else:
		_bracket.visible = true

# Bracket will create a placeholder in the place of the slots occupied for visuals.
func _manage_bracket_placeholder(_bracket: Brackets, _attaching_bracket: Brackets) -> void:
	pass

# ******************************************************************************
# DEBUG
func manage_debug() -> void:
	# Removes the index of the debug so it doesn't clutter the interface. Only when hovered / selected.
	if is_selected:
		config.add_debug_entry(str("     Bracket Slot States of " + str(self.name)), str(slots))
	else:
		config.remove_debug_entry(str("     Bracket Slot States of " + str(self.name)))
