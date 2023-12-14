# ******************************************************************************
#  config.gd
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

extends Node

# ******************************************************************************
# RULES | DOCUMENTATION AND CODE

# Comments // The comments describes the code BELOW it. Not above it.
# Comments // Multi-Line isn't supported yet :>

# Naming // Variables starts first with what they are for.

# Subroutines // Don't use the word "initiate", "start"... Especially when startLoading,
# Subroutines // Just use "load", "check"... 
# Subroutines // For functions, verb must be the first word. It must whole.

# Signals // Start with the word "on".

# ******************************************************************************
# USER INTERFACE THEMES

# Themes.
enum {
	EXAMPLE = 0,               # Not included in the cycle. Just for example.
	DARK_THEME = 1, 
	LIGHT_THEME = 2
}

# Current theme of the interface.
var current_theme: int = DARK_THEME

# Default user themes.
var user_themes: Dictionary = {
	# Can add new themes here via: user_themes["theme_name"] = [color_values]
	# This is the default values. 
	"example": [
		Color.html("FFFFFF"),                        # Background Color
		Color.html("FFFFFF"),                        # Background Font Color
		Color.html("FFFFFF"),                        # Background Button Pressed Color
		Color.html("FFFFFF"),                        # Background Button Hovered Color
		Color.html("FFFFFF"),                        # Simulate Panel Color
		Color.html("FFFFFF"),                        # Learn Panel Color
		Color.html("FFFFFF"),                        # Panel Font Color
		Color.html("FFFFFF"),                        # Panel Button Pressed Color
		Color.html("FFFFFF"),                        # Panel Button Hovered Color
	],
	
	"DARK": [
		Color.html("121212"),                        
		Color.html("272727"), 
		Color.html("1c1c1c"),                       
		Color.html("191919"),  
		Color.html("202020"),                                          
		Color.html("191919"),                           
		Color.html("7f7f7f"),
		Color.html("5c5c5c"),                        
		Color.html("979797"),               
	],
	
	"LIGHT": [
		Color.html("e6e6e6"),                        
		Color.html("d9d9d9"),      
		Color.html("e1e1e1"),                       
		Color.html("ffffff"),                  
		Color.html("ffffff"),                        
		Color.html("e9e9e9"),                        
		Color.html("474747"),                
	]
}

# ******************************************************************************
# FREE-CAMERA MOVEMENT CONFIGURATIONS

# Camera movement multiplier.
var cam_sprint_mult: float = 2.0                   
var cam_crouch_mult: float = 0.5
var cam_vel_mult: Vector3 = Vector3(1.1, 0.2, 50) 

# Camera sensitivity.
var cam_sens: float = 0.25                 

# Camera clearance.
var cam_clearance: Vector2 = Vector2(0.6, 500)

# Camera movement keys.
var cam_movement_keys: Dictionary = {   
	# The state that can only be overwritten is the 'keybind' value.
	# This is the default values.          
	# "camera_movement": [keybind,     state] 
	"cam_up":            [KEY_Q,       false],
	"cam_down":          [KEY_E,       false],
	"cam_forward":       [KEY_W,       false],
	"cam_backward":      [KEY_S,       false],
	"cam_left":          [KEY_A,       false],
	"cam_right":         [KEY_D,       false],
	"cam_sprint":        [KEY_CTRL,    false],
	"cam_crouch":        [KEY_ALT,     false]
}

# ******************************************************************************
# DEBUG
var debug_enabled: bool = true
var _debug_report: Dictionary

# ******************************************************************************
# VIRTUAL
func _physics_process(_delta) -> void:
	
	
	# Simulation Engine debug report.
	_manage_debug()

func _manage_debug() -> void:
	append_debug("FPS", Engine.get_frames_per_second())

# ******************************************************************************
# TOOLS
# Return a string 'null' if variable has null value.
func print_null_string(_check_variable) -> String:
	var output: String
	if _check_variable == null:
		output = "<null>"
	else:
		output = _check_variable.to_string()
	return output

# Tool for appending debug values.
func append_debug(_identifier: String, _value: Variant) -> void:
	_debug_report[_identifier] = _value

# Clean the debug string for visuals.
func debug_report() -> String:
	var _str_debug_report: String = ""
	if debug_enabled:
		for _debug in _debug_report.size():
			_str_debug_report += String("{} | {}\n").format([_debug_report.keys()[_debug], _debug_report.values()[_debug]], "{}")
	return _str_debug_report

