extends Node2D

var grid_position
var velocity = Vector2(0, 0)
var color = Color(1, 1, 1, 1)
var isUpdated = false
var isStatic = false
const StaticCounter = 5
var StaticFrames = StaticCounter

func apply_color(color : Color):
	self.color = color
	$ColorRect.color = self.color
	
func resize(size : Vector2):
	$ColorRect.rect_size = size
	$ColorRect.set_anchors_and_margins_preset($ColorRect.PRESET_CENTER, $ColorRect.PRESET_MODE_KEEP_SIZE)
	
func GetMoveDisplacement(grid, x, y, grid_size):
	if not grid[y + 1][x]:
		return Vector2(0, 1)
	else:
		var target_cell_left = true if x - 1 < 0 else grid[y + 1][x - 1]
		var target_cell_right = true if x + 1 >= grid_size.x else grid[y + 1][x + 1]
		if not target_cell_left and not target_cell_right: return Vector2([-1,1][randi() % 2], 1)
		if not target_cell_left: return Vector2(-1, 1)
		if not target_cell_right: return Vector2(1, 1)
		
func Move(grid, x, y, displacement, cell_size):
	grid[y + displacement.y][x + displacement.x] = grid[y][x]
	grid[y][x] = null
	position += Vector2(cell_size, cell_size) * displacement

func _update(grid, pos, update_type, grid_size, cell_size):
	match update_type:
		ElementUpdateManager.UpdateTypes.MOVE:
			var y = pos.y
			var x = pos.x
			var displacement = GetMoveDisplacement(grid, x, y, grid_size)
			if displacement:
				CloseParticlesNotStatic(grid, x, y, grid_size)
				Move(grid, x, y, displacement, cell_size)
				
func _is_valid_pos(x, y, _grid_size):
	return x >= 0 and y >= 0 and x < _grid_size.x and y < _grid_size.y
				
func CloseParticlesNotStatic(grid, x, y, grid_size):
	for disp_y in range(-1, 2):
		for disp_x in range(-1, 2):
			if _is_valid_pos(x + disp_x, y + disp_y, grid_size):
				var particle = grid[y + disp_y][x + disp_x]
				if particle: ParticleNotStatic(particle)
				
func ParticleNotStatic(particle):
	particle.isStatic = false
	particle.StaticFrames = particle.StaticCounter

func GetUpdateType(grid, pos, grid_size):
	if not isStatic:
		var isLowerBound = pos.y == grid_size.y - 1
		if not isLowerBound:
			var y = pos.y
			var x = pos.x
			var target_cell_down = grid[y + 1][x]
			if not target_cell_down:
				StaticFrames = StaticCounter
				return ElementUpdateManager.UpdateTypes.MOVE
			var target_cell_left = true if x - 1 < 0 else grid[y + 1][x - 1]
			var target_cell_right = true if x + 1 >= grid_size.x else grid[y + 1][x + 1]
			if not target_cell_left or not target_cell_right:
				StaticFrames = StaticCounter
				return ElementUpdateManager.UpdateTypes.MOVE
		StaticFrames -= 1
		if StaticFrames <= 0: isStatic = true
