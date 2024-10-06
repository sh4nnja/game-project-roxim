# Display block code.
# Normally it will contain the block;s code for compiling.

extends CodeBlocks

# ---------------------------------------------------------------------------- #

@onready var _scanner: AspectRatioContainer = get_node("interactable/margin/formatter/value/scanner")

# ---------------------------------------------------------------------------- #
# Initiation.
func _ready() -> void:
	# Update block metadata.
	set_metadata("block", self)
	set_metadata("slot", _scanner)
	set_metadata("type", "display")
	
	# Update block data.
	# Put the LineEdit node reference here.
	set_data([_scanner.get_line()])
	
	# Connect signals.
	connect("input_event", Callable(self, "on_mouse_event"))
	connect("mouse_exited", Callable(self, "on_mouse_exited"))
	
	get_node("interactable/margin/formatter/value/scanner").set_block(self)
	
	# Connect signals of other nodes.
	get_node("interactable").connect("resized", Callable(self, "manage_interact_area").bind(get_node("shape"), get_node("interactable")))
	get_node("interactable/margin/formatter/value/scanner/input").connect("focus_entered", Callable(self, "interactable_selected"))
	
	_scanner.get_line().connect("text_changed", Callable(self, "modify_block"))

# ---------------------------------------------------------------------------- #
