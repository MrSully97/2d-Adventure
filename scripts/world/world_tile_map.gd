extends TileMap
class_name WorldTileMap

@export var map_width := 500
@export var map_height := 10

@export var background_layer := 0
@export var mid_layer := 1

@export var tileset_source_id := 0
@export var bg_atlas := Vector2i(2, 2)

func clear_all() -> void:
	clear()

func set_tile(layer: int, pos: Vector2i, atlas: Vector2i) -> void:
	set_cell(layer, pos, tileset_source_id, atlas, 0)

func place_ground_column(x: int, y_top: int, atlas: Vector2i) -> void:
	for y in range(y_top, map_height):
		set_tile(mid_layer, Vector2i(x, y), atlas)

	for y in range(y_top + 1, map_height):
		set_tile(mid_layer, Vector2i(x, y), get_random_bg_tile())

func get_random_bg_tile() -> Vector2i:
	return Vector2i(
		randi_range(6, 12),
		randi_range(6, 7)
	)

# ---- Background bounds tracking ----
var background_bounds := {
	"min": Vector2i.ZERO,
	"max": Vector2i.ZERO
}

func record_background(pos: Vector2i) -> void:
	background_bounds.min.x = min(background_bounds.min.x, pos.x)
	background_bounds.min.y = min(background_bounds.min.y, pos.y)
	background_bounds.max.x = max(background_bounds.max.x, pos.x)
	background_bounds.max.y = max(background_bounds.max.y, pos.y)
