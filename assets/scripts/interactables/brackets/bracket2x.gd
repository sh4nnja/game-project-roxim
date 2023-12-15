# ******************************************************************************
#  bracket2x.gd
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

extends Brackets

# Bracket size. Since this bracket is 2x, the bracket size is 2.
var _slot_size: int = 2

# ******************************************************************************
# INITIATION
func _ready() -> void:
	# Initiate bracket size.
	initiate_bracket_size(slots, _slot_size)

# ******************************************************************************
# PHYSICS
func _physics_process(_delta):
	manage_mechanics(self, is_selected)
	
	# Simulation Engine debug report.
	manage_debug()

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS
# Changes respective slots on the 'slots' when in contact of another slot from a bracket.
func _on_attach_1_entered(_area: Area3D):
	slots[0] = true

func _on_attach_1_exited(_area: Area3D):
	slots[0] = false

func _on_attach_2_entered(_area: Area3D):
	slots[1] = true

func _on_attach_2_exited(_area: Area3D):
	slots[1] = false

