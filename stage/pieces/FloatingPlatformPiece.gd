extends StagePiece
class_name FloatingPlatformPiece

@export var min_len := 2
@export var max_len := 6
@export var min_height := 3
@export var max_height := 6

func generate(tilemap: TileMap, x: int, y_ground: int) -> int:
	var len = randi_range(min_len, max_len)
	var y = y_ground - randi_range(min_height, max_height)

	for i in range(len):
		tilemap.set_cell(0, Vector2i(x + i, y), tilemap.tileset_source_id, tilemap.floor_atlas, 0)

	# Ladders?
	if randi() % 3 == 0:
		var ladder_x = x + randi_range(0, len - 1)
		for ly in range(y + 1, y_ground):
			tilemap.set_cell(0, Vector2i(ladder_x, ly), tilemap.tileset_source_id, tilemap.get_random_ladder_tile(), 0)

	return len
