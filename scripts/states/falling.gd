extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("fall")

func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	
	if input_direction_x != 0:
		player.animation_player.flip_h = input_direction_x < 0
	
	var dir := -1 if player.animation_player.flip_h else 1
	var small_boost := (player.SPEED * dir) * 0.3
	
	player.velocity.x = small_boost if (player.velocity.x < 5 and player.velocity.x > -5) and not input_direction_x == 0 else player.velocity.x
	#if player.animation_player.flip_h:
		#if player.velocity.x > -5:
			#player.velocity.x = (-player.SPEED * 0.3) * _delta
	#else: 
		#if player.velocity.x < 5:
			#player.velocity.x = (player.SPEED * 0.3) * _delta
	player.velocity.y += player.gravity * _delta
	var y_speed = player.velocity.y
	player.move_and_slide()
	
	# Landing
	if player.is_on_floor():
		if y_speed > 400:
			finished.emit(LANDING)
		elif is_equal_approx(input_direction_x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
		return
	# Ledge grab check
	elif player.velocity.y > 0 and Input.is_action_pressed("grab") and player.can_grab_ledge():
		finished.emit(LEDGE_HANGING)
	elif player.velocity.y > 0 and Input.is_action_pressed("grab") and player.can_grab_wall():
		player.can_dash = true
		player.direction = input_direction_x
		finished.emit(WALL_LAND)
	elif !player.is_on_floor() and Input.is_action_just_pressed("jump") and player.can_dash:
		player.can_dash = false
		finished.emit(AIR_SPIN)
