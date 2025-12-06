extends TileMap

# ------------------------------------
# GENERATION SETTINGS
# ------------------------------------
@export var map_width: int = 500
@export var map_height: int = 10
@export var background_layer: int = 0
@export var mid_layer: int = 1

# Dungeon corridor generation settings
@export var steps: int = 80
@export var min_corridor_len: int = 2
@export var max_corridor_len: int = 8
@export var bg_min: Vector2i = Vector2i(6, 6)
@export var bg_max: Vector2i = Vector2i(12, 7)
# Tileset info (Godot 4 TileMap)
@export var tileset_source_id: int = 0                     # Source ID in your tileset
@export var floor_atlas: Vector2i = Vector2i(1, 1)         # Atlas coords for floor tile
@export var stair_atlas: Vector2i = Vector2i(5, 1)         # Atlas coords for floor tile

@export var bg_atlas: Vector2i = Vector2i(2, 2)            # Background tile
# Spawn settings
@export var player_path: NodePath
var tilemap: TileMap
# Internal
var platform_list: Array[Dictionary] = []
var pieces: Array[StagePiece] = [
	FlatGroundPiece.new(),
	HillPiece.new(),
	GapPiece.new(),
	FloatingPlatformPiece.new(),
	StairsPiece.new()
]

func _ready():
	return
	randomize()
	generate_stage()
	spawn_player()


# ------------------------------------
# PLACE TILES
# ------------------------------------
func place_ground_column(x: int, y_top: int, atlas: Vector2i):
	print(get_layer_name(1))
	# Place ground normally
	for y in range(y_top, map_height):
		set_cell(mid_layer, Vector2i(x, y), tileset_source_id, atlas, 0)

	# Fill BELOW the ground with random tiles
	for y in range(y_top + 1, map_height):
		set_cell(mid_layer, Vector2i(x, y), tileset_source_id, get_random_bg_tile(), 0)
		
		
func get_random_bg_tile() -> Vector2i:
	var x = randi_range(bg_min.x, bg_max.x)
	var y = randi_range(bg_min.y, bg_max.y)
	return Vector2i(x, y)


# ------------------------------------
# MAIN DUNGEON GENERATION
# ------------------------------------
func generate_stage():
	platform_list.clear()
	clear()

	# Ensure background covers the visible viewport (plus buffer)
	# Ensure background covers the visible viewport (plus buffer)
	var viewport := get_viewport_rect()
	var tile_size := tile_set.tile_size  # TileMap tile size
	var visible_tiles_x = int(ceil(viewport.size.x / tile_size.x)) + 2
	var visible_tiles_y = int(ceil(viewport.size.y / tile_size.y)) + 2
	print(visible_tiles_x)
	print(visible_tiles_y)
	# Draw background for entire visible area
	# Draw background first
	for w in range(map_width + visible_tiles_x):
		for h in range(map_height + visible_tiles_y):
			set_cell(background_layer, Vector2i(w, h), tileset_source_id, bg_atlas, 0)
			set_cell(background_layer, Vector2i(-w, -h), tileset_source_id, bg_atlas, 0)
			set_cell(background_layer, Vector2i(w, -h), tileset_source_id, bg_atlas, 0)
			set_cell(background_layer, Vector2i(-w, h), tileset_source_id, bg_atlas, 0)

	var y_ground := map_height - 5         # Where floor baseline is
	var x := 0
	
	
	var first_platform_x = -1  # reset at start
	
	#while x < map_width:
		#var section_type = randi() % 5
#
		## Example for flat ground section
		#match section_type:
			#0:
				#var length = randi_range(5, 12)
				#for i in range(length):
					#place_ground_column(x + i, y_ground)
					#if first_platform_x == -1:
						#first_platform_x = x + i  # record first ground
				#x += length
#
			#1:  # Small hill up/down
				#var height = randi_range(1, 4)
				#var width = randi_range(4, 8)
				#for i in range(width):
					#var h = int((height * i) / width)
					#place_ground_column(x + i, y_ground - h)
				#x += width
#
			#2:  # Gap
				#var gap_size = randi_range(2, 5)
				#x += gap_size  # skip tiles
#
			#3:  # Floating platform
				#var platform_len = randi_range(2, 6)
				#var platform_y = y_ground - randi_range(3, 6)
#
				## Spawn platform tiles
				#for i in range(platform_len):
					#set_cell(0, Vector2i(x + i, platform_y), tileset_source_id, floor_atlas, 0)
#
				## 30% chance a ladder is created from this platform down to ground
				#if randi() % 3 == 0:
					#var ladder_x = x + randi_range(0, platform_len - 1)
					#for ly in range(platform_y + 1, y_ground):
						#set_cell(0, Vector2i(ladder_x, ly), tileset_source_id, get_random_ladder_tile(), 0)
#
				#x += platform_len
#
			#4:  # Stairs
				#var height = randi_range(3, 6)
				#for h in range(height):
					#place_ground_column(x + h, y_ground - h)
				#x += height
	
	while x < map_width:
		var piece: StagePiece = pieces.pick_random()
		var consumed = piece.generate(self, x, y_ground)
		x += consumed
	
	print("Mario-style world generated!")

# ------------------------------------
# PLAYER SPAWNING
# ------------------------------------
func get_random_platform() -> Dictionary:
	if platform_list.is_empty():
		push_warning("No platforms to spawn player.")
		return {}

	return platform_list[0]   # always spawn on first corridor


func get_spawn_tile(platform: Dictionary) -> Vector2i:
	return Vector2i(0, map_height - 6)   # Spawn at **very left side** of map

func spawn_player():
	if not player_path:
		push_warning("Player path not set.")
		return

	var player = get_node(player_path)
	if player == null:
		push_warning("Player node not found.")
		return

	var platform = get_random_platform()
	if platform.is_empty():
		return

	var spawn_tile = get_spawn_tile(platform)
	var world_pos = map_to_local(spawn_tile)
	player.global_position = world_pos

	print("Player spawned at ", world_pos)
