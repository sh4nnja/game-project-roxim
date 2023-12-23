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

# The bracket reference and what kind / type of bracket.
var bracket: Brackets
var bracket_type: int

# Array of 'slots' of the bracket. Each index indicates the 'slot' occupied by a bracket.
# It means that the size of 'slots' is based on the holes of a bracket.
var _slot_positions: PackedFloat64Array
var _slot_states: Array[bool]
var _slot_detected_idx: int

# The bracket 'B' the current bracket 'A" you are interacting to.
# This will help for connecting the brackets.
var _attaching_bracket: Brackets
var _attaching_bracket_slot_pos: PackedFloat64Array

# ******************************************************************************
# SNAPPING MECHANIC
# Bracket Height constant. For the snap mechanic.
const _BRACKET_SNAP_HEIGHT: float = 0.125

# The bracket threshold before the snap is disabled.
const _BRACKET_SNAP_THRESHOLD: float = 0.75

# The bracket snap lerp weight.
const _BRACKET_SNAP_LRP_WEIGHT: float = 0.15

# Rotation when snapping.
const _BRACKET_SNAP_ROT_INCR: int = 15 

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# Initiate 'slot' size function. This will vary by each bracket.
# Setting up this function is a must for clean code I suppose.
func initiate_brackets(_bracket: Brackets, _bracket_size: int) -> void:
	# Update the bracket, its slots, the slots position etc.
	for _slot_idx in range(_bracket.get_child_count()):
		var _slot: Node3D = _bracket.get_child(_slot_idx)
		# Checks if the slot is an Area3D.
		if _slot is Area3D:
			# Append false, meaning the slot is not occupied. 
			# Append '_slot' position.
			_slot_positions.append(SimulationEngine.fsnap(_slot.transform.origin.x))
			_slot_states.append(false)
	
	# Changes what type of bracket currently have.
	bracket_type = _bracket_size
	# Update the bracket.
	bracket = _bracket

# Manage slot detection for the bracket signals.
func manage_slot_detection(_idx: int, _is_bracket_detected: bool, _detected_bracket: Area3D) -> void:
	# Set the true or false of the slots array.
	_slot_detected_idx = _idx
	_slot_states[_slot_detected_idx] = _is_bracket_detected
	if _is_bracket_detected:
		# Sets the attaching bracket as the bracket the current bracket attempts to attach to.
		# The Area3D parent 
		_attaching_bracket = _detected_bracket.get_parent()
		_attaching_bracket_slot_pos.append(SimulationEngine.fsnap(_detected_bracket.transform.origin.x))
		_attaching_bracket_slot_pos.sort()
	else:
		_attaching_bracket_slot_pos.clear()
		_attaching_bracket = null

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
	if _slot_states.has(true):
		apply_selected_texture(true, interactable_to_attach_res)

# ******************************************************************************
# Bracket attaches into another bracket mechanic.
func _manage_bracket_attachment(_bracket: Brackets) -> void:
	# Snapping Mechanic snippet.
	# Here lies the snapping mechanic for Vblox.
	# God knows what I am doing here.
	# If you read this code, I worked hard for it. I spent a week on this.
	# *cries in Christmas Vacation
	
	# To know more the logic behind this nonsense, you can view the
	# official documentation, which I made.
	# *cries in New Year Vacation
	
	# Check if there are currently brackets attempting to attach.
	if _attaching_bracket:
		# Check if the force of the bracket is lower than the threshold to hold snapping.
		if _check_bracket_snap():
			_snap_bracket(_bracket, _get_snap_offset())

# The offset of the bracket when snapped.
func _get_snap_offset() -> Vector3:
	# The offset of the bracket when snapped.
	var _offset: Vector3 = Vector3(0, 0, 0)
	
	# Calculate the bracket offset.
	# Full to full and full to partial slot logic.
	if !_slot_states.has(false):
		_offset.x = (_attaching_bracket_slot_pos[0] + _attaching_bracket_slot_pos[_attaching_bracket_slot_pos.size() - 1]) / 2
	
	# Partial to full and partial to partial slot logic.
	else:
		_offset.x = _attaching_bracket_slot_pos[0] - _slot_positions[_slot_detected_idx]
	
	return _offset

# Check if the force of the bracket is lower than the threshold to hold snapping
func _check_bracket_snap() -> bool:
	return SimulationEngine.fsnap(bracket.linear_velocity.length()) < _BRACKET_SNAP_THRESHOLD

# Snaps the bracket in place.
func _snap_bracket(_bracket: Brackets, _offset: Vector3) -> void:
	# Have the rotation as the attaching bracket.
	_bracket.global_rotation_degrees = _attaching_bracket.global_rotation_degrees
			
	# The values will vary depending on the slot it was placed.
	# Lerp the snapping mechanic offset x.
	_bracket.global_transform.origin = lerp(
		_bracket.global_transform.origin, 
		_attaching_bracket.global_transform.origin + (_attaching_bracket.global_transform.basis * _offset), 
		_BRACKET_SNAP_LRP_WEIGHT)
		
	# Lerp the constant 0.125 y offset.
	_bracket.global_transform.origin.y = lerp(
		_bracket.global_transform.origin.y, 
		_bracket.global_transform.origin.y + _BRACKET_SNAP_HEIGHT, 
		_BRACKET_SNAP_LRP_WEIGHT)
		
	# Reset the linear velocity of the bracket when snapping.
	_bracket.linear_velocity = Vector3(0, 0, 0)
	_bracket.angular_velocity = Vector3(0, 0, 0)

# ******************************************************************************
# Bracket detaches from another bracket mechanic.
func _manage_bracket_detachment(_bracket: Brackets) -> void:
	pass

# ******************************************************************************
# DEBUG
func manage_debug() -> void:
	SimulationEngine.manage_debug_entries(str("     Slot States of " + str(self.name)), str(_slot_states), !self.is_selected)
	SimulationEngine.manage_debug_entries(str("     Slot Positions of " + str(self.name)), str(_slot_positions), !self.is_selected)
	@warning_ignore("incompatible_ternary")
	SimulationEngine.manage_debug_entries(str("     Attaching Slots Detected of " + str(self.name)), str(_attaching_bracket.name if _attaching_bracket else _attaching_bracket) + " " + str(_attaching_bracket_slot_pos), !self._attaching_bracket)
	
