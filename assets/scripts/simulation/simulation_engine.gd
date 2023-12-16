# ******************************************************************************
#  simulation_engine.gd
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

extends Node3D

# Base class of SIMULATION ENGINE.
# All calculation of positions, random generations, and debugging etc will be located here.

# ******************************************************************************
# Snapping Mechanic
var bracket_snap_threshold: float = 1.5

# Speed of the 'interactable' when dragging.
var interacted_obj_grab_speed: int = 3

# ******************************************************************************
# VIRTUAL
func _physics_process(_delta) -> void:
	# Simulation Engine debug report.
	_manage_debug()

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS


# ******************************************************************************
# DEBUGGINE ENGINE
var debug_enabled: bool = true
var _debug_report: Dictionary

func _manage_debug() -> void:
	manage_debug_entries("FPS", Engine.get_frames_per_second())

# Return a string 'null' if variable has null value.
func print_null_string(_check_variable) -> String:
	var output: String
	if _check_variable == null:
		output = "<null>"
	else:
		output = _check_variable.to_string()
	return output

# Tool for appending debug values.
func manage_debug_entries(_identifier: String, _value: Variant, _remove: bool = false) -> void:
	if !_remove:
		_debug_report[_identifier] = _value
	else:
		_debug_report.erase(_identifier)

# Clean the debug string for visuals.
func debug_report() -> String:
	var _str_debug_report: String = ""
	if debug_enabled:
		for _debug in _debug_report.size():
			_str_debug_report += String("{} | {}\n").format([_debug_report.keys()[_debug], _debug_report.values()[_debug]], "{}")
	return _str_debug_report

