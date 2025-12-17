extends Node
class_name MapLoader

# Loads the map into the tilemap and returns the spawn point directly
func load_into(tilemap: WorldTileMap, path: String) -> Vector2i:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open map: " + path)
		return Vector2i(0, 4) # fallback

	var raw_json := file.get_as_text()
	var result = JSON.parse_string(raw_json)
	if result == null:
		push_error("Failed to parse JSON map: " + path)
		return Vector2i(0, 4)

	var data = result

	# Clear the tilemap
	tilemap.clear_all()
	tilemap.map_width = data.width
	tilemap.map_height = data.height

	# Load each layer
	for i in range(data.layers.size()):
		var layer = data.layers[i]
		for t in layer.tiles:
			tilemap.set_tile(
				i,
				Vector2i(t.x, t.y),
				Vector2i(t.tx, t.ty)
			)

	# Return spawn point if present, else fallback
	if data.has("spawn_point"):
		return Vector2i(data.spawn_point.x, data.spawn_point.y)
	else:
		return Vector2i(0, 4) # fallback spawn
