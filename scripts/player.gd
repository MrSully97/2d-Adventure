class_name Player extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -500.0

@onready var animated_sprite = $AnimatedSprite2D
var spawn_position: Vector2
var distance_traveled: float = 0.0
var max_distance_this_run: float = 0.0

func _ready():
	spawn_position = global_position

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Input
	var direction := Input.get_axis("move_left", "move_right")
	var crouch := Input.get_action_strength("crouch")

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play animations
	if is_on_floor():
		if direction == 0:
			if crouch == 1:
				animated_sprite.play("crouch")
			else:
				animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Update distance traveled
	distance_traveled = global_position.x - spawn_position.x
	if distance_traveled > max_distance_this_run:
		max_distance_this_run = distance_traveled

	# Respawn if player falls
	if global_position.y > 500:
		respawn()

func respawn():
	global_position = spawn_position
	velocity = Vector2.ZERO
	print("Distance:", int(distance_traveled))

	distance_traveled = 0
	max_distance_this_run = 0  # optional

@export var SPEED := 200.0
@export var JUMP_VELOCITY := -200.0
@export var gravity := 600.0


@onready var animation_player = $AnimatedSprite2D

@onready var fsm := $StateMachine


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
