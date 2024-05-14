# ******************************************************************************
# simulation_engine.gd
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

extends Node3D

# Base class of SIMULATION ENGINE.
# Simulation Engine Tree.
@onready var simulation_engine: Node = self

# Objects tree (Where you put the simulation objects)
@onready var simulation_interactor: Interactor 
@onready var simulation_objects: Node 

# Interactables.
var interactables_files: Dictionary = {
	"bracket1x": load("res://assets/objects/building/brackets/1x/bracket1x.tscn"),
	"bracket2x": load("res://assets/objects/building/brackets/2x/bracket2x.tscn"),
	"bracket3x": load("res://assets/objects/building/brackets/3x/bracket3x.tscn"),
	"bracket4x": load("res://assets/objects/building/brackets/4x/bracket4x.tscn"),
	"bracket5x": load("res://assets/objects/building/brackets/5x/bracket5x.tscn")
}

# ******************************************************************************
# CUSTOM METHODS AND SIGNALS

func add_interactable(_interactable: String) -> void:
	var _obj: Node3D = get_simulation_objects()
	
	# Checks if objects exist and the entry is correct.
	if interactables_files.has(_interactable):
		var _interactable_inst: Object = interactables_files.get(_interactable).instantiate()
		_obj.add_child(_interactable_inst)
		_interactable_inst.set_global_position(get_interactor().get_global_position())

func get_simulation_objects() -> Node3D:
	return get_node("objects")

func get_interactor() -> Interactor:
	return get_node_or_null("camera/interactor/spawner")
