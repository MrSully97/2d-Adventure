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
@export var tileset_source_id: int = 0 # Source ID in your tileset
@export var floor_atlas: Vector2i = Vector2i(1, 1) # Atlas coords for floor tile
@export var stair_atlas: Vector2i = Vector2i(5, 1) # Atlas coords for floor tile
@export var bg_atlas: Vector2i = Vector2i(2, 2) # Background tile
# Spawn settings
@export var player_path: NodePath
@export var spawn_point: Vector2i = Vector2i(-1, -1)
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
@export var use_json_map := true
@export var json_map_path := "res://maps/map_1.json"

func _ready():
	if use_json_map:
		load_map_from_json(json_map_path)
		spawn_player()
	else:
		generate_stage()
		spawn_player()

# Respawns player at start if they fall
func _physics_process(delta: float) -> void:
	if not use_json_map:
		if get_node(player_path).global_position.y > 500:
			get_node(player_path).velocity = Vector2(0, 0)
			get_node(player_path).global_position = Vector2(-1, -100)

# ------------------------------------
# PLACE TILES
# ------------------------------------
func place_ground_column(x: int, y_top: int, atlas: Vector2i):
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

# Helper to set a tile safely (top-level function so it's callable at runtime)
func _set_tile_at(idx: int, px: int, py: int, tx: int, ty: int) -> void:
	if tx == -1:
		return
	# ensure coordinates inside map bounds
	if px < 0 or py < 0 or px >= map_width or py >= map_height:
		return
	var atlas_coord = Vector2i(int(tx), int(ty))
	set_cell(int(idx), Vector2i(int(px), int(py)), tileset_source_id, atlas_coord, 0)

func load_map_from_json(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open map JSON: " + path)
		return
	var raw_json: String = file.get_as_text()
	var map_data: Dictionary = JSON.parse_string(raw_json)
	if map_data == null:
		push_error("Failed to parse JSON map.")
		return
	clear() # wipe current map
	# Basic map info
	map_width = map_data.width
	map_height = map_data.height
	# Handle spawn point if present
	if map_data.has("spawn_point") and map_data.spawn_point != null:
		spawn_point = Vector2i(map_data.spawn_point.x, map_data.spawn_point.y)
	# Adjust TileMap layers to match JSON layers count
	var json_layers = map_data.layers
	var current_layers = get_layers_count()
	while current_layers < json_layers.size():
		add_layer(current_layers)
		current_layers += 1
	# Load tiles (support multiple export formats):
	# - Legacy 2D rows: tiles = [[{tx,ty}, ...], ...]
	# - Rect compression: tiles = { type: 'rect', p1:{x,y}, p2:{x,y}, tile:{tx,ty} }
	# - Placed tiles list: tiles = [{x,y,tx,ty}, ...]
	for layer_index in range(json_layers.size()):
		var layer_data = json_layers[layer_index]
		if layer_data == null:
			continue
		var tiles_info = layer_data.tiles
		if tiles_info == null:
			continue

		# Helper to set a tile safely (local function assigned to a variable)
		var _set_tile_at = func(idx, px, py, tx, ty):
			if tx == -1:
				return
			# ensure coordinates inside map bounds
			if px < 0 or py < 0 or px >= map_width or py >= map_height:
				return
			var atlas_coord = Vector2i(int(tx), int(ty))
			set_cell(int(idx), Vector2i(int(px), int(py)), tileset_source_id, atlas_coord, 0)

		# Case: legacy 2D array (rows of cells)
		if tiles_info is Array and tiles_info.size() == map_height and tiles_info.size() > 0 and tiles_info[0] is Array:
			for y in range(tiles_info.size()):
				var row = tiles_info[y]
				for x in range(row.size()):
					var cell = row[x]
					if cell == null:
						continue
					var tx = int(cell.tx)
					var ty = int(cell.ty)
					_set_tile_at(layer_index, x, y, tx, ty)
			continue

		# Case: rect compressed format
		if tiles_info is Dictionary and tiles_info.has("type") and String(tiles_info.type) == "rect":
			var p1 = tiles_info.p1 if tiles_info.has("p1") else {"x":0, "y":0}
			var p2 = tiles_info.p2 if tiles_info.has("p2") else {"x":0, "y":0}
			var tile = tiles_info.tile if tiles_info.has("tile") else {"tx":-1, "ty":-1}
			var sx = int(min(p1.x, p2.x))
			var sy = int(min(p1.y, p2.y))
			var ex = int(max(p1.x, p2.x))
			var ey = int(max(p1.y, p2.y))
			sx = clamp(sx, 0, map_width - 1)
			sy = clamp(sy, 0, map_height - 1)
			ex = clamp(ex, 0, map_width - 1)
			ey = clamp(ey, 0, map_height - 1)
			for y in range(sy, ey + 1):
				for x in range(sx, ex + 1):
					_set_tile_at(layer_index, x, y, int(tile.tx), int(tile.ty))
			continue

		# Case: array of placed tiles [{x,y,tx,ty}, ...]
		if tiles_info is Array:
			for p in tiles_info:
				if p == null:
					continue
				var px = int(p.x)
				var py = int(p.y)
				var tx = int(p.tx)
				var ty = int(p.ty)
				_set_tile_at(layer_index, px, py, tx, ty)
			continue

		# Unknown format: skip

# ------------------------------------
# MAIN DUNGEON GENERATION
# ------------------------------------
func generate_stage():
	platform_list.clear()
	clear()
	# Ensure background covers the visible viewport (plus buffer)
	# Ensure background covers the visible viewport (plus buffer)
	var viewport := get_viewport_rect()
	var tile_size := tile_set.tile_size # TileMap tile size
	var visible_tiles_x = int(ceil(viewport.size.x / tile_size.x)) + 2
	var visible_tiles_y = int(ceil(viewport.size.y / tile_size.y)) + 2
	# Draw background for entire visible area
	# Draw background first
	for w in range(map_width + visible_tiles_x):
		for h in range(map_height + visible_tiles_y):
			set_cell(background_layer, Vector2i(w, h), tileset_source_id, bg_atlas, 0)
			set_cell(background_layer, Vector2i(-w, -h), tileset_source_id, bg_atlas, 0)
			set_cell(background_layer, Vector2i(w, -h), tileset_source_id, bg_atlas, 0)
			set_cell(background_layer, Vector2i(-w, h), tileset_source_id, bg_atlas, 0)
	var y_ground := map_height - 5 # Where floor baseline is
	var x := 0
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
	return platform_list[0] # always spawn on first corridor

func get_spawn_tile(platform: Dictionary) -> Vector2i:
	return Vector2i(0, map_height - 6) # Spawn at **very left side** of map

func spawn_player():
	if not player_path:
		push_warning("Player path not set.")
		return
	var player = get_node(player_path)
	if player == null:
		push_warning("Player node not found.")
		return
	var spawn_tile: Vector2i
	if spawn_point != Vector2i(-1, -1):
		spawn_tile = spawn_point
	else:
		var platform = get_random_platform()
		if platform.is_empty():
			return
		spawn_tile = get_spawn_tile(platform)
	var world_pos = map_to_local(spawn_tile)
	player.global_position = world_pos
	print("Player spawned at ", world_pos)
