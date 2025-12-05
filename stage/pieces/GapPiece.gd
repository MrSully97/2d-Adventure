extends StagePiece
class_name GapPiece

@export var min_gap := 2
@export var max_gap := 5

func generate(tilemap: TileMap, x: int, y_ground: int) -> int:
	return randi_range(min_gap, max_gap)
