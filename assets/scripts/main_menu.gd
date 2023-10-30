# ******************************************************************************
#  main_menu.gd
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
@onready var _body: Control = get_node("menu/body")

# Background interface.
@onready var _background: ColorRect = get_node("background")
@onready var _title: Label = get_node("menu/header/title")
@onready var _version: Label = get_node("menu/footer/version")
@onready var _line_panel_res = preload("res://assets/materials/main_menu_line_panel.tres")

# Learn interface.
@onready var _learn_panel_res = preload("res://assets/materials/main_menu_learn_panel.tres")
@onready var _learn_panel_txt: Label = get_node("menu/body/simulate_panel/learn_panel/learn_text")

# Simulate interface.
@onready var _sim_panel_res = preload("res://assets/materials/main_menu_simulate_panel.tres")
@onready var _sim_panel_txt: Label = get_node("menu/body/simulate_panel/learn_panel/learn_text")

# Navigation interface.
@onready var _exit_button = get_node("menu/header/exit_button")
@onready var _theme_button = get_node("menu/footer/theme_button")

# Theme manager.
var _current_theme: int = 1

# ******************************************************************************
# INITIATION

# Initiate logic.
func _ready() -> void:
	_change_theme(_current_theme)
	_animate_panel()

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS

# Set interface theme logic.
func _change_theme(_chosen_theme: int) -> void:
	# Set theme on background interfaces.
	_background.color = config.user_themes.values()[_chosen_theme][0]
	_title.add_theme_color_override("font_color", config.user_themes.values()[_chosen_theme][1])
	_version.add_theme_color_override("font_color", config.user_themes.values()[_chosen_theme][1])
	_line_panel_res.bg_color = config.user_themes.values()[_chosen_theme][1]
	
	# Set theme on learn panel interfaces.
	_sim_panel_res.bg_color = config.user_themes.values()[_chosen_theme][5]
	
	# Set theme on simulate panel interfaces.
	_learn_panel_res.bg_color = config.user_themes.values()[_chosen_theme][4]
	
	# Set theme on panel texts.
	_sim_panel_txt.add_theme_color_override("font_color", config.user_themes.values()[_chosen_theme][6])
	_learn_panel_txt.add_theme_color_override("font_color", config.user_themes.values()[_chosen_theme][6])
	
	# Set theme on navigation buttons.
	_exit_button.add_theme_color_override("font_color", config.user_themes.values()[_chosen_theme][1])
	_exit_button.add_theme_color_override("font_pressed_color", config.user_themes.values()[_chosen_theme][2])
	_exit_button.add_theme_color_override("font_hover_color", config.user_themes.values()[_chosen_theme][3])
	_exit_button.add_theme_color_override("font_focus_color", config.user_themes.values()[_chosen_theme][1])
	
	_theme_button.add_theme_color_override("font_color", config.user_themes.values()[_chosen_theme][1])
	_theme_button.add_theme_color_override("font_pressed_color", config.user_themes.values()[_chosen_theme][2])
	_theme_button.add_theme_color_override("font_hover_color", config.user_themes.values()[_chosen_theme][3])
	_theme_button.add_theme_color_override("font_focus_color", config.user_themes.values()[_chosen_theme][1])

# Animate panel via tweening.
func _animate_panel() -> void:
	var _anim_tween: Tween = create_tween()
	var _anim_tween2:  Tween = create_tween()
	var _final_color: Color = Color(1, 1, 1, 1)
	var _final_pos: Vector2 = Vector2.ZERO
	var _duration: float = 0.5
	_body.modulate = Color(1, 1, 1, 0)
	_body.position = Vector2(0, 50)
	_anim_tween.tween_property(_body, "modulate", _final_color, 0.75).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	_anim_tween2.tween_property(_body, "position", _final_pos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

# Signal from button to exit.
func _on_exit_button_pressed():
	get_tree().quit()

# Signal from button to toggle themes.
func _on_theme_button_pressed():
	if _current_theme == 1:
		_theme_button.text = "LIGHT"
		_current_theme = 2
		_change_theme(_current_theme)
	else:
		_theme_button.text = "DARK"
		_current_theme = 1
		_change_theme(_current_theme)
