extends StagePiece
class_name FloatingPlatformPiece

func generate(tilemap: WorldTileMap, x: int, y: int, map_height: int) -> int:
	var width := randi_range(2, 4)
	var height := randi_range(3, 5)

	for i in range(width):
		tilemap.set_tile(
			tilemap.mid_layer,
			Vector2i(x + i, y - height),
			Vector2i(1, 1)
		)

	return width
