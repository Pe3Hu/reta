extends MarginContainer


#region var
@onready var city = $City

var universe = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	universe = input_.universe
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.planet = self
	city.set_attributes(input)
#endregion
