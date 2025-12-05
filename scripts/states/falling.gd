extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("fall")

func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.direction = int(player.velocity.x) / player.SPEED
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
	elif not player.is_on_floor() and not player.on_ledge:
		print('not on ledge: ', player.direction)
