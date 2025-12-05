extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = player.JUMP_VELOCITY
	player.animation_player.play("jump")

func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	if input_direction_x > 0:
		player.animation_player.flip_h = false
	elif input_direction_x < 0:
		player.animation_player.flip_h = true
	#player.velocity.x = player.SPEED * input_direction_x
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	
	if player.velocity.y >= 0:
		finished.emit(FALLING)
