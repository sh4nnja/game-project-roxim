# Set variable code.
# Normally it will contain the block's data for the compiler.

extends CodeBlocks

# ---------------------------------------------------------------------------- #

@onready var _line: LineEdit = get_node("interactable/margin/formatter/variable/input")
@onready var _scanner: LineEdit = get_node("interactable/margin/formatter/value/scanner").get_line()

var _container: Resource = load("res://game_assets/scenes/code_editor/assets/blocks/categories/variables/variable_container/variable_container.tscn")

var _reference: Node
var _spawned_once: bool = true

# ---------------------------------------------------------------------------- #
# Initiation.
func _ready() -> void:
	# Update block metadata.
	set_metadata("block", self)
	set_metadata("type", "set_variable")
	
	# Update block data.
	set_data([_line, _scanner])
	
	# Connect signals.
	connect("input_event", Callable(self, "on_mouse_event"))
	connect("mouse_exited", Callable(self, "on_mouse_exited"))
	
	# Connect signals of other nodes.
	get_node("interactable").connect("resized", Callable(self, "manage_interact_area").bind(get_node("shape"), get_node("interactable")))
	get_node("interactable/margin/formatter/variable/input").connect("focus_entered", Callable(self, "interactable_selected"))
	get_node("interactable/margin/formatter/value/scanner/input").connect("focus_entered", Callable(self, "interactable_selected"))
	
	_line.connect("text_changed", Callable(self, "modify_block"))
	_scanner.connect("text_changed", Callable(self, "modify_block"))

# ---------------------------------------------------------------------------- #
# Add and modify the block.
# Will the block only once then will edit that block based on the set variable.
func modify_block(_text: String) -> void:
	var _empty_input: bool = _scanner.get_text() == "" or _line.get_text() == ""
	# Removes text when the variable name is " ".
	if _empty_input:
		if _reference:
			_reference.queue_free()
			_reference = null
			_spawned_once = true
	else:
		if _reference:
			_reference.set_value(_line, _scanner)
		else:
			# Adds the block in the canvas when the previous value is "" or newly created variable.
			# Remove this code after adding the panel for blocks.
			var _contInst: Node = _container.instantiate()
			_contInst.set_value(_line, _scanner)
			
			# Sets the reference and turning off the spawning of the block.
			_reference = _contInst
			_spawned_once = false
			
			get_parent().add_child(_contInst, true)
