extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("run")

func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	
	if input_direction_x > 0:
		player.animation_player.flip_h = false
	elif input_direction_x < 0:
		player.animation_player.flip_h = true
	
	player.velocity.x = player.SPEED * input_direction_x
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("crouch"):
		finished.emit(CROUCHING)
	elif is_equal_approx(input_direction_x, 0.0):
		finished.emit(IDLE)
