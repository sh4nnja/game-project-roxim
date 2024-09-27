# Display block code.
# Normally it will contain the block;s code for compiling.

extends CodeBlocks
# ---------------------------------------------------------------------------- #

@onready var _variable: LineEdit = get_node("interactable")

# ---------------------------------------------------------------------------- #
# Initiation.
func _ready() -> void:
	# Connect signals.
	_variable.connect("mouse_entered", Callable(self, "on_mouse_entered").bind(_variable.get_parent()))
	_variable.connect("mouse_exited", Callable(self, "on_mouse_exited").bind(_variable.get_parent()))
	
	# Update block metadata.
	set_metadata("block", self)
	set_metadata("type", "display")
	
	# Update block data.
	set_data("variable_name", _variable)
