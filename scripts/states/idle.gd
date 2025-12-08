extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.can_dash = true
	player.animation_player.play("idle")

func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	
	player.velocity.y += player.gravity * _delta
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED * 0.1)
	player.move_and_slide()
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("crouch"):
		finished.emit(CROUCHING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif not is_equal_approx(input_direction_x, 0.0):
		finished.emit(RUNNING)
	elif player.is_on_floor() and Input.is_action_just_pressed("roll"):
		finished.emit(ROLLING)
