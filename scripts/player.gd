class_name Player extends CharacterBody2D


@export var SPEED := 200.0
@export var JUMP_VELOCITY := -200.0
@export var gravity := 600.0

@export var on_ledge: bool = false
@export var direction: float = 0.0
const TILE_SIZE: Vector2 = Vector2(16, 16)

@onready var animation_player = $AnimatedSprite2D
@onready var fsm := $StateMachine

@onready var ledge_grab_miss = $ledge_grab_miss
@onready var ledge_grab_hit = $ledge_grab_hit


#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction: -1, 0, 1
	#var direction := Input.get_axis("move_left", "move_right")
	#var crouch := Input.get_action_strength("crouch") # 0, 1
	#
	#
	## Flip the sprite
	#if direction > 0:
		#animated_sprite.flip_h = false
	#elif direction < 0:
		#animated_sprite.flip_h = true
	#
	## Play animations
	#if is_on_floor():
		#if direction == 0:
			#if crouch == 1:
				#animated_sprite.play("crouch")
			#else:
				#animated_sprite.play("idle")
		#elif direction != 0:
			#animated_sprite.play("run")
	#else:
		#animated_sprite.play("jump")
	## Apply movement
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
