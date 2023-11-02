# ******************************************************************************
#  main_menu_interface.gd
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

# Simulate interface.
@onready var _sim_panel_res: Resource = preload("res://assets/materials/main_menu/main_menu_simulate_panel.tres")
@onready var _sim_panel_txt: Label = get_node("user_interface/body/simulate_panel/simulate_text")
@onready var _sim_panel_desc: Label = get_node("user_interface/body/simulate_panel/simulate_desc_text")
@onready var _simulate_btn: Button = get_node("user_interface/body/simulate_panel/simulate_button")

# Info and credit interface.
@onready var _about_panel_text: Label = get_node("user_interface/body/simulate_panel/about_panel/about_text")


# Navigation interface.
@onready var _exit_button = get_node("user_interface/header/exit_button")
@onready var _theme_button = get_node("user_interface/footer/theme_button")

# ******************************************************************************
# INITIATION

# Initiate logic.
func _ready() -> void:
	# Setting the theme and animating the panel for splash.
	_change_theme()
	_animate_panel()

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS

# Set interface theme logic.
func _change_theme() -> void:
	# Changes the text to the right theme.
	_theme_button.text = config.user_themes.keys()[config.current_theme]
	
	# Set theme on background interfaces.
	_background.color = config.user_themes.values()[config.current_theme][0]
	_title.add_theme_color_override("font_color", config.user_themes.values()[config.current_theme][1])
	_version.add_theme_color_override("font_color", config.user_themes.values()[config.current_theme][1])
	_line_panel_res.bg_color = config.user_themes.values()[config.current_theme][1]
	
	# Set theme on learn panel interfaces.
	_sim_panel_res.bg_color = config.user_themes.values()[config.current_theme][5]
	
	# Set theme on simulate panel interfaces.
	_learn_panel_res.bg_color = config.user_themes.values()[config.current_theme][4]
	
	# Set theme on panel texts.
	_sim_panel_txt.add_theme_color_override("font_color", config.user_themes.values()[config.current_theme][6])
	_sim_panel_desc.add_theme_color_override("font_color", config.user_themes.values()[config.current_theme][6])
	_learn_panel_txt.add_theme_color_override("font_color", config.user_themes.values()[config.current_theme][6])
	_learn_panel_desc.add_theme_color_override("font_color", config.user_themes.values()[config.current_theme][6])
	_about_panel_text.add_theme_color_override("font_color", config.user_themes.values()[config.current_theme][6])
	
	# Set theme on navigation buttons.
	_exit_button.add_theme_color_override("font_color", config.user_themes.values()[config.current_theme][1])
	_exit_button.add_theme_color_override("font_pressed_color", config.user_themes.values()[config.current_theme][2])
	_exit_button.add_theme_color_override("font_hover_color", config.user_themes.values()[config.current_theme][3])
	_exit_button.add_theme_color_override("font_focus_color", config.user_themes.values()[config.current_theme][1])
	
	_theme_button.add_theme_color_override("font_color", config.user_themes.values()[config.current_theme][1])
	_theme_button.add_theme_color_override("font_pressed_color", config.user_themes.values()[config.current_theme][2])
	_theme_button.add_theme_color_override("font_hover_color", config.user_themes.values()[config.current_theme][3])
	_theme_button.add_theme_color_override("font_focus_color", config.user_themes.values()[config.current_theme][1])

# Animate panel via tweening.
func _animate_panel() -> void:
	# Create tween managers.
	var _anim_panel_opacity: Tween = create_tween()
	var _anim_panel_pos:  Tween = create_tween()
	
	# Create parameters for the tween.
	var _final_color: float = 1.0
	var _final_pos: Vector2 = Vector2.ZERO
	var _color_duration: float = 0.75
	var _pos_duration: float = 0.5
	
	# Resets the position and modulate so that the tween can be played.
	_body.modulate.a = 0
	_body.position = Vector2(0, 50)
	
	# Play tween animations.
	_anim_panel_opacity.tween_property(_body, "modulate:a", _final_color, _color_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	_anim_panel_pos.tween_property(_body, "position", _final_pos, _pos_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

# Signal from button to exit.
func _on_exit_button_pressed() -> void:
	# Quit game. DUH.
	get_tree().quit()

# Signal from button to toggle themes.
func _on_theme_button_pressed() -> void:
	# Cycle the themes. Allows for adding more themes without changing the code again.
	config.current_theme += 1
	if config.current_theme > config.user_themes.keys().size() - 1:
		# Make sure not to toggle dev_test theme.
		config.current_theme = 1              
	
	# Changes the theme and the text and play panel animation so it doesn't look flat.
	_change_theme()
	_animate_panel()

# Signal from button to go to simulation.
func _on_simulate_button_pressed():
	# Change the button to "Loading..." for user experience.
	_simulate_btn.disabled = true
	_simulate_btn.text = "Loading..."
	
	# Creates a timer for 3s so to make sure the player know that its "changing the scene".
	await get_tree().create_timer(3).timeout
	
	# Change the scene.
	get_tree().change_scene_to_file("res://assets/scenes/simulation_map/simulation_map.tscn")
