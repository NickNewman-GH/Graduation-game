extends Node
class_name Grid

var _level
var _grid = []
var _grid_size
var _cell_size

var elementUpdateManager = ElementUpdateManager.new()

func _init(level, grid_size):
	_level = level
	_grid_size = grid_size
	_create_grid()
	_calculate_cell_size()
		
func _create_grid():
	_grid = []
	_grid.resize(_grid_size.y)
	for y in len(_grid):
		var row = []
		row.resize(_grid_size.x)
		for x in len(row):
			row[x] = null
		_grid[y] = row

func _is_valid_pos(x, y):
	return x >= 0 and y >= 0 and x < _grid_size.x and y < _grid_size.y
	
func _vieport_to_grid(pos, _cell_size):
	return (pos / _cell_size).round()
	
func _calculate_cell_size():
	_cell_size = 1
	
func get_cell(pos):
	return _grid[pos.y][pos.x]
	
func create_particle(grid_position):
	for y in range(-1, 2):
		for x in range(-1, 2):
			var pos = grid_position + Vector2(x, y)
			if _is_valid_pos(pos.x, pos.y) and get_cell(pos) == null:
				#print(grid_position)
				var particle = ParticleFactory.create(
					Vector2(_cell_size, _cell_size),
					Color(1,1,0,1))
				_grid[pos.y][pos.x] = particle
				particle.position = Vector2(pos.x * _cell_size, pos.y * _cell_size)
				_level.add_child(particle)
	
func action_processing(mouse_position, action_type = null):
	var grid_position = _vieport_to_grid(mouse_position, _cell_size)
	create_particle(grid_position)

func update():
	elementUpdateManager.GetUpdates(_grid, _grid_size)
	elementUpdateManager.ApplyUpdates(_grid, _grid_size, _cell_size)
