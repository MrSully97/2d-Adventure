extends PlayerState

@export var hang_animation := "ledge_hang"
@export var climb_animation := "ledge_climb"

var snap_position := Vector2.ZERO

func enter(previous_state_path: String, data := {}) -> void:
	
	Input.start_joy_vibration(0, 1, 1, 0.2)
	
	# Snap to hanging position
	var hit_point = player.ledge_grab_wall.get_collision_point()
	
	# Get the top-left corner of tile
	var tile_corner = player.get_tile_corner_from_point(hit_point, player.TILE_TOP_LEFT)
	
	if player.sprite.flip_h:
		tile_corner = player.get_tile_corner_from_point(hit_point, player.TILE_TOP_RIGHT)
	
	var hand_offset = Vector2(0, 26)
	
	if player.sprite.flip_h:
		hand_offset.x = -9
	else:
		hand_offset.x = -6
	
	player.global_position = tile_corner + hand_offset
	player.velocity = Vector2.ZERO
	
	player.set_collision_layer_value(1, false)
	
	player.animation_player.play(hang_animation)

func physics_update(_delta: float) -> void:
	# Must keep holding jump to stay
	if not Input.is_action_pressed("grab"):
		finished.emit(FALLING)
		return
	
	# Press UP to climb
	if Input.is_action_pressed("move_up"):
		finished.emit(LEDGE_CLIMBING)
		return
	elif Input.is_action_just_pressed("move_down"):
		player.sprite.flip_h = !player.sprite.flip_h
		finished.emit(WALL_SLIDE)
