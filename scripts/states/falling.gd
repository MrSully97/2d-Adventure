extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("fall")

func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.direction = input_direction_x
	
	if input_direction_x != 0:
		player.animation_player.flip_h = input_direction_x < 0
	
	#player.velocity.x = player.SPEED * input_direction_x
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	
	# Landing
	if player.is_on_floor():
		if is_equal_approx(input_direction_x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
		return
	# Ledge grab check
	if player.velocity.y > 0 and Input.is_action_pressed("jump") and player.can_grab_ledge():
		finished.emit(LEDGE_HANGING)
