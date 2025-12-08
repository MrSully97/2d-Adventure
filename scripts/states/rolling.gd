extends PlayerState

@export var roll_speed : float = 200.0
@export var roll_friction: float = 1000.0
var roll_dir : int = 0
var falling_roll : bool = false

func enter(previous_state_path: String, data := {}) -> void:
	roll_dir = -1.0 if player.sprite.flip_h else 1.0
	
	player.velocity.x += roll_dir * roll_speed
	
	falling_roll = true if previous_state_path == FALLING else false
		
	
	player.animation_player.play("roll")

func physics_update(_delta: float) -> void:
	
	player.velocity.x = move_toward(player.velocity.x, (200.0 * roll_dir), roll_friction * _delta)
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	
	#if not player.is_on_floor():
		#finished.emit(FALLING)

func on_animation_finished() -> void:
	if player.stuck_crouch():
		finished.emit(CROUCHING)
	elif not player.is_on_floor():
		finished.emit(FALLING)
	else:
		if Input.is_action_just_pressed("jump"):
			finished.emit(JUMPING)
		elif Input.is_action_just_pressed("crouch"):
			finished.emit(CROUCHING)
		elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			finished.emit(RUNNING, {"falling_roll": falling_roll})
		else:
			finished.emit(IDLE)
