# ******************************************************************************
# main_menu_interface.gd
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
const _SIMULATION_SCN_FILE: String = "res://assets/scenes/simulation_map/simulation_map.tscn"

# Coding area scene file location.
const _CODING_AREA_SCN_FILE: String = "res://assets/scenes/coding_area/coding_area.tscn"

# Github Website of the capstone project.
const _SIMULATION_SOURCE_CODE: String = "https://github.com/sh4nnja/school-project-CAPSTONE-VBlox"

# Portfolio Website of the capstone developers.
const _SIMULATION_TEAM: String = "https://tinyurl.com/vblox-pilot-testing"

# Main interfaces.
@onready var _body: Control = get_node("user_interface/body")

# Background interface.
@onready var _background: ColorRect = get_node("background")
@onready var _title: Label = get_node("user_interface/header/title")
@onready var _version: Label = get_node("user_interface/footer/version")
@onready var _line_panel_res: Resource = preload("res://assets/materials/main_menu/main_menu_line_panel.tres")

# Learn interface.
@onready var _learn_panel_res: Resource = preload("res://assets/materials/main_menu/main_menu_learn_panel.tres")
@onready var _learn_panel_txt: Label = get_node("user_interface/body/simulate_panel/learn_panel/learn_text")
@onready var _learn_panel_desc: Label = get_node("user_interface/body/simulate_panel/learn_panel/learn_desc_text")

@onready var _learn_editor_button: Button = get_node("user_interface/body/simulate_panel/learn_panel/editor_button")

# Simulate interface.
@onready var _sim_panel_res: Resource = preload("res://assets/materials/main_menu/main_menu_simulate_panel.tres")
@onready var _sim_panel_txt: Label = get_node("user_interface/body/simulate_panel/simulate_text")
@onready var _sim_panel_desc: Label = get_node("user_interface/body/simulate_panel/simulate_desc_text")
@onready var _simulate_btn: Button = get_node("user_interface/body/simulate_panel/simulate_button")

# Info and credit interface.
@onready var _about_panel_text: Label = get_node("user_interface/body/simulate_panel/about_panel/about_text")
@onready var _about_panel_desc: Label = get_node("user_interface/body/simulate_panel/about_panel/about_desc_text")

# Navigation interface.
@onready var _exit_button = get_node("user_interface/header/exit_button")
@onready var _theme_button = get_node("user_interface/footer/theme_button")

# ******************************************************************************
# INITIATION

# Initiate logic.
func _ready() -> void:
	# Setting the theme and animating the panel for splash.
	_apply_theme()
	_animate_panel()

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS

# Set interface theme logic.
func _apply_theme() -> void:
	# Changes the text to the right theme.
	_theme_button.text = Configuration.user_themes.keys()[Configuration.current_theme]
	
	# Set theme on background interfaces.
	_background.color = Configuration.user_themes.values()[Configuration.current_theme][0]
	_title.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][1])
	_version.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][1])
	_line_panel_res.bg_color = Configuration.user_themes.values()[Configuration.current_theme][1]
	
	# Set theme on learn panel interfaces.
	_sim_panel_res.bg_color = Configuration.user_themes.values()[Configuration.current_theme][5]
	
	# Set theme on simulate panel interfaces.
	_learn_panel_res.bg_color = Configuration.user_themes.values()[Configuration.current_theme][4]
	
	# Set theme on panel texts.
	_sim_panel_txt.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][6])
	_sim_panel_desc.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][6])
	
	_learn_panel_txt.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][6])
	_learn_panel_desc.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][6])
	
	_about_panel_text.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][6])
	_about_panel_desc.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][6])
	
	# Set theme on navigation buttons.
	_exit_button.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][1])
	_exit_button.add_theme_color_override("font_pressed_color", Configuration.user_themes.values()[Configuration.current_theme][2])
	_exit_button.add_theme_color_override("font_hover_color", Configuration.user_themes.values()[Configuration.current_theme][3])
	_exit_button.add_theme_color_override("font_focus_color", Configuration.user_themes.values()[Configuration.current_theme][1])
	
	_theme_button.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][1])
	_theme_button.add_theme_color_override("font_pressed_color", Configuration.user_themes.values()[Configuration.current_theme][2])
	_theme_button.add_theme_color_override("font_hover_color", Configuration.user_themes.values()[Configuration.current_theme][3])
	_theme_button.add_theme_color_override("font_focus_color", Configuration.user_themes.values()[Configuration.current_theme][1])

# Animate panel via tweening.
func _animate_panel() -> void:
	# Create tween managers.
	var _anim_panel_opacity: Tween = create_tween()
	var _anim_panel_pos:  Tween = create_tween()
	
	# Create parameters for the tween.
	const _FINAL_COLOR: float = 1.0
	const _FINAL_POS: Vector2 = Vector2.ZERO
	const _COLOR_DURATION: float = 0.75
	const _POS_DURATION: float = 0.5
	
	# Resets the position and modulate so that the tween can be played.
	_body.modulate.a = 0
	_body.position = Vector2(0, 50)
	
	# Play tween animations.
	_anim_panel_opacity.tween_property(_body, "modulate:a", _FINAL_COLOR, _COLOR_DURATION).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	_anim_panel_pos.tween_property(_body, "position", _FINAL_POS, _POS_DURATION).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

# Signal from button to exit.
func _on_exit_button_pressed() -> void:
	# Quit game. DUH.
	get_tree().quit()

# Signal from button to toggle themes.
func _on_theme_button_pressed() -> void:
	# Cycle the themes. Allows for adding more themes without changing the code again.
	Configuration.current_theme += 1
	if Configuration.current_theme > Configuration.user_themes.keys().size() - 1:
		# Make sure not to toggle dev_test theme.
		Configuration.current_theme = 1              
	
	# Changes the theme and the text and play panel animation so it doesn't look flat.
	_apply_theme()
	_animate_panel()

# Signal from button to go to simulation.
func _on_simulate_button_pressed():
	_load_scene(_simulate_btn, _SIMULATION_SCN_FILE)

# Signal from button to go to the code editor.
func _on_editor_button_pressed():
	_load_scene(_learn_editor_button, _CODING_AREA_SCN_FILE)

# Signal from button to open a website of the source code.
func _on_about_github_pressed():
	# Use "OS.shell_open()" to open website.
	OS.shell_open(_SIMULATION_SOURCE_CODE)

# Signal from button to open a website of the team portfolio.
func _on_about_the_team_pressed():
	# Use "OS.shell_open()" to open website.
	OS.shell_open(_SIMULATION_TEAM)

# Move on to the tasks so that user can learn coding.


# ******************************************************************************
# Simualate loading.
func _load_scene(_button: Node, _scn: String) -> void:
	# Change the button to "Loading..." for user experience.
	_button.disabled = true
	_button.text = "Loading..."
	
	# Creates a timer for 3s so to make sure the player know that its "changing the scene".
	await get_tree().create_timer(Configuration.LOADING_TIME).timeout
	
	# Change the scene.
	get_tree().change_scene_to_file(_scn)



func _on_task_1_pressed():
	pass # Replace with function body.
