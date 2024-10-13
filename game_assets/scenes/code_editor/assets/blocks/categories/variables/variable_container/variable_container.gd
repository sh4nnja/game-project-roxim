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
	set_metadata("slot_detected", false)
	set_metadata("is_snapped", false)
	set_metadata("is_attached", false)
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
	_block_attachment()

# ---------------------------------------------------------------------------- #
# Container snapping to scanner.
# Note that this will only works on the coin-slot relationship of scanners and containers.
# For block snapping, see the snap_handler class.
func _snap_to_scanner(scanner: Area2D) -> void:
	set_metadata("slot", scanner.get_parent())
	if not scanner.get_parent().is_filled():
		set_metadata("slot_detected", true)

func _remove_from_scanner(_scanner: Area2D) -> void:
	set_metadata("slot", null)
	set_metadata("slot_detected", false)

# Snaps the container to the scanner.
func _block_attachment() -> void:
	_block_attaching()
	_block_snapping()

func _block_snapping() -> void:
	# Block snapping.
	if get_metadata().is_dragged:
		if get_metadata().slot_detected and get_metadata().slot:
			var _slot: Scanner = get_metadata().slot
			var _slot_margin: int = 30
			if _slot != get_data()[1].get_parent():
				# Get the distances needed for block snapping.
				# Have the computation needed for the blocks' distance.
				var _dist_threshold: float = (get_node("shape").get_shape().get_size()).x / 3
				var _block_center: Vector2 = get_global_position() + (get_node("shape").get_shape().get_size() / 2)
				var _slot_center: Vector2 = _slot.get_global_position() + (_slot.get_size() / 2)
				var _dist_to_slot: float = _block_center.distance_to(_slot_center)
				
				# Define the block's threshold for snapping and attaching.
				if _dist_to_slot < _dist_threshold:
					_slot.get_line().set_placeholder(get_data()[0].get_text())
					
					# Lerp position to the slot.
					position.x = _slot.get_global_position().x - _slot_margin
					position.y = _slot.get_global_position().y
					
					# Set snapping attribute.
					set_metadata("is_snapped", true)
				
				else:
					_slot.get_line().set_placeholder("")
					
					# Set snapping attribute.
					set_metadata("is_snapped", false)
			
			else:
				_slot.get_line().set_placeholder("")
				set_metadata("slot", null)

func _block_attaching() -> void:
	# Block attachment.
	if get_metadata().is_snapped:
		# When user drags and releases the block, it determines when the block
		# must be attached, or else.
		if get_metadata().slot_detected and get_metadata().slot:
			var _slot: Scanner = get_metadata().slot
			
			# Attached logic.
			if not get_metadata().is_dragged:
				position.x = _slot.get_global_position().x - 30
				position.y = _slot.get_global_position().y
				
				_slot.occupy(true, get_data())
				
				set_metadata("is_attached", true)
			
			else:
				# Removed logic.
				_slot.occupy(false)
				set_metadata("is_attached", false)
	
	else:
		set_metadata("is_attached", false)

# ---------------------------------------------------------------------------- #
# Get the lineEdit object.
func set_value(variable: Variant, value: Variant) -> void:
	get_node("interactable").set_text(variable.get_text())
	
	# Set the block data.
	set_data([variable, value])
