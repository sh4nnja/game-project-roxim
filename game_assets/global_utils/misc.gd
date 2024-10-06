# Cannot be organized global miscellaneous values.

extends Node
# ---------------------------------------------------------------------------- #
const lerp_weight: float = 0.5
const float_step: float = 0.001

# ---------------------------------------------------------------------------- #\

func reparent_node(node: Node, new_parent: Node) -> void:
	var old_parent = node.get_parent()
	old_parent.call_deferred("remove_child", node)
	new_parent.call_deferred("add_child", node)
