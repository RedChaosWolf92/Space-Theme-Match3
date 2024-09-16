# File: Scripts/GridManager.gd
extends Node2D

var grid = []
var grid_size = 5  # Initial grid size for Dust stage

# Defines the grid size per evolution stage
var grid_sizes = {
	"Dust": 5,
	"Small Nebula": 7,
	"Medium Nebula": 10,
	"Large Nebula": 15
}

func _ready():
	initialize_grid()

func initialize_grid():
	grid.clear()
	for i in range(grid_size):
		grid.append([])
		for j in range(grid_size):
			grid[i].append(null)

func add_resource_to_grid(resource_type: String) -> bool:
	for i in range(grid_size):
		for j in range(grid_size):
			if grid[i][j] == null:
				grid[i][j] = resource_type
				return true
	return false  # Grid is full

func handle_match():
	var matches = find_matches()
	if matches.size() >= 3:
		for match in matches:
			remove_resource(match)
		EvolutionManager.increase_player_points(resource_type, matches.size())
		refill_grid()

func find_matches() -> Array:
	var matches = []
	# Implement match-3 logic to find and return matched resources
	return matches

func remove_resource(match: Array):
	for resource in match:
		var position = resource.position
		grid[position.x][position.y] = null

func expand_grid(new_stage: String):
	var new_size = grid_sizes.get(new_stage, grid_size)
	if new_size > grid_size:
		grid_size = new_size
		var old_grid = grid.duplicate()
		grid.clear()

		for i in range(grid_size):
			grid.append([])
			for j in range(grid_size):
				if i < old_grid.size() and j < old_grid[i].size():
					grid[i].append(old_grid[i][j])
				else:
					grid[i].append(null)
		
		# Update the UI or notify the player that the grid has expanded
		UIManager.notify_grid_expansion(new_size)
