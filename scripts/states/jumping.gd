extends PlayerState

var allow_air_movement = false

func enter(previous_state_path: String, data := {}) -> void:
	if previous_state_path == "Idle":
		allow_air_movement = true
	else:
		allow_air_movement = false
	player.velocity.y = player.JUMP_VELOCITY
	player.animation_player.play("jump")

func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	if input_direction_x > 0:
		player.sprite.flip_h = false
	elif input_direction_x < 0:
		player.sprite.flip_h = true
	# Allows air movement from idle animation to allow better directional jumps from standing
	if allow_air_movement == true:
		player.velocity.x = (player.SPEED / 1.5) * input_direction_x
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	
	if player.velocity.y >= 0:
		finished.emit(FALLING)
	
	if !player.is_on_floor() and Input.is_action_just_pressed("jump") and player.can_dash:
		player.can_dash = false
		finished.emit(AIR_SPIN)
