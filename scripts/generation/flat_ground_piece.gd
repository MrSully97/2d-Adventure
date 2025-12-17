extends StagePiece
class_name FlatGroundPiece

func generate(
	tilemap: WorldTileMap,
	x: int,
	y: int,
	map_height: int
) -> int:
	var length := randi_range(4, 7)

	for i in range(length):
		tilemap.place_ground_column(
			x + i,
			y,
			Vector2i(1, 1)
		)

	return length
