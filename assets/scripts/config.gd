# ******************************************************************************
#  config.gd
# ******************************************************************************
#                             This file is part of
#                      RESEARCH CAPSTONE PROJECT - VBlox
# ******************************************************************************
#  Copyright (c) 2023-present 12 ESTEMC-3 GROUP 6
#  Aicelle Claro
#  Shannja Ashley Malelang
#  Monique Marcos
#  Nica Shane Mijares
#  Precious Nina Sarol
#  *****************************************************************************
#  MIT License
#  Copyright (c) 2023 12 ESTEMC-3 GROUP 6
#
#  Permission is hereby granted, free of charge, to any person obtaining
#  a copy of this software and associated documentation files (the
#  "Software"), to deal in the Software without restriction, including
#  without limitation the rights to use, copy, modify, merge, publish,
#  distribute, sublicense, and/or sell copies of the Software, and to
#  permit persons to whom the Software is furnished to do so, subject to
#  the following conditions:
#
#  The above copyright notice and this permission notice shall be
#  included in all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS," WITHOUT WARRANTY OF ANY KIND,
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ******************************************************************************

extends Node

# ******************************************************************************
# USER INTERFACE THEME

# Default user themes.
var user_themes: Dictionary = {
	# Can add new themes here via: user_themes["theme_name"] = [color_values]
	# This is the default values. 
	"dev_test": [
		Color.html("FFFFFF"),                        # Background Color
		Color.html("FFFFFF"),                        # Background Font Color
		Color.html("FFFFFF"),                        # Learn Panel Color
		Color.html("FFFFFF"),                        # Simulate Panel Color
		Color.html("FFFFFF"),                        # Panel Font Color
	],
	
	"Default Dark": [
		Color.html("121212"),                        
		Color.html("272727"),                        
		Color.html("191919"),                        
		Color.html("202020"),                        
		Color.html("7f7f7f"),              
	],
	
	"Default Light": [
		Color.html("121212"),                        
		Color.html("272727"),                        
		Color.html("191919"),                        
		Color.html("202020"),                        
		Color.html("7f7f7f"),                
	]
}

# ******************************************************************************

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
