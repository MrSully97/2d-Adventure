class_name Player extends CharacterBody2D

@export var SPEED := 200.0
@export var JUMP_VELOCITY := -200.0
@export var gravity := 600.0
@export var on_ledge: bool = false
@export var direction: float = 0.0
var can_dash: bool = true
var can_wall_kick: bool = false
var climb_target: Vector2
const TILE_SIZE: Vector2 = Vector2(16, 16)
const TILE_TOP_LEFT = Vector2(0, 0)
const TILE_TOP_RIGHT = Vector2(1, 0)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # New: Separate reference for sprite-specific props like flip_h
@onready var animation_player: AnimationPlayer = $AnimationPlayer  # Changed: Now points to AnimationPlayer
@onready var fsm := $StateMachine
@onready var ledge_grab_top: RayCast2D = $ledge_grab_top
@onready var ledge_grab_wall: RayCast2D = $ledge_grab_wall
@onready var ledge_grab_bottom: RayCast2D = $ledge_grab_bottom
@onready var ceiling_check: RayCast2D = $ceiling_check

func snap_to_climb_position() -> void:
	global_position = climb_target

func _update_ledge_raycasts() -> void:
	var dir = -1 if sprite.flip_h else 1
	ledge_grab_top.target_position = Vector2(dir * 18, -2)
	ledge_grab_wall.target_position = Vector2(dir * 16, 0)
	ledge_grab_bottom.target_position = Vector2(dir * 20, 0 )
	ledge_grab_top.force_raycast_update()
	ledge_grab_wall.force_raycast_update()
	ledge_grab_bottom.force_raycast_update()

func can_grab_ledge() -> bool:
	_update_ledge_raycasts()
	# Top ray hits the ledge (empty space above wall)
	if ledge_grab_top.is_colliding():
		return false
	# Wall ray must not hit anything (there's a grabbable edge)
	if not ledge_grab_wall.is_colliding():
		return false
	return true

func get_tile_corner_from_point(world_point: Vector2, corner: Vector2) -> Vector2:
	var tile = (world_point / TILE_SIZE).floor()
	return (tile + corner) * TILE_SIZE
	
func can_grab_wall() -> bool:
	_update_ledge_raycasts()
	# Top ray hits the ledge (empty space above wall)
	if not ledge_grab_top.is_colliding():
		return false
	# Wall ray must not hit anything (there's a grabbable edge)
	if not ledge_grab_wall.is_colliding():
		return false
	
	if not ledge_grab_bottom.is_colliding():
		return false
	return true

func stuck_crouch() -> bool:
	if ceiling_check.is_colliding():
		return true
	else:
		return false
