extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("wall_land")
	player.velocity.y = 0
	player.animation_player.flip_h = !player.animation_player.flip_h
		


func update(_delta: float) -> void:
	player.velocity.y = 0
	player.move_and_slide()
	
	if player.velocity.y >= 0 and Input.is_action_just_released("grab"):
		finished.emit(FALLING)
	
	if not player.is_on_floor() and Input.is_action_just_pressed("jump") and player.can_dash:
		player.can_wall_kick = true
		finished.emit(AIR_SPIN)
