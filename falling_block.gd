extends RigidBody2D

@export var fall_gravity := 0.2
@export var fall_delay := 0.5
@export var reset_time := 3.0

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var area: Area2D = $Area2D

var start_position: Vector2
var start_rotation: float
var falling := false

func _ready():
	start_position = global_position
	start_rotation = rotation
	reset_block_state()
	continuous_cd = RigidBody2D.CCDMode.CCD_MODE_CAST_SHAPE
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if falling:
		return
	if body.name != "Player":
		return

	falling = true
	if sprite:
		sprite.play("Shake")  # optional pre-fall animation

	# wait before falling
	await get_tree().create_timer(fall_delay).timeout

	# apply gravity to start falling
	gravity_scale = fall_gravity

	# wait while block falls
	await get_tree().create_timer(reset_time).timeout

	# reset block completely
	reset_block_state()
	falling = false

func reset_block_state():
	global_position = start_position
	rotation = start_rotation
	gravity_scale = 0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	if sprite:
		sprite.stop()
