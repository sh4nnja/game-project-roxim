# ******************************************************************************
# change_variable.gd
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
var block_type: String = "change_variable"

# Connections.
@onready var block_head: Area2D = get_node("head")
@onready var block_tail: Area2D = get_node("tail")

var block_connected_head: CodingBlocks
var block_connected_tail: CodingBlocks

# Check what block we are attempting to connect to.
var attaching_connector: Area2D

# Enable dragging.
var dragging_enabled: bool = false

# Check if block can snap.
var can_snap: int = Configuration.DEFAULT

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

# For snapping and attaching.
func _on_head_area_entered(_area):
	manage_block_snapping(block_head, _area, true)

func _on_head_area_exited(_area):
	manage_block_snapping(block_head, _area, false)

func _on_tail_area_entered(_area):
	manage_block_snapping(block_tail, _area, true)

func _on_tail_area_exited(_area):
	manage_block_snapping(block_tail, _area, false)
