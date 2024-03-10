# ******************************************************************************
# coding_compiler.gd
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

extends Node2D

# Base class of COMPILER ENGINE.
# Compiler Engine Tree.

# Adding Blocks in the scene.
# Camera Interactor.
var cam_block_interactor: CodingInteractor

# Editor mode.
# Tasks 1-6 or Creative 0
enum {
	CREATIVE = 0,
	TASK_1 = 1,
	TASK_2 = 2,
	TASK_3 = 3,
	TASK_4 = 4,
	TASK_5 = 5,
	TASK_6 = 6
}

# Editor mode, for tutorials.
var editor_mode: int = CREATIVE

# On queue deleting.
var block_on_queue_deleting: bool = false

# Block Dictionary
var _block_objects_dict: Dictionary = {
	# VISUAL BLOCKS
	"DISPLAY_display_value": "res://assets/objects/blocks/visual/display_visual.tscn",
	
	# EVENT BLOCKS
	"EVENT_when_play_pressed": "res://assets/objects/blocks/events/when_play_pressed.tscn",
	
	# VARIABLE BLOCKS
	"VARIABLE_set_variable": "res://assets/objects/blocks/variables/set_variable.tscn",
	"VARIABLE_change_variable": "res://assets/objects/blocks/variables/change_variable.tscn"
}

# ******************************************************************************
# Check if compiler is online.
var block_manager_object: Node2D = null
var compiler_enabled: bool = false
var compiler_message: String = ""

# This is where the compiler will put every block.
# The play blocks will be the key. Meaning they can support multiple processes.
var compiler_data: Dictionary = {
#	"play_block" : {
#		"variables": {
#			name: value,
#			name: value
#		}
#		
#		
#	}
}

# ******************************************************************************
# Compiler Messages.
var compiler_messages: Dictionary = {
	"no_blocks": [
		"BEEEEEEEPPP! Currently, there are no blocks in the editor. Start by adding one?" + "\n",
		"BZZZT! Hold on there! The editor seems to be lacking ESSENTIAL building blocks!" + "\n",
		"BLEEP BOOP... Add one block to start creating code! or I will uhm, add one myself..." + "\n"
	],
	
	"no_blocks_under_play": [
		"BEEEEEEEPPP! Currently, there are no blocks under the play block. Start by adding one?" + "\n",
		"BZZZT! Hold on there! Can't really process play block without blocks below it!" + "\n",
		"BLEEP BOOP... Add one block under play block to start creating code! or I will uhm, add one myself..." + "\n"
	],
	
	"no_play_block": [
		"EEP! No Play Block in the editor. Start by adding one!" + "\n", 
		"OOOOOPS! Play Block = NONE. Add one to start!" + "\n",
		"BOOP! Can't really start with no play block... Add the block with a green play button with it." + "\n"
	],
	
	"processing": [
		"BEEPP BOOPP...Processing..." + "\n" + "\n" + "Output" + "\n", 
		"BLEEPP BLEEPP BOOPP...Creating Processes..." + "\n" + "\n" + "Output" + "\n", 
		"BOOP BLEEP BEEP?...Are you a robot? Am I a robot? Uhm...Processing?...." + "\n" + "\n" + "Output" + "\n", 
	],
	
	"error": [
		"BEEPP BOOPP...Error...Check how you named your variables." + "\n" + "\n", 
		"BLEEPP BLEEPP BOOPP...Error. Double check your code!" + "\n" + "\n",
		"BOOP BLEEP BEEP?...Shocks, can't run it." + "\n" + "\n"
	]
}

# ******************************************************************************
# CUSTOM SIGNALS AND FUNCTIONS.
# Activate compiler.
func enable_compiler(_enable: bool, _block_manager: Node2D) -> void:
	compiler_enabled = _enable
	block_manager_object = _block_manager
	
	# Initialize compiler.
	if _enable:
		# Get blocks. 
		_manage_blocks(_block_manager)

# Access interactor.
func get_interactor() -> CodingInteractor:
	return cam_block_interactor

# Add blocks on the platform.
func add_coding_block(_block_object_id: String, _object_manager: Node2D) -> void:
	var _obj: Resource = load(_block_objects_dict.get(_block_object_id))
	var _obj_inst: Node = _obj.instantiate()
	_object_manager.add_child(_obj_inst, true)
	_obj_inst.global_position = cam_block_interactor.position

# Queue blocks for deletion.
func queued_block_for_deletion(_queue_delete: bool) -> bool:
	var _output: bool = false
	if cam_block_interactor.check_interacting_blocks():
		if _queue_delete:
			# Change modulate for visuals.
			cam_block_interactor.get_interacted_block().modulate = Configuration.permission_colors.values()[Configuration.INVALID]
			_output = true
		else:
			cam_block_interactor.get_interacted_block().modulate = Configuration.permission_colors.values()[Configuration.DEFAULT]
	
	# Reminds compiler that block deleting is ongoing.
	block_on_queue_deleting = _output
	return _output

# Remove blocks.
func remove_coding_block(_block: CodingBlocks, _object_manager: Node2D) -> void:
	# Clears the array for safety.
	get_interactor().interacting_blocks.clear()
	_object_manager.remove_child(_block)
	_block.queue_free()

