extends StagePiece
class_name FlatGroundPiece

@export var min_length := 5
@export var max_length := 12

func generate(tilemap: TileMap, x: int, y_ground: int) -> int:
	var length = randi_range(min_length, max_length)

	for i in range(length):
		tilemap.place_ground_column(x + i, y_ground)

	return length
