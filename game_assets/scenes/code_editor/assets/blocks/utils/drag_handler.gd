# Responsible for dragging of blocks.

extends Area2D
class_name DragHandler

# ---------------------------------------------------------------------------- #

# Manage dragging of blocks and whenever it will be snapped and attached.
func manage_dragging(pos: Vector2, node: CodeBlocks, is_dragging: bool) -> void:
	if is_dragging:
		node.set_position(lerp(node.global_position, pos - (node.get_node("shape").get_shape().get_size() / 2), misc_utils.lerp_weight / 2))
