# Variable code.
# Normally it will contain the block's data for the compiler.
# The code for change and set variable is the same.

# In technical terms it is alright. But I made the change variable for proper 
# naming and for much more better diversity.

extends CodeBlocks

@onready var _variable: LineEdit = get_node("interactable/margin/formatter/variable")
@onready var _variable_value: LineEdit = get_node("interactable/margin/formatter/value")

# Get the block's data.
# Getter function.
func get_data() -> Dictionary:
	var output: Dictionary = {
		_variable.get_text(): _variable_value.get_text()
	}
	
	return output
