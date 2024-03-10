# ******************************************************************************
# coding_area_interface.gd
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

# Coding Manager location.
@onready var _coding_block_object: Node2D = get_node("/root/coding_area/coding_block_objects")

# Main menu scene file location.
const _MAIN_MENU_SCN_FILE: String = "res://assets/scenes/main_menu/main_menu.tscn"

# Coding Area backgrounds (For theme).
var _light_mode_bg: Resource = load("res://assets/textures/coding_area_textures/editor/background_white.png")
var _dark_mode_bg: Resource = load("res://assets/textures/coding_area_textures/editor/background_dark.png")
var _light_mode_logo: Resource = load("res://assets/dev/vblox_logo/logo_flat_white.png")
var _dark_mode_logo: Resource = load("res://assets/dev/vblox_logo/logo_flat_gray.png")

# Pause menu interface nodes.
@onready var _pause_menu: Control = get_node("pause_menu")
@onready var _pause_menu_background: ColorRect = get_node("pause_menu/background")
@onready var _pause_menu_btn: Button = get_node("pause_menu/menu_button")

# Blocks menu interface nodes.
#@onready var _blocks_menu: Control = get_node("blocks_menu")
@onready var _blocks_menu_background: Panel = get_node("blocks_menu/blocks_panel")
@onready var _blocks_span_btn: TextureButton = get_node("blocks_menu/blocks_panel/span_blocks_panel")
@onready var _blocks_separator: VBoxContainer = get_node("blocks_menu/blocks_panel/blocks_container/blocks_separator")

# Labels for block groups.
@onready var _label_events: Label = get_node("blocks_menu/blocks_panel/blocks_container/blocks_separator/events_separator")
@onready var _label_variables: Label = get_node("blocks_menu/blocks_panel/blocks_container/blocks_separator/variables_separator")

# Default Constants for UI.
const _POS_DURATION: float = 0.5

# Pause manager.
var _is_paused: bool = false

# Selected Block will queued for deletion.
var _can_delete_block: bool = false

# ******************************************************************************
# INITIATION
# Initiate logic.
func _ready() -> void:
	# Setting the theme and animating the panel for splash.
	_apply_theme()
	
	# Format the disabled buttons automatically.
	_disable_block_buttons(_blocks_separator)

# ******************************************************************************
# INPUT EVENTS
func _input(_event) -> void:
	if _event is InputEventKey:
		if _event.keycode == Configuration.interface_keys.values()[0] and _event.pressed:
			_animate_pause_menu()
			_manage_pause()
	elif _event is InputEventMouseButton:
		if _can_delete_block and CompilerEngine.get_interactor().get_interacted_block():
			if not _event.pressed:
				CompilerEngine.remove_coding_block(CompilerEngine.get_interactor().get_interacted_block(), _coding_block_object)

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# Change theme logic.
func _apply_theme() -> void:
	# Set theme on background interfaces.
	_pause_menu_background.color = Configuration.user_themes.values()[Configuration.current_theme][0]
	_pause_menu_background.color.a = 0
	
	var _blocks_menu_panel: StyleBoxFlat = _blocks_menu_background.get_theme_stylebox("panel")
	_blocks_menu_panel.bg_color = Configuration.user_themes.values()[Configuration.current_theme][0]
	_blocks_menu_panel.bg_color.a = 0.39
	_blocks_menu_background.add_theme_stylebox_override("panel", _blocks_menu_panel)
	
	# Set Coding Area Background
	set_coding_area_background(Configuration.current_theme)
	
	# Set Labels with the theme.
	_label_events.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][6])
	_label_variables.add_theme_color_override("font_color", Configuration.user_themes.values()[Configuration.current_theme][6])

