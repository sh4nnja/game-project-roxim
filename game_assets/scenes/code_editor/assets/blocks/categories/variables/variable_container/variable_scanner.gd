# The scanner that will snap a variable container, if none, will use the input.

extends AspectRatioContainer

func _ready() -> void:
	var _code_blocks: CodeBlocks = CodeBlocks.new()
	connect("resized", Callable(_code_blocks, "manage_interact_area").bind(get_node("scanner/shape"), get_node(".")))
