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
	set_metadata("is_snapping", false)
	set_metadata("slot", null)
	
	# Connect signals.
	connect("input_event", Callable(self, "on_mouse_event"))
	connect("mouse_exited", Callable(self, "on_mouse_exited"))
	connect("area_entered", Callable(self, "_snap_to_scanner"))
	connect("area_exited", Callable(self, "_remove_from_scanner"))
	
	# Connect signals of other nodes.
	get_node("interactable").connect("resized", Callable(self, "manage_interact_area").bind(get_node("shape"), get_node("interactable")))
	get_node("interactable").emit_signal("resized")

# ---------------------------------------------------------------------------- #
func _physics_process(_delta: float) -> void:
	_snapping()

# ---------------------------------------------------------------------------- #
# Container snapping to scanner.
# Note that this will only works on the coin-slot relationship of scanners and containers.
# For block snapping, see the snap_handler class.
func _snap_to_scanner(scanner: Area2D) -> void:
	set_metadata("slot", scanner.get_parent())
	if not scanner.get_parent().is_filled():
		set_metadata("is_snapping", true)

func _remove_from_scanner(scanner: Area2D) -> void:
	set_metadata("is_snapping", false)

# Snaps the container to the scanner.
func _snapping() -> void:
	if get_metadata().is_snapping and get_metadata().slot:
		var _slot: Scanner = get_metadata().slot
		if _slot != get_data()[1].get_parent() and get_metadata().is_dragged:
			var _dist_threshold: float = (get_node("shape").get_shape().get_size()).x / 3
			var _block_center: Vector2 = get_global_position() + (get_node("shape").get_shape().get_size() / 2)
			var _slot_center: Vector2 = _slot.get_global_position() + (_slot.get_size() / 2)
			var _dist_to_slot: float = _block_center.distance_to(_slot_center)
				
			if _dist_to_slot < _dist_threshold:
				_slot.get_line().set_placeholder(get_data()[0].get_text())
				
				# Lerp position to the slot.
				position.x = _slot.get_global_position().x - 30
				position.y = _slot.get_global_position().y
				
			else:
				_slot.get_line().set_placeholder("")
		else:
			_slot.get_line().set_placeholder("")
			set_metadata("slot", null)

# ---------------------------------------------------------------------------- #
# Get the lineEdit object.
func set_value(variable: Variant, value: Variant) -> void:
	get_node("interactable").set_text(variable.get_text())
	
	# Set the block data.
	set_data([variable, value])
