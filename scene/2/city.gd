extends TileMap


#region var
var planet = null
var grids = {}
var buildings = []
var frontiers = []
var terrains = {}
var layer = {}
var source = null
var rings = {}
var radius = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	layer.floor = 0
	source = 0
	
	init_cells()
	init_buildings()
	init_workpieces()


func init_cells() -> void:
	var l = 16
	radius = 5
	var n = radius * 2 + 1
	planet.custom_minimum_size = Vector2.ONE * n * l
	position = -Vector2.ONE * l / 2 + planet.custom_minimum_size * 0.5
	
	for ring in radius + 1:
		rings[ring] = []
	
	for y in range(-radius, radius + 1):
		for x in range(-radius, radius + 1):
			var grid = Vector2i(x, y)
			var atlas_coord = Vector2i(0, 25)
			set_cell(layer.floor, grid, source, atlas_coord)
			
			var ring = min(abs(radius - x), abs(radius - y), abs(radius + x), abs(radius + y))
			ring = radius - ring
			rings[ring].append(grid)


func init_buildings() -> void:
	terrains.frontier = []
	
	var input = {}
	input.city = self
	input.grid = Vector2i()
	input.type = "base"
	var _building = Classes.Building.new(input)


func init_workpieces() -> void:
	var k = int((radius - 2) / 2) + 1
	var workpieces = []
	
	for _i in k:
		var _ring = _i * 2 + 2
		var _rings = [_ring, _ring + 1]
		var options = []
	
		for ring in _rings:
			for grid in rings[ring]:
				var flag = true
				
				for direction in Global.dict.direction.linear:
					if flag:
						var _grid = Vector2i(grid + direction)
						
						if grid_radius_check(_grid):
							var tile_data = get_cell_tile_data(layer.floor, _grid)
							
							if tile_data:
								if tile_data.get_custom_data("occupied") or tile_data.get_custom_data("frontier"):
									flag = false
									break
				
				if flag:
					options.append(grid)
		
		#var terrain_index = _i#Global.arr.terrains.find("aqua")
		var limit = int(options.size() / 4.0)
		
		while limit > 0 and !options.is_empty():
			limit -= 1
			
			var grid = options.pick_random()
			options.erase(grid)
			workpieces.append(grid)
			
			for direction in Global.dict.direction.linear:
				var _grid = Vector2i(grid + direction)
				
				if grid_radius_check(_grid):
					if options.has(_grid):
						options.erase(_grid)
		
		#set_cells_terrain_connect(layer.floor, workpieces, terrain_index, 0)
	
	for grid in workpieces:
		var element = Global.arr.element.pick_random()
		var x = Global.arr.element.find(element) + 1
		var atlas_coord = Vector2i(x, 25)
		set_cell(layer.floor, grid, source, atlas_coord)


func set_cell_as_frontier(grid_: Vector2i) -> void:
	terrains.frontier.append(grid_)
	var terrain_index = Global.arr.terrains.find("frontier")
	
	set_cells_terrain_connect(layer.floor, terrains.frontier, terrain_index, 0)


func grid_radius_check(grid_: Vector2i) -> bool:
	return abs(grid_.x) <= radius and abs(grid_.y) <= radius
#endregion
