class_name Player extends CharacterBody2D


@export var SPEED := 200.0
@export var JUMP_VELOCITY := -200.0
@export var gravity := 600.0

@export var on_ledge: bool = false
@export var direction: float = 0.0
var can_dash: bool = true
const TILE_SIZE: Vector2 = Vector2(16, 16)
const TILE_TOP_LEFT = Vector2(0, 0)
const TILE_TOP_RIGHT = Vector2(1, 0)

@onready var animation_player = $AnimatedSprite2D
@onready var fsm := $StateMachine

@onready var ledge_grab_top: RayCast2D = $ledge_grab_top
@onready var ledge_grab_wall: RayCast2D = $ledge_grab_wall

func _update_ledge_raycasts() -> void:
	var dir = -1 if animation_player.flip_h else 1
	ledge_grab_top.target_position = Vector2(dir * 18, -20)
	ledge_grab_wall.target_position = Vector2(dir * 16, -8)
	ledge_grab_top.force_raycast_update()
	ledge_grab_wall.force_raycast_update()

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
