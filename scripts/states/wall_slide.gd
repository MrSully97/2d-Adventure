extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("wall_slide")

func physics_update(_delta: float) -> void:
	player.velocity.y += (player.gravity / 2) * _delta/2
	player.move_and_slide()
	
	if Input.is_action_just_released("grab") or not player.ledge_grab_bottom.is_colliding():
		finished.emit(FALLING)
	elif not player.is_on_floor() and Input.is_action_just_pressed("jump") and player.can_dash:
		player.can_wall_kick = true
		finished.emit(AIR_SPIN)
	elif player.is_on_floor():
		finished.emit(FALLING)
