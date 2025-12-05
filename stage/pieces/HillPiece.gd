extends StagePiece
class_name HillPiece

@export var min_height := 1
@export var max_height := 4
@export var min_width := 4
@export var max_width := 8

func generate(tilemap: TileMap, x: int, y_ground: int) -> int:
	var height = randi_range(min_height, max_height)
	var width = randi_range(min_width, max_width)

	for i in range(width):
		var h = int((height * i) / width)
		tilemap.place_ground_column(x + i, y_ground - h, tilemap.floor_atlas)

	return width
