# ******************************************************************************
#  interactor.gd
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

extends RayCast3D

# Crosshair node for the crosshair texture.
@onready var _crosshair: TextureRect = get_node("crosshair")

# Current object being handled.
var _interacted_object: RigidBody3D

var _interacted_obj_grab_speed: int = 3

# Take note of 'interactables' being interacted / hovered.
var _curr_hovered_interactable: RigidBody3D
var _last_hovered_interactable: RigidBody3D

# ******************************************************************************
# INITIATION

# ******************************************************************************
# INPUT EVENTS
func _input(_event):
	# Draggin / Moving 'interactable' mechanic.
	_dragging_interactable(_event)

# ******************************************************************************
# PHYSICS
func _physics_process(_delta):
	# Hover effect on 'interactables' mehanic.
	_hover_and_select_interactables()
	# Dragging physics.
	_apply_physics_interactable()
	
	# Managing debug
	_manage_debug()

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# Detect 'interactables'.
func _hover_and_select_interactables() -> void:
	# Enables the hover mechanic if there's no interactable to be dragged.
	if !_interacted_object:
		# Check if 'interactor' is hovering or selecting 'interactables'.
		if is_colliding() and get_collider() is RigidBody3D:
			_curr_hovered_interactable = get_collider()
			if _last_hovered_interactable != _curr_hovered_interactable:
				# Checks if there's a last object hovered so it reverts it back to none.
				if _last_hovered_interactable:
					_last_hovered_interactable.apply_selected_texture(false)
				_last_hovered_interactable = _curr_hovered_interactable
				_curr_hovered_interactable.apply_selected_texture(true)
			# Play crosshair animation.
			_animate_crosshair(true)
		else:
			# Reverts all variables to none to make sure the cycle can repeat.
			if _last_hovered_interactable:
				_last_hovered_interactable.apply_selected_texture(false)
				_last_hovered_interactable = null
			_curr_hovered_interactable = null
			# Play crosshair animation.
			_animate_crosshair(false)
	else:
		# Apply texture to the dragged interactable indefinitely. As long as it is being dragged.
		_interacted_object.apply_selected_texture(true)
		_last_hovered_interactable = _interacted_object

# Animate crosshair for hovering.
func _animate_crosshair(_hovered: bool) -> void:
	var _crosshair_tween: Tween = create_tween()
	if _hovered:
		_crosshair_tween.tween_property(_crosshair, "scale", Vector2(1.5, 1.5), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	else:
		_crosshair_tween.tween_property(_crosshair, "scale", Vector2(1, 1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	_crosshair_tween.play()

# Register 'interactables' to be dragged when mouse event occurs.
func _dragging_interactable(_event) -> void:
	if _event is InputEventMouseButton:
		if is_colliding():
			if Input.is_action_just_pressed("MOUSE_BUTTON_LEFT"):
				# Check first if the collided 'interactable' is actually one.
				if get_collider() is RigidBody3D:
					# Place the 'interactable' into a variable for ref. Once released, it reverts to null.
					_interacted_object = get_collider()
			elif Input.is_action_just_released("MOUSE_BUTTON_LEFT"):
				_interacted_object = null
		else:
			# Default to null when no object being interacted.
			_interacted_object = null

# Apply physics when an 'interactable' is selected.
func _apply_physics_interactable() -> void:
	# Checks if 'interactable' is being interacted or a reference.
	if _interacted_object != null and weakref(_interacted_object).get_ref():
		# Apply physics of being dragged.
		var _interactor_pos: Vector3 = get_global_transform().origin
		var _interacted_object_pos: Vector3 = _interacted_object.get_global_transform().origin
		# Makes the object be grabbed and dragged.
		_interacted_object.set_linear_velocity((_interactor_pos - _interacted_object_pos) * _interacted_obj_grab_speed)

# ******************************************************************************
# DEBUG
func _manage_debug() -> void:
	config.append_debug("Current Hovered Object", _curr_hovered_interactable)
	config.append_debug("Dragging Object", _interacted_object)
