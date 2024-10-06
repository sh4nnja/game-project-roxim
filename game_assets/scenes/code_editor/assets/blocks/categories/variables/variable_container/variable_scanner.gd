# The scanner that will snap a variable container, if none, will use the input.

extends AspectRatioContainer

@onready var code_blocks: CodeBlocks = CodeBlocks.new()

# ---------------------------------------------------------------------------- #
# Initiation.
func _ready() -> void:
	# Import library to get the adjustment snippet.
	connect("resized", Callable(code_blocks, "manage_interact_area").bind(get_node("slot/shape"), get_node(".")))

# ---------------------------------------------------------------------------- #
# Accessor data.
func get_line() -> LineEdit:
	return get_node("input")
