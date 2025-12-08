extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.can_dash = true
	player.animation_player.play("run")

func changeAnimationSpeed(input: float) -> void:
	var player_speed = (abs(player.velocity.x) / 100) / 2
	if abs(input) > 0:
		player.animation_player.speed_scale = player_speed if player_speed > 0.25 else 0.25
	else:
		player.animation_player.speed_scale = 1.0

func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	
	if input_direction_x > 0:
		player.sprite.flip_h = false
	elif input_direction_x < 0:
		player.sprite.flip_h = true
	
	player.velocity.x = player.SPEED * input_direction_x
	changeAnimationSpeed(player.velocity.x)
	
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()

	if player.stuck_crouch():
		finished.emit(CROUCHING)
	if not player.is_on_floor():
		player.animation_player.speed_scale = 1.0
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		player.animation_player.speed_scale = 1.0
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("crouch"):
		player.animation_player.speed_scale = 1.0
		finished.emit(CROUCHING)
	elif is_equal_approx(input_direction_x, 0.0):
		player.animation_player.speed_scale = 1.0
		finished.emit(IDLE)
