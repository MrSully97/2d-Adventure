extends PlayerState

@export var momentum_decay_rate: float = 3.0
var momentum_boost: float = 0.0

func enter(previous_state_path: String, data := {}) -> void:
	player.can_dash = true
	
	if previous_state_path == PlayerState.ROLLING and data.falling_roll:
		momentum_boost = 100.0
	
	player.animation_player.play("run")

func changeAnimationSpeed(input: float) -> void:
	var player_speed = (abs(player.velocity.x) / 100) / 2
	if abs(input) > 0:
		player.animation_player.speed_scale = player_speed if player_speed > 0.25 else 0.25
	else:
		player.animation_player.speed_scale = 1.0

func physics_update(_delta: float) -> void:
	if momentum_boost > 0.0:
		momentum_boost = lerp(momentum_boost, 0.0, momentum_decay_rate * _delta)
		if momentum_boost < 1.0:
			momentum_boost = 0.0
	
	var input_direction_x := Input.get_axis("move_left", "move_right")
	
	# Calculate speed with momentum
	var effective_speed := player.SPEED + momentum_boost
	
	if input_direction_x > 0:
		player.sprite.flip_h = false
	elif input_direction_x < 0:
		player.sprite.flip_h = true
	
	player.velocity.x = effective_speed * input_direction_x
	changeAnimationSpeed(player.velocity.x)
	
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()

	if player.stuck_crouch():
		finished.emit(CROUCHING)
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("crouch"):
		finished.emit(CROUCHING)
	elif Input.is_action_just_pressed("roll"):
		finished.emit(ROLLING)
	elif is_equal_approx(input_direction_x, 0.0):
		finished.emit(IDLE)
	
func exit() -> void:
	player.animation_player.speed_scale = 1.0
