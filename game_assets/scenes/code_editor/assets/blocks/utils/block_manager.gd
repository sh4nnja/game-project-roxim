# Responsible for dragging, linking of code blocks.
# Also manages if the block is being moved or attempting to select the text.

extends Node2D
class_name CodeBlocks

# ---------------------------------------------------------------------------- #

# Unique properties template of the block. This will be filled by the
# individual blocks when inherited.

# Block data are the nodes being interacted and have the values needed for the
# virtual programming, commonly they store the LineEdit node references.
var _block_properties: Dictionary = {
	"data": [],
	"metadata": {
		"block": "",
		"type": "",
		"is_disabled": false,
		"is_hovered": false,
		"is_dragged": false
	}
}

# ---------------------------------------------------------------------------- #
# Update and show block properties.
# Metadata. Block's technical information for linking, dragging, other status.
# Use these functions even within the script.
func set_metadata(key: String, value: Variant) -> void:
	if _block_properties["metadata"].has(key):
		_block_properties["metadata"][key] = value

func get_metadata() -> Dictionary:
	return _block_properties["metadata"]

# Data. The block's actual data needed for virtual programming.
# When accessing the data's values make sure to include a snippet where it 
# gets the text inside. As the dictionary data content is an object.
func set_data(value: Array) -> void:
	_block_properties["data"] = value

func get_data() -> Array:
	return _block_properties["data"]

# ---------------------------------------------------------------------------- #
# Handles mouse in and out and interactions.
# Manages the block's capability to be interacted.
func manage_mouse_interaction(disabled: bool):
	set_metadata("is_disabled", disabled)
	
	# Manage the block's mouse hover / dragging status.
	get_metadata().block.set_pickable(!disabled)
	
	# Manage the block's interactables focus status.
	for _interactables in get_data():
		_interactables.set_focus_mode(Control.FOCUS_NONE if disabled else Control.FOCUS_ALL)
		_interactables.set_mouse_filter(Control.MOUSE_FILTER_IGNORE if disabled else Control.MOUSE_FILTER_STOP)

# Manage the block's interactable area.
func manage_interact_area(shape: CollisionShape2D, basis: Control) -> void:
	shape.get_shape().set_size(basis.get_size())
	shape.set_position(basis.get_size() / 2)

# Block Manager will mediate the interaction when hovering, dragging etc.
func on_mouse_entered() -> void:
	set_metadata("is_hovered", true)

func on_mouse_exited() -> void:
	set_metadata("is_hovered", false)

# ---------------------------------------------------------------------------- #
# Handles block states and mechanics calling.
# Call hover, drag, link classes.





# ---------------------------------------------------------------------------- #
