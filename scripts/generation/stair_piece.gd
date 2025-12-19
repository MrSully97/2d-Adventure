extends StagePiece
class_name StairsPiece

func generate(tilemap: WorldTileMap, x: int, y: int, map_height: int) -> int:
	var steps := randi_range(3, 5)

	for i in range(steps):
		tilemap.place_ground_column(
			x + i,
			y - i,
			Vector2i(5, 1)
		)

	return steps
