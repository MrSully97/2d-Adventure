extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	Input.start_joy_vibration(0, 1, 1, 0.75)
	player.animation_player.play("land")
	player.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
	if not player.animation_player.is_playing():
		finished.emit(IDLE)
