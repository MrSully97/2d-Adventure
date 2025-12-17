extends Node
class_name MapGenerator

@export var map_width := 500
@export var map_height := 10

var pieces: Array[StagePiece] = [
	FlatGroundPiece.new(),
	HillPiece.new(),
	GapPiece.new(),
	FloatingPlatformPiece.new(),
	StairsPiece.new()
]

func generate(tilemap: WorldTileMap) -> void:
	tilemap.map_width = map_width
	tilemap.map_height = map_height

	tilemap.clear_all()
	_generate_background(tilemap)
	_generate_platforms(tilemap)

func _generate_background(tilemap: WorldTileMap) -> void:
	var viewport := tilemap.get_viewport_rect()
	var tile_size := tilemap.tile_set.tile_size

	var vis_x := int(ceil(viewport.size.x / tile_size.x)) + 2
	var vis_y := int(ceil(viewport.size.y / tile_size.y)) + 2

	for x in range(map_width + vis_x):
		for y in range(map_height + vis_y):
			for p in [
				Vector2i( x,  y),
				Vector2i(-x,  y),
				Vector2i( x, -y),
				Vector2i(-x, -y)
			]:
				tilemap.set_tile(
					tilemap.background_layer,
					p,
					tilemap.bg_atlas
				)
				tilemap.record_background(p)

func _generate_platforms(tilemap: WorldTileMap) -> void:
	var y_ground := map_height - 5
	var x := 0

	while x < map_width:
		var piece = pieces.pick_random()
		x += piece.generate(tilemap, x, y_ground, map_height)
