extends Node

# Gets map selection options from main menu scene through global_singleton.gd
@onready var main_menu_map_options = get_node("/root/GlobalSingleton")

@onready var tilemap: WorldTileMap = $TileMap
@onready var generator: MapGenerator = $MapGenerator
@onready var loader: MapLoader = $MapLoader
@onready var serializer: MapSerializer = $MapSerializer
@onready var spawner: PlayerSpawner = $PlayerSpawner

@export var map_to_load: String = ""

@export var default_spawn: Vector2i = Vector2i(0, 4)
@export var save_path: String = "res://maps/"

func _ready():
	# Check global for pre-generated maps
	if main_menu_map_options.getMap() != '':
		map_to_load = main_menu_map_options.getMap()
		
	if map_to_load != "":
		# Load from JSON
		var spawn = loader.load_into(tilemap, map_to_load)
		spawner.spawn(spawn, tilemap)
	else:
		# Generate new map
		generator.generate(tilemap)
		# Change map name with randi number at end
		serializer.save("res://maps/generated_map_%s.json" % str(randi_range(1, 10000)), tilemap, default_spawn)
		spawner.spawn(default_spawn, tilemap)

# Respawns player at start if they fall
func _physics_process(delta: float) -> void:
	spawner.respawn_if_fallen()
