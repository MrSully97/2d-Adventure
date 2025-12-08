extends PlayerState

# Roll-tech grace period: how many physics frames after landing you can still roll
const ROLL_BUFFER_TIME := 0.18
var roll_buffer_timer := 0.0

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("fall")
	roll_buffer_timer = 0.0

func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	if input_direction_x != 0:
		player.sprite.flip_h = input_direction_x < 0
	
	# air control
	var dir := -1 if player.sprite.flip_h else 1
	var small_boost := player.SPEED * dir * 0.3
	if abs(player.velocity.x) < 5 and input_direction_x != 0:
		player.velocity.x = small_boost
	
	# ────── ROLL INPUT BUFFER ──────
	if Input.is_action_just_pressed("roll"):
		roll_buffer_timer = ROLL_BUFFER_TIME
	if roll_buffer_timer > 0.0:
		roll_buffer_timer -= _delta
	
	player.velocity.y += player.gravity * _delta
	var fall_speed := player.velocity.y
	player.move_and_slide()
	
	# Air checks
	if player.velocity.y > 0 and Input.is_action_pressed("grab"):
		if player.can_grab_ledge():
			finished.emit(LEDGE_HANGING)
			return
		elif player.can_grab_wall():
			player.can_dash = true
			player.direction = input_direction_x
			finished.emit(WALL_LAND)
			return
	
	if Input.is_action_just_pressed("jump") and player.can_dash:
		player.can_dash = false
		finished.emit(AIR_SPIN)
		return
	
	# Landing Checks
	if player.is_on_floor():
		if roll_buffer_timer > 0.0:
			finished.emit(ROLLING, {"from_fall_roll": true})
			return
		
		# Normal landing logic (hard land vs soft land)
		if fall_speed > 400:
			finished.emit(LANDING)
		elif is_equal_approx(input_direction_x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
		return
