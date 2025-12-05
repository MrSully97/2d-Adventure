extends StagePiece
class_name StairsPiece

@export var min_height := 3
@export var max_height := 6


func generate(tilemap: TileMap, x: int, y_ground: int) -> int:
	var height = randi_range(min_height, max_height)

	for h in range(height):
		tilemap.place_ground_column(x + h, y_ground - h, tilemap.stair_atlas)

	return height
