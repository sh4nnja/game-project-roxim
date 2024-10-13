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
	_input.set_placeholder(value[0].get_text() if value else "")
	_input.set_focus_mode(Control.FOCUS_NONE if mode else Control.FOCUS_ALL)
	_input.set_mouse_filter(Control.MOUSE_FILTER_IGNORE if mode else Control.MOUSE_FILTER_STOP)
	
	if mode:
		_value = value
		_parent_block.set_data([_parent_block.get_data()[0], _value[1]])
		
		# Block specifics.
		match _parent_block.get_metadata().type:
			"set_variable":
				_parent_block.modify_block("")
	
	else:
		_parent_block.set_data([get_node("input")])

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
