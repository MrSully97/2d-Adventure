extends PlayerState

@export var climb_animation := "ledge_climb"

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity = Vector2.ZERO
	
	# Start from the tile corner that the hang snapped to
	var start_corner = player.get_tile_corner_from_point(player.global_position, player.TILE_TOP_LEFT)
	
	if player.animation_player.flip_h:
		start_corner = player.get_tile_corner_from_point(player.global_position, player.TILE_TOP_RIGHT)
	# Move up one full tile + some offset for sprite feet
	var climb_target = start_corner + Vector2(0, -player.TILE_SIZE.y)
	
	#var climb_up_y := -28
	#var climb_forward_x := 16
	
	# Target position = standing on top of ledge
	#var climb_target = player.global_position + Vector2(0, climb_up_y) # Tweak for animation
	
	if player.animation_player.flip_h:
		climb_target.x -= player.TILE_SIZE.x
	else:
		climb_target.x += player.TILE_SIZE.x
	
	player.animation_player.play(climb_animation)
	
	# Smooth movement during climb
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(player, "global_position", climb_target, 0.4)
	await tween.finished
	
	player.set_collision_layer_value(1, true)
	
	# Wait for animation to finish
	if not player.animation_player.is_playing():
		_climb_complete()
	else:
		await player.animation_player.animation_finished
		_climb_complete()
	
func _climb_complete() -> void:
	# Now on ground
	if Input.get_axis("move_left", "move_right") == 0:
		finished.emit(IDLE)
	else:
		finished.emit(RUNNING)
