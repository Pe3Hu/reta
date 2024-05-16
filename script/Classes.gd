extends Node


class Building:
	var city = null
	var grid = null
	var type = null
	
	func _init(input_: Dictionary) -> void:
		city = input_.city
		grid = Vector2i(input_.grid)
		type = input_.type
	
		init_basic_setting()


	func init_basic_setting() -> void:
		city.buildings.append(self)
		update_cell()
		update_frontiers()


	func update_cell() -> void:
		var atlas_coord = Vector2i(5, 25)
		city.set_cell(city.layer.floor, grid, city.source, atlas_coord)


	func update_frontiers() -> void:
		for direction in Global.dict.direction.linear:
			var _grid = Vector2i(grid + direction)
			
			#check boundary
			if true:
				var tile_data = city.get_cell_tile_data(city.layer.floor, _grid)
				
				if tile_data:
					if tile_data.get_custom_data("fog"):
						city.set_cell_as_frontier(_grid)
