extends StagePiece
class_name GapPiece

func generate(tilemap: WorldTileMap, x: int, y: int, map_height: int) -> int:
	return randi_range(2, 4)
