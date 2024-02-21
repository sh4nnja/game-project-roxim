# ******************************************************************************
# brackets.gd
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
const _BRACKET_SNAP_ROT_INCR: float = 0.5 

# Checks the bracket if it snaps once. So that the brackets are aligned unless user wants to rotate.
var _toggle_snap: bool = false
var _snapped_once: bool = false

# ******************************************************************************
# ATTACHMENT AND DETACHMENT MECHANIC
# Joint Bias or force to pull together.
const _JOINT_BIAS: float = 0.99

# Check if bracket is currently attached to another one.
var _attach_bracket: bool = false

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# Managing bracket mechanics such as attaching and disappearing.
func manage_mechanics(_bracket: Brackets, _is_enabled: bool) -> void:
	# Make the bracket active for attachment when selected.
	# This will save performance for unnecessary detections.
	for _child in _bracket.get_children():
		if _child is Area3D:
			# Sets the collision and monitoring status to detect other brackets.
			_child.monitoring = _is_enabled
			_child.set_collision_mask_value(1, _is_enabled)
	
	# All statements must be under here so that it doesn't work whenever the bracket is not selected.
	# This code should save performance by not doing unnecessary calculations when not selected.
	if _is_enabled:
		# Manage bracket visibility when hovered.
		_manage_bracket_hover(_bracket)
		
		# Manage snapping of brackets.
		_manage_bracket_snapping(_bracket)
		
		# Attempting to attach bracket to another bracket logic.
		_manage_bracket_attachment(_bracket)

# Initiate 'slot' size function. This will vary by each bracket.
# Setting up this function is a must for clean code I suppose.
func initiate_brackets(_bracket: Brackets, _bracket_size: int) -> void:
	# Update the bracket, its slots, the slots position etc.
	for _slot_idx in range(_bracket.get_child_count()):
		var _slot: Node3D = _bracket.get_child(_slot_idx)
		# Checks if the slot is an Area3D.
		if _slot is Area3D:
			# Append '_slot' position.
			_slot_positions.append(SimulationEngine.fsnap(_slot.transform.origin.x))
			# Append false, meaning the slot is not occupied. 
			_slot_states.append(false)
	
	# Changes what type of bracket currently have.
	bracket_type = _bracket_size
	# Update the bracket.
	bracket = _bracket
	
	# Initiate physics related configs.
	bracket.angular_damp = 5
	bracket.angular_damp_mode = RigidBody3D.DAMP_MODE_COMBINE

# Manage slot detection for the bracket signals.
func manage_slot_detection(_idx: int, _is_bracket_detected: bool, _detected_bracket: Area3D) -> void:
	# _idx                     -> index of slot that has been detected.
	# _is_bracket_detected     -> the bracket's _idx state.
	# _detected_bracket        -> the bracket object being detected.
	
	# Sets the current detected slot index.
	_slot_detected_idx = _idx
	# Set the boolean value of _slot_detected_idx in the slots array.
	_slot_states[_slot_detected_idx] = _is_bracket_detected
	if _is_bracket_detected:
		# Sets the attaching bracket as the bracket the current bracket attempts to attach to.
		# The Area3D parent which is the bracket.
		_attaching_bracket = _detected_bracket.get_parent()
		_attaching_bracket_slot_pos.append(SimulationEngine.fsnap(_detected_bracket.transform.origin.x))
		# Sorts the bracket position in order to make sure that the positions are correct.
		_attaching_bracket_slot_pos.sort()
	else:
		# Checks if currect bracket is currently connected to the bracket.
		if !_attach_bracket:
			_attaching_bracket_slot_pos.clear()
			_attaching_bracket = null

# Bracket will change overlay color and revert whenever it hovers in another bracket.
func _manage_bracket_hover(_bracket: Brackets) -> void:
	# This just means that if a slot has detected a possible slot.
	# Apply 'can_attach' texture.
	if _slot_states.has(true):
		apply_selected_texture(!_attach_bracket, interactable_to_attach_res)

# ******************************************************************************
# Check if the force of the bracket is lower than the threshold to hold snapping
func _check_bracket_snap() -> bool:
	return SimulationEngine.fsnap(bracket.linear_velocity.length()) < _BRACKET_SNAP_THRESHOLD

# Bracket attaches into another bracket mechanic.
func _manage_bracket_snapping(_bracket: Brackets) ->  void:
	# Snapping Mechanic snippet.
	# Here lies the snapping mechanic for Vblox.
	# God knows what I am doing here.
	# If you read this code, I worked hard for it. I spent a month on this.
	# *cries in Christmas Vacation
	
	# To know more the logic behind this nonsense, you can view the
	# official documentation, which I made.
	# *cries in New Year Vacation
	
	# Check if there are currently brackets attempting to attach.
	if _attaching_bracket:
		# Check if the force of the bracket is lower than the threshold to hold snapping.
		if _check_bracket_snap() and !_attach_bracket:
			_snap_bracket(_bracket, _get_snap_offset())
		else:
			_snapped_once = false
	else:
		_snapped_once = false

# The offset of the bracket when snapped.
func _get_snap_offset() -> Vector3:
	# The offset of the bracket when snapped.
	var _offset: Vector3 = Vector3(0, 0, 0)
	
	# Calculate the bracket offset.
	# Full to full and full to partial slot logic.
	if !_slot_states.has(false):
		# It gets the midpoint position of the first slot attached and the last slot attached.
		# It should work at any bracket as the '_attaching_bracket_slot_pos' array can be used to get the midpoint.
		_offset.x = (_attaching_bracket_slot_pos[0] + _attaching_bracket_slot_pos[_attaching_bracket_slot_pos.size() - 1]) / 2

	# Partial to full and partial to partial slot logic. 
	else:
		# Have the output of the first slot of the attaching bracket and the slot detected in the current bracket.
		_offset.x = _attaching_bracket_slot_pos[0] - _slot_positions[_slot_detected_idx]
	
	return _offset

