extends Node
class_name MapSerializer

func save(
	path: String,
	tilemap: WorldTileMap,
	spawn_point: Vector2i
) -> void:
	var data := {
		"width": tilemap.map_width,
		"height": tilemap.map_height,
		"background_bounds": tilemap.background_bounds,
		"spawn_point": {
			"x": spawn_point.x,
			"y": spawn_point.y
		},
		"layers": []
	}

	for layer in range(tilemap.get_layers_count()):
		var tiles := []
		for cell in tilemap.get_used_cells(layer):
			var atlas := tilemap.get_cell_atlas_coords(layer, cell)
			if atlas == Vector2i(-1, -1):
				continue

			tiles.append({
				"x": cell.x,
				"y": cell.y,
				"tx": atlas.x,
				"ty": atlas.y
			})

		data.layers.append({
			"layer": layer,
			"tiles": tiles
		})

	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to save map to " + path)
		return

	file.store_string(JSON.stringify(data, "\t"))
	file.close()

	print("Map saved to:", path)
