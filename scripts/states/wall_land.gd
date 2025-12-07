extends PlayerState

var start_sliding := false
var wall_timer : SceneTreeTimer
var active := false

func enter(previous_state_path: String, data := {}) -> void:
	active = true
	start_sliding = false
	
	player.animation_player.play("wall_land")
	player.velocity.y = 0
	player.animation_player.flip_h = !player.animation_player.flip_h
	
	wall_timer = get_tree().create_timer(0.5, false)
	wall_timer.timeout.connect(_on_wall_timer_timeout)

func _on_wall_timer_timeout() -> void:
	if not active:
		return
	start_sliding = true


func update(_delta: float) -> void:
	player.velocity.y = 0
	player.move_and_slide()
	
	if player.velocity.y >= 0 and Input.is_action_just_released("grab"):
		finished.emit(FALLING)
	elif not player.is_on_floor() and Input.is_action_just_pressed("jump") and player.can_dash:
		player.can_wall_kick = true
		finished.emit(AIR_SPIN)
	elif Input.is_action_pressed("grab") and start_sliding == true:
		finished.emit(WALL_SLIDE)
	elif player.is_on_floor():
		finished.emit(FALLING)

func exit() -> void:
	active = false
	if wall_timer: 
		if wall_timer.is_connected("timeout", _on_wall_timer_timeout):
			wall_timer.disconnect("timeout", _on_wall_timer_timeout)
	wall_timer = null