# Manage pause of tree.
func _manage_pause(_paused: bool = _is_paused) -> void:
	get_tree().paused = _paused
	_is_paused = _paused

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
	
	# When interface is paused, tween the menu.
	if not _is_paused:
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
	_anim_bg_opacity.tween_property(_pause_menu_background, "color:a", _final_color,  _COLOR_DURATION).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	_anim_menu_opacity.tween_property(_pause_menu, "modulate:a", _final_color,  _COLOR_DURATION * 1.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	_anim_menu_pos.tween_property(_pause_menu, "position", _final_pos, _POS_DURATION).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

# Animate blocks menu
func _animate_blocks_menu(_span: bool) -> void:
	# Creating tween managers.
	var _anim_menu_pos: Tween = create_tween()
	
	# Create parameters for tween.
	var _final_pos: Vector2 = Vector2.ZERO
	
	# When span is enabled, tween the menu.
	if _span:
		_final_pos = Vector2.ZERO
	else:
		_final_pos = Vector2(-(_blocks_menu_background.get_size().x - _blocks_span_btn.get_size().x) , 0)
	
	# Play tween animations.
	_anim_menu_pos.tween_property(_blocks_menu_background, "position", _final_pos, _POS_DURATION).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

# Signal from button to go to menu.
func _on_menu_button_pressed() -> void:
	# Change the button to "Loading..." for user experience.
	_pause_menu_btn.disabled = true
	_pause_menu_btn.text = "Loading..."
	
	# Toggles pause of tree.
	_manage_pause(false)
	
	# Creates a timer for 3s so to make sure the player know that its "changing the scene".
	await get_tree().create_timer(Configuration.LOADING_TIME).timeout
	
	# Change the scene.
	get_tree().change_scene_to_file(_MAIN_MENU_SCN_FILE)

# Signal from button to span the menu.
func _on_span_blocks_panel_toggled(_button_pressed: bool) -> void:
	_animate_blocks_menu(not _button_pressed)

# ******************************************************************************
# Communicate to the Coding Compiler on what block to add.

# DISPLAY
func _on_display_visual_pressed():
	CompilerEngine.add_coding_block("DISPLAY_display_value", _coding_block_object)

# EVENTS
func _on_when_play_pressed_pressed():
	CompilerEngine.add_coding_block("EVENT_when_play_pressed", _coding_block_object)

# VARIABLES
func _on_set_variable_pressed():
	CompilerEngine.add_coding_block("VARIABLE_set_variable", _coding_block_object)

func _on_change_variable_pressed():
	CompilerEngine.add_coding_block("VARIABLE_change_variable", _coding_block_object)

# ******************************************************************************
# Remove current block.
func _on_blocks_panel_mouse_entered():
	_can_delete_block = CompilerEngine.queued_block_for_deletion(true)

func _on_blocks_panel_mouse_exited():
	if _is_mouse_outside_block_menu_bounds():
		_can_delete_block = CompilerEngine.queued_block_for_deletion(false)

# ******************************************************************************
# TOOLS
# Set background of coding area. Dirty way to do this.
func set_coding_area_background(_bg: int):
	if _bg == 1:
		get_node("/root/coding_area/background").set_texture(_dark_mode_bg)
		get_node("/root/coding_area/background/logo").set_texture(_dark_mode_logo)
	elif _bg == 2:
		get_node("/root/coding_area/background").set_texture(_light_mode_bg)
		get_node("/root/coding_area/background/logo").set_texture(_light_mode_logo)

# Some weird code because apparently from reddit that, if you entered a control node inside the panel,
# it will fire exit signal. So this is put in order to make sure it will leave the area as whole 
# to fire the signal.
func _is_mouse_outside_block_menu_bounds() -> bool:
	var _output: bool = false
	if not Rect2(Vector2(0, 0), _blocks_menu_background.size).has_point(get_local_mouse_position()):
		_output = true
	return _output

# ******************************************************************************
# Tools.
func _disable_block_buttons(_task_separator: VBoxContainer) -> void:
	var _idx: int = 0
	for _task in _task_separator.get_children():
		_idx += 1
		if _idx > 7:
			if _task is TextureButton:
				_task.disabled = true
				_task.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
			_task.modulate = Color.html("ffffff38")


