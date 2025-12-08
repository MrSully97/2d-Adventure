extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	Input.start_joy_vibration(0, 1, 1, 0.75)
	player.animation_player.play("land")
	player.velocity = Vector2.ZERO

func on_animation_finished() -> void:
	finished.emit(IDLE)