# Take note the current rotation of the current bracket.
# So when attaching, there's options for rotation.
func _get_rotated_slot_pos(_pos: Vector3, _rotation_degrees: float, _pivot: Vector3) -> Vector3:
	# Transforms the rotation from degrees to radians.
	var _rot_rad: float = deg_to_rad(_rotation_degrees)
	
	# Adjust the position relative to the pivot point.
	var _adjusted_pos: Vector3 = _pos - _pivot
	
	# Updates the position by the angle.
	# It takes note of the rotation of the attaching bracket so that it will not overshoot.
	var _rot_pos: Vector3 = _adjusted_pos.rotated(Vector3.UP,  _rot_rad - _attaching_bracket.rotation.y)
	
	# Adjust back to the original coordinate system.
	_rot_pos += _pivot
	
	# Update values to be returned and used.
	return _rot_pos

# Snaps the bracket in place.
func _snap_bracket(_bracket: Brackets, _offset: Vector3) -> void:
	if _toggle_snap:
		if !_snapped_once:
		# Snaps the bracket's rotation in y-axis once. 
			_bracket.rotation_degrees.y = _attaching_bracket.rotation_degrees.y
			_snapped_once = true
	else:
		# Check if the brackets doesn't have the same rotation.
		if SimulationEngine.fsnap(_bracket.rotation_degrees.y) != SimulationEngine.fsnap(_attaching_bracket.rotation_degrees.y):
			# Apply Origin | Rotation | Transform Logic here.
			_offset = _get_rotated_slot_pos(_offset, _bracket.rotation_degrees.y, Vector3(_attaching_bracket_slot_pos[_attaching_bracket_slot_pos.size() - 1], 0, 0))
	
	# Snaps the bracket's rotation except y-axis.
	_bracket.global_rotation_degrees.x = lerp(
		_bracket.global_rotation_degrees.x, 
		_attaching_bracket.global_rotation_degrees.x,
		_BRACKET_SNAP_LRP_WEIGHT
	)
	
	_bracket.global_rotation_degrees.z = lerp(
		_bracket.global_rotation_degrees.z, 
		_attaching_bracket.global_rotation_degrees.z,
		_BRACKET_SNAP_LRP_WEIGHT
	)
	
	# The values will vary depending on the slot it was placed.
	# Lerp the snapping mechanic offset x.
	_bracket.global_transform.origin = lerp(
		_bracket.global_transform.origin, 
		_attaching_bracket.global_transform.origin + (_attaching_bracket.global_transform.basis * _offset), 
		_BRACKET_SNAP_LRP_WEIGHT
	)
	
	# Lerp the constant 0.125 y offset.
	_bracket.global_transform.origin.y = lerp(
		_bracket.global_transform.origin.y, 
		_bracket.global_transform.origin.y + _BRACKET_SNAP_HEIGHT, 
		_BRACKET_SNAP_LRP_WEIGHT
	)
	
	# Reset the linear velocity of the bracket when snapping.
	_bracket.linear_velocity = Vector3(0, 0, 0)

# ******************************************************************************
# Manage bracket attachment mechanicd.
func _manage_bracket_attachment(_bracket: Brackets):
	if _attaching_bracket:
		# Creates a joint, attempting to connect the brackets.
		if _attach_bracket:
			_attach_brackets(_slot_positions[_slot_detected_idx], _bracket)
		# Removes the joint, disconnecting the brackets.
		else:
			pass

func _check_bracket_joint(_bracket_to_check: Brackets) -> bool:
	var _output: bool = false
	# Iterates the child nodes to check if one is a joint.
	for _child in _bracket_to_check.get_children():
		if _child is HingeJoint3D:
			_output = true
	return _output

func _attach_brackets(_offset: float, _bracket: Brackets) -> void:
	if !_check_bracket_joint(_attaching_bracket):
		# Create the Hinge Joint Node.
		var _joint: HingeJoint3D = HingeJoint3D.new()
		var _joint_pos: Vector3 = Vector3.ZERO
		
		# Attach it to the bracket.
		_attaching_bracket.add_child(_joint)
		
		# Adjust positions.
		_joint_pos.x = _offset
		_joint.set_position(_joint_pos)
		
		# Reparent the other bracket under the joint so the tree will be clean.
		_bracket.reparent(_joint, true)
		
		# Adjust joint configuration.
		_joint.node_a = _bracket.get_path()
		_joint.node_b = _attaching_bracket.get_path()
		_joint.set_param(HingeJoint3D.PARAM_BIAS, _JOINT_BIAS)
		_joint.set_flag(HingeJoint3D.FLAG_USE_LIMIT, true)
		_joint.set_param(HingeJoint3D.PARAM_LIMIT_UPPER, 0)
		_joint.set_param(HingeJoint3D.PARAM_LIMIT_LOWER, 0)

# ******************************************************************************
# Bracket Tools.
# Rotate the bracket and relay its rotation to recalculate the offset.
func rotate_bracket_snap(_invert: bool) -> void:
	if !_toggle_snap and _slot_states.has(false):
		# Increment / Decrement the bracket's rotation.
		bracket.angular_velocity.y += _BRACKET_SNAP_ROT_INCR if _invert else -_BRACKET_SNAP_ROT_INCR

func toggle_snap() -> void:
	if !_toggle_snap:
		_toggle_snap = true
	else:
		_toggle_snap = false

func toggle_bracket_attachment() -> void:
	if !_attach_bracket:
		_attach_bracket = true
	else:
		_attach_bracket = false

# ******************************************************************************
# DEBUG
func manage_debug() -> void:
	pass
