extends StagePiece
class_name HillPiece

func generate(tilemap: WorldTileMap, x: int, y: int, map_height: int) -> int:
	var height := randi_range(1, 3)

	for i in range(4):
		tilemap.place_ground_column(
			x + i,
			y - height,
			Vector2i(1, 1)
		)

	return 4
