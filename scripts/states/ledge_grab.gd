extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	print(player.global_position)
	if player.is_on_floor() or player.velocity.y <= 0:
		return
	
	if !player.ledge_grab_hit.is_colliding() or player.ledge_grab_miss.is_colliding():
		return
	
	#var desired_pos: Vector2 = global_position.snapped(player.TILE_SIZE) + Vector2(-2.5 * player.direction, -1)
	#var pos_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
	return
	
func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.direction = input_direction_x
	if input_direction_x > 0:
		player.animation_player.flip_h = false
	elif input_direction_x < 0:
		player.animation_player.flip_h = true
	#player.velocity.x = player.SPEED * input_direction_x
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	
	if player.is_on_floor():
		if is_equal_approx(input_direction_x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
	#elif not player.is_on_floor() and not player.on_ledge:
		#finished.emit(LEDGE_GRABBING)
