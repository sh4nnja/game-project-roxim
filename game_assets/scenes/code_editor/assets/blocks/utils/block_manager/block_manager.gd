# Responsible for dragging, linking of code blocks.
# Also manages if the block is being moved or attempting to select the text.

extends Node2D
class_name CodeBlocks
# ---------------------------------------------------------------------------- #

# Unique properties template of the block. This will be filled by the
# individual blocks when inherited.
var _block_properties: Dictionary = {
	"data": {
		
	},
	
	"metadata": {
		"block": "",
		"type": "",
		"is_hovered": false,
		"is_dragged": false
	}
}

# ---------------------------------------------------------------------------- #
# Update and show block properties.
# Metadata. Block's technical information for linking, dragging, other status.
func set_metadata(key: String, value: Variant) -> void:
	if _block_properties["metadata"].has(key):
		_block_properties["metadata"][key] = value

func get_metadata() -> Dictionary:
	return _block_properties["metadata"]

# Data. The block's actual data needed for virtual programming.
func set_data(key: Variant, value: Variant) -> void:
	_block_properties["data"][key] = value

func get_data() -> Dictionary:
	return _block_properties["data"]

# ---------------------------------------------------------------------------- #
# Handles mouse in and out.
# Block Manager will mediate the interaction when hovering, dragging etc.
func on_mouse_entered(block: CodeBlocks) -> void:
	block.set_metadata("is_hovered", true)

func on_mouse_exited(block: CodeBlocks) -> void:
	block.set_metadata("is_hovered", false)
