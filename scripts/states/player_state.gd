class_name PlayerState extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const CROUCHING = "Crouching"
const LEDGE_HANGING = "Ledge_Hang"
const LEDGE_CLIMBING = "Ledge_Climb"
const AIR_SPIN = "Air_Spin"
const WALL_LAND = "Wall_Land"
const WALL_SLIDE = "Wall_Slide"

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs
	the owner to be a player node.")
