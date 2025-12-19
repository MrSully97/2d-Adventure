extends Node
class_name PlayerSpawner

@export var player_path: NodePath

# Spawns the player at a specific tile position in a tilemap
func spawn(tile_pos: Vector2i, tilemap: WorldTileMap) -> void:
	if not player_path:
		push_warning("Player path not set in PlayerSpawner")
		return
	
	var player = get_node(player_path)
	if player == null:
		push_warning("Player node not found at path: %s" % player_path)
		return
	
	# Convert tile position to world coordinates
	var world_pos = tilemap.map_to_local(tile_pos)
	player.global_position = world_pos
	print("Player spawned at:", world_pos)
	
# Respawn player if below y level 500
func respawn_if_fallen(threshold_y: float = 500, reset_pos: Vector2 = Vector2(-1, -100)) -> void:
	var player = get_node_or_null(player_path)
	if player == null:
		return
	if player.global_position.y > threshold_y:
		player.velocity = Vector2.ZERO
		player.global_position = reset_pos
