# Responsible for dragging of blocks.

extends Area2D
class_name DragHandler

# ---------------------------------------------------------------------------- #
var _lock: bool = false
var _offset: Vector2

# Manage dragging of blocks and whenever it will be snapped and attached.
func manage_dragging(pos: Vector2, node: CodeBlocks, is_dragging: bool) -> void:
	if is_dragging:
		if not _lock:
			_lock = true
			_offset = pos - node.get_global_position()
		
		node.set_global_position(lerp(node.get_global_position(), pos - _offset, misc_utils.lerp_weight))
	
	else:
		_lock = false
