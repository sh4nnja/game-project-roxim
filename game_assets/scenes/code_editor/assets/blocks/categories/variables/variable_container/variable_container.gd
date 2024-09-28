# Variable code.
# Normally it will contain the block's data for the compiler.
# The code for change and set variable is the same.

# In technical terms it is alright. But I made the change variable for proper 
# naming and for much more better diversity.

extends CodeBlocks

# ---------------------------------------------------------------------------- #
# Initiation.
func _ready() -> void:
	# Update block metadata.
	set_metadata("block", self)
	set_metadata("type", "variable_container")
	
	# Connect signals.
	connect("mouse_entered", Callable(self, "on_mouse_entered"))
	connect("mouse_exited", Callable(self, "on_mouse_exited"))
	
	# Connect signals of other nodes.
	get_node("interactable").connect("resized", Callable(self, "manage_interact_area").bind(get_node("shape"), get_node("interactable")))
