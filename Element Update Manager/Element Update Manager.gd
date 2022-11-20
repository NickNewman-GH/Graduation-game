extends Node
class_name ElementUpdateManager

enum UpdateTypes {REPLACE, SWAP, MOVE} 

var Updates = {
	UpdateTypes.REPLACE: [],
	UpdateTypes.SWAP: [],
	UpdateTypes.MOVE: []
}

func GetUpdates(grid, grid_size):
	for row_index in len(grid):
		for cell_index in len(grid[row_index]):
			var cell = grid[row_index][cell_index]
			if cell: 
				var position = Vector2(cell_index, row_index)
				var UpdateType = cell.GetUpdateType(grid, position, grid_size)
				if UpdateType: Updates[UpdateType].append(position)
	ShuffleUpdates()

func ShuffleUpdates():
	for UpdateType in Updates:
		Updates[UpdateType].shuffle()
		
func ClearUpdates():
	for UpdateType in Updates:
		Updates[UpdateType].clear()
		
func ApplyUpdates(grid, grid_size, cell_size):
	for UpdateType in Updates:
		for UpdateCellPosition in Updates[UpdateType]:
			var cell = grid[UpdateCellPosition.y][UpdateCellPosition.x]
			if not cell.isUpdated:
				cell._update(grid, UpdateCellPosition, UpdateType, grid_size, cell_size)
	ClearUpdates()
