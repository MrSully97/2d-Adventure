extends PlayerState

@export var dash_speed := 250.0
@export var dash_down_impulse := 100.0
@export var wall_dash_impulse := 200.0
@export var air_control := 0.6

func enter(previous_state_path: String, data := {}) -> void:
	Input.start_joy_vibration(0, 0.5, 0.5, 0.1)
	
	var dash_dir = -1.0 if player.sprite.flip_h else 1.0
	player.velocity.x = dash_dir * dash_speed
	player.velocity.y = -wall_dash_impulse if player.can_wall_kick == true else -dash_down_impulse
	
	player.can_wall_kick = false
	
	player.animation_player.play("air_spin")

func physics_update(_delta: float) -> void:
	# Minimal air control
	var input_dir_x := Input.get_axis("move_left", "move_right")
	if input_dir_x != 0:
		player.sprite.flip_h = input_dir_x < 0
		player.velocity.x = move_toward(
			player.velocity.x, 
			input_dir_x * player.SPEED * air_control, 
			player.SPEED * _delta
		)
	
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()

func on_animation_finished() -> void:
	finished.emit(FALLING)
