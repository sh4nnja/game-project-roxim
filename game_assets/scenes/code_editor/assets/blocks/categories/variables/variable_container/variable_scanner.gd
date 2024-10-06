# The scanner that will snap a variable container, if none, will use the input.

extends AspectRatioContainer
class_name Scanner

@onready var code_blocks: CodeBlocks = CodeBlocks.new()

@onready var _input: LineEdit = get_node("input")

var _value: Array = []

var _parent_block: CodeBlocks
var _filled: bool = false

# ---------------------------------------------------------------------------- #
# Initiation.
func _ready() -> void:
	# Import library to get the adjustment snippet.
	connect("resized", Callable(code_blocks, "manage_interact_area").bind(get_node("slot/shape"), get_node(".")))

# ---------------------------------------------------------------------------- #
# Scanner is being occupied. So override the values with the coin that is being inserted.
# Else, the default value will be the used from the input.
func occupy(mode: bool, value: Array = []) -> void:
	_filled = mode
	_input.set_editable(not mode)
	
	if mode:
		_value = value
		_parent_block.set_data(value)
	else:
		_value = []

# ---------------------------------------------------------------------------- #
# Accessor data.
func set_block(block: CodeBlocks) -> void:
	_parent_block = block

func get_block() -> CodeBlocks:
	return _parent_block

# ---------------------------------------------------------------------------- #
func get_line() -> LineEdit:
	var _output: LineEdit = null
	if is_filled():
		_output = _value[1]
	else:
		_output = get_node("input")
	return _output

func is_filled() -> bool:
	return _filled
