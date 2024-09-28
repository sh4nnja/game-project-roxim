# Display block code.
# Normally it will contain the block;s code for compiling.

extends CodeBlocks
# ---------------------------------------------------------------------------- #
# Initiation.
func _ready() -> void:
	# Update block metadata.
	set_metadata("block", self)
	set_metadata("type", "display")
	
	# Update block data.
	# Put the LineEdit node reference here.
	set_data("value", get_node("value"))
	
	# Connect signals.
	connect("mouse_entered", Callable(self, "on_mouse_entered"))
	connect("mouse_exited", Callable(self, "on_mouse_exited"))
