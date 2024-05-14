# ******************************************************************************
# simulation_interface.gd
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

extends Control

# Simulation map scene file location.
const _MAIN_MENU_SCN_FILE: String = "res://assets/scenes/main_menu/main_menu.tscn"

# Interface nodes.
@onready var _background: ColorRect = get_node("background")
# Interactables menu.
@onready var _interactables_menu_panel_res: Resource = preload("res://assets/materials/simulation/interactables_menu_panel.tres")

# Pause menu interface nodes.
@onready var _pause_menu: Control = get_node("pause_menu")
@onready var _pause_menu_btn: Button = get_node("pause_menu/menu_button")
# Disclaimer.
@onready var _pause_men_disc_text: Label = get_node("pause_menu/disclaimer")

# Virtual Environment objects.
@onready var _environment_camera: Camera3D = get_parent().get_node("camera")

# Debug
@onready var _debug_report_text: Label = get_node("debug_text")

# Pause manager.
var _is_paused: bool = false

# ******************************************************************************
# INITIATION

# Initiate logic.
func _ready() -> void:
	# Setting the theme and animating the panel for splash.
	_apply_theme()
	
	# Remind user that they are accessing an ALPHA feature.
	_animate_pause_menu()
	_manage_pause()

# ******************************************************************************
# PHYSICS
func _physics_process(_delta):
	# Print the simulation engine's debug report.
	_display_debug_report()

# ******************************************************************************
# INPUT EVENTS

func _input(_event) -> void:
	if _event is InputEventKey:
		if _event.keycode == Configuration.interface_keys.values()[0] and _event.pressed:
			_animate_pause_menu()
			_manage_pause()
			
			# Manages simulation nodes / objects.
			_manage_simulation()

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS

# Change theme logic.
func _apply_theme() -> void:
	# Set theme on background interfaces.
	_background.color = Configuration.user_themes.values()[Configuration.current_theme][0]
	_background.color.a = 0
	
	# Disclaimer text.
	_pause_men_disc_text.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][9])
	
	# Interactables menu.
	_interactables_menu_panel_res.bg_color = Configuration.user_themes.values()[Configuration.current_theme][0]
	_interactables_menu_panel_res.bg_color.a = 0.15

# Animate pause menu.
func _animate_pause_menu() -> void:
	# Creating tween managers.
	var _anim_bg_opacity: Tween = create_tween()
	var _anim_menu_opacity: Tween = create_tween()
	var _anim_menu_pos: Tween = create_tween()
	
	# Create parameters for tween.
	var _final_color: float
	var _final_pos: Vector2 = Vector2.ZERO
	const _COLOR_DURATION: float = 0.25
	const _POS_DURATION: float = 0.5
	
	# When interface is paused, tween the menu.
	if !_is_paused:
		_is_paused = true
		_final_color = 0.75
		_final_pos = Vector2.ZERO
		
		# Resets the position and modulate so that the tween can be played.
		_pause_menu.position = Vector2(0, 50)
	else:
		_is_paused = false
		_final_color = 0
		_final_pos = Vector2(0, 50)
		
		_pause_menu.position = Vector2(0, 0)
	
	# Play tween animations.
	_anim_bg_opacity.tween_property(_background, "color:a", _final_color,  _COLOR_DURATION).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	_anim_menu_opacity.tween_property(_pause_menu, "modulate:a", _final_color,  _COLOR_DURATION * 1.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	_anim_menu_pos.tween_property(_pause_menu, "position", _final_pos, _POS_DURATION).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

# Manage pause of tree.
func _manage_pause(_paused: bool = _is_paused) -> void:
	get_tree().paused = _paused
	_is_paused = _paused
	
	# Unlocks the mouse.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Signal from button to go to menu.
func _on_menu_button_pressed():
	# Change the button to "Loading..." for user experience.
	_pause_menu_btn.disabled = true
	_pause_menu_btn.text = "Loading..."
	
	# Toggles pause of tree.
	_manage_pause(false)
	
	# Creates a timer for 3s so to make sure the player know that its "changing the scene".
	await get_tree().create_timer(Configuration.LOADING_TIME).timeout
	
	# Change the scene.
	get_tree().change_scene_to_file(_MAIN_MENU_SCN_FILE)

# ******************************************************************************
# OUTSIDE COMMUNICATIONS | Snippets that communicate to other nodes / scripts.

# Manage simulation here. Physics, interaction.
func _manage_simulation() -> void:
	# Disables movement of camera when paused.
	_environment_camera.cam_movement_enabled = not _is_paused

# Display debug report on-screen.
func _display_debug_report():
	# Prints the debug report of the simulation engine.
	_debug_report_text.text = Configuration.debug_report()

# ******************************************************************************
# Interactables.

func _on_bracket_1_pressed() -> void:
	get_parent().add_interactable("bracket1x")

func _on_bracket_2_pressed() -> void:
	get_parent().add_interactable("bracket2x")

func _on_bracket_3_pressed() -> void:
	get_parent().add_interactable("bracket3x")

func _on_bracket_4_pressed() -> void:
	get_parent().add_interactable("bracket4x")

func _on_bracket_5_pressed() -> void:
	get_parent().add_interactable("bracket5x")
