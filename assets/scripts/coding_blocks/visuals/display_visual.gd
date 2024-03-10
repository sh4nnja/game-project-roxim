# ******************************************************************************
# display_visual.gd
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

extends CodingBlocks

# Block Data.
var block_type: String = "display_visual"

@onready var block_var_name: LineEdit = get_node("display_visual_texture/display/name")

# Connections.
@onready var block_head: Area2D = get_node("head")
@onready var block_tail: Area2D = get_node("tail")

var block_connected_head: CodingBlocks
var block_connected_tail: CodingBlocks

# Check what block we are attempting to connect to.
var attaching_connector: Area2D

# Block shape. For dragging.
@onready var _block_texture: NinePatchRect = get_node("display_visual_texture")
@onready var _block_shape: CollisionShape2D = get_node("display_visual_shape")

# Enable dragging.
var dragging_enabled: bool = false

# Check if block can snap.
var can_snap: int = 0

# ******************************************************************************
# INPUT EVENT
func _input(_event) -> void:
	manage_dragging(_event)

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# When mouse is inside the coding block (For dragging).
func _on_mouse_entered():
	manage_hover(self, true)

func _on_mouse_exited():
	manage_hover(self, false)
	_remove_focus()

# For snapping and attaching.
func _on_head_area_entered(_area):
	manage_block_snapping(block_head, _area, true)

func _on_head_area_exited(_area):
	manage_block_snapping(block_head, _area, false)

func _on_tail_area_entered(_area):
	manage_block_snapping(block_tail, _area, true)

func _on_tail_area_exited(_area):
	manage_block_snapping(block_tail, _area, false)

# For changing the value and name.
func _on_name_text_changed(_new_text):
	_adjust_block()

# ******************************************************************************
# TOOLS
# Update dragging of the block.
func update_dragging(draggable: bool) -> void:
	dragging_enabled = draggable
	
	# Update text fields so that it will not be selected when dragging.
	block_var_name.editable = not dragging_enabled

# Removes focus on all text when mouse is outside the block.
func _remove_focus() -> void:
	block_var_name.release_focus()

# Adjust block's position and size based on text.
func _adjust_block() -> void:
	_block_texture.size.x = manage_block_tex_size(_block_texture.scale.x, block_var_name.size.x, 5)
	_block_shape.position.x = manage_block_shape_size(_block_texture.size.x)
	_block_shape.shape.size.x = manage_block_shape_size(_block_texture.size.x, 4)
