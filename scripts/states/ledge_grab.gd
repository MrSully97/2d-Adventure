extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if player.is_on_floor() or player.velocity.y <= 0 or player.direction == 0:
		print('no ledge collision')
		return
	
	if !$ledge_grab_hit.is_colliding() or $ledge_grab_miss.is_colliding():
		print('colliding with ledge')
		return
	
	#var desired_pos: Vector2 = global_position.snapped(player.TILE_SIZE) + Vector2(-2.5 * player.direction, -1)
	#var pos_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
	