# ******************************************************************************
# Manage block data.
func _manage_blocks(_block_manager: Node2D) -> void:
	# Determine the 'play' blocks for creating processes.
	var _play_blocks_arr: Array = _get_play_blocks(_block_manager)
	
	# Sets the play blocks and the processes within.
	if _play_blocks_arr.size() > 0:
		# Iterate every play block in the editor.
		for _play_block in _play_blocks_arr:
			# Gets the play block data (blocks inside per play block).
			var _play_block_data: Array = _create_compiled_block_data(_play_block)
			
			# Insert play block's data inside the compiler for storage.
			# Creates a key using the play block.
			# This will be a thread.
			# All play blocks will be considered as threads.
			# It will have their own processes, variables and functions.
			compiler_data[_play_block_data[0]] = {}
			
			# Creates the template for blocks.
			_create_block_process(_play_block_data[0], compiler_data.get(_play_block_data[0]))
			
			# Iterates the play block data (blocks inside the play block)
			for _block in _play_block_data:
				# Checks the block if it is not the play block itself.
				if not _block == _play_block_data[0]:
					# Edits the template with the right block data.
					compiler_data.get(_play_block_data[0])["process"].append(_block)
			
			# Executes the processes per each play block.
			_execute_block_process(compiler_data.get(_play_block)["process"], _play_block)

# Checks if there are 'play' blocks active.
func _get_play_blocks(_block_manager: Node2D) -> Array:
	var _output: Array = []
	if _block_manager.get_children().size() > 0:
		for _block in _block_manager.get_children():
			if !_block.is_in_group("play"):
				compiler_messages.get("no_play_block").shuffle()
				compiler_message = compiler_messages.get("no_play_block")[0]
			else:
				_output.append(_block)
				compiler_messages.get("processing").shuffle()
				compiler_message = compiler_messages.get("processing")[0]
	else:
		compiler_messages.get("no_blocks").shuffle()
		compiler_message = compiler_messages.get("no_blocks")[0]
	
	return _output

# Creates a list of blocks that is under the play block to be processed.
func _create_compiled_block_data(_play_block: CodingBlocks) -> Array:
	var _output: Array = []
	
	# Queue to store nodes for processing
	var _queue: Array = [_play_block]  
	
	while _queue.size() > 0:
		# Gets the first block to be iterated.
		var _current_block = _queue.pop_front()
		
		# Checks if the block is in array.
		if _current_block.is_in_group("block"):
			_output.append(_current_block)
		
		# Checks if that blocks' children is in group block to be processed.
		for child in _current_block.get_children():
			if _current_block.is_in_group("block"):
				_queue.push_back(child)
	
	return _output

# Creates the template whenever a new process from a play block is created.
func _create_block_process(_block: CodingBlocks, _block_process: Dictionary) -> void:
	# Create the order of operations.
	# This is how will the play block will execute the operations by index.
	# set variable -> display variable -> change variable -> display variable.
	_block_process["process"] = []
	
	# This is where the variables of that play block will be stored.
	_block_process["variables"] = {}

# Executes the process order inside the 'process' key in the play blocks.
func _execute_block_process(_play_block_process_arr: Array, _play_block_key) -> void:
	if _play_block_process_arr.size() > 0:
		for _process in _play_block_process_arr:
			match _process.block_type:
				# DISPLAY
				# Queue display of a variable or a process.
				"display_visual":
					# Checks if the variable in the thread is the same as the one in the display text.
					# Sometimes the error is based on a space before or after the name.
					# Example " block" is not equal to "block".
					# Will not implement auto-remove of space before and after the word to introduce
					# attention to detail and proofreading code skills, as well as basic debugging.
					# Hashtag bug as feature lol.
					if compiler_data.get(_play_block_key)["variables"].has(_process.block_var_name.text):
						compiler_message += compiler_data.get(_play_block_key)["variables"][_process.block_var_name.text] + "\n"
					else:
						compiler_messages.get("error").shuffle()
						compiler_message = compiler_messages.get("error")[0]
						compiler_message += "\"" + _process.block_var_name.text + "\" is not declared! Recheck your display block!"
				
				# ******************************************************************
				# VARIABLES
				# Store and edit the values.
				# If the user mistyped the intended variable, it will just create another variable.
				# If user didn't intended that, it will enforce user to check.
				"set_variable":
					# Inserts a new variable data in the variable dict of the play block.
					# It gets the set_variable block's text to be stored as the name and value.
					compiler_data.get(_play_block_key)["variables"][_process.block_var_name.text] = _process.block_var_value.text
				
				"change_variable":
					# Edits the data based on the key, it is technically the same from the set variable but it makes it 
					# comprehensive to use.
					# It gets the set_variable block's text to be stored as the name and value.
					compiler_data.get(_play_block_key)["variables"][_process.block_var_name.text] = _process.block_var_value.text
			
				# ******************************************************************
	
	# If there's no process yet under the thread (play block).
	else:
		compiler_messages.get("no_blocks_under_play").shuffle()
		compiler_message = compiler_messages.get("no_blocks_under_play")[0]
