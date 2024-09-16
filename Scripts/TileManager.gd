# File: Scripts/TileManager.gd
extends Node2D

enum TileType {
	DUST,
	GAS,
	NUTRIENTS,
	ENERGY,
	EMPTY
}

func create_tile(grid_position: Vector2, tile_size: int, object_ratio: float) -> Node2D:
	var tile = preload("res://Scenes/Tile.tscn").instantiate()
	tile.position = grid_position * tile_size
	
	if randi() % 10 < object_ratio * 10:
		tile.set_type(TileType(randi() % 4))  # Random object type
	else:
		tile.set_type(TileType.EMPTY)  # Empty tile
	
	return tile
