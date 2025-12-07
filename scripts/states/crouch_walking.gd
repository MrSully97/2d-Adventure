extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("crouch_walk")

func changeAnimationSpeed(input: float) -> void:
	var player_speed = (abs(player.velocity.x) / 50)
	if abs(input) > 0:
		player.animation_player.speed_scale = player_speed if player_speed > 0.50 else 0.50
	else:
		player.animation_player.speed_scale = 1.0

func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	
	if input_direction_x < 0:
		player.animation_player.flip_h = true
	elif input_direction_x > 0:
		player.animation_player.flip_h = false
	
	player.velocity.x = (player.SPEED * 0.25) * input_direction_x
	changeAnimationSpeed(player.velocity.x)
	
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	
	if not player.is_on_floor():
		player.animation_player.speed_scale = 1.0
		finished.emit(FALLING)
	#elif player.is_on_floor() and Input.is_action_just_pressed("jump"):
		#player.animation_player.speed_scale = 1.0
		#finished.emit(JUMPING)
	elif Input.is_action_pressed("crouch") and is_equal_approx(input_direction_x, 0.0):
		player.animation_player.speed_scale = 1.0
		finished.emit(CROUCHING)
	elif Input.is_action_just_released("crouch") and not is_equal_approx(input_direction_x, 0.0):
		player.animation_player.speed_scale = 1.0
		finished.emit(RUNNING)
	elif not Input.is_action_pressed("crouch") and is_equal_approx(input_direction_x, 0.0):
		player.animation_player.speed_scale = 1.0
		finished.emit(IDLE)
