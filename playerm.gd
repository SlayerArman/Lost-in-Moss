extends CharacterBody2D

@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var run_sound: AudioStreamPlayer2D = $RunSound
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var max_speed := 250.0
@export var acceleration := 1200.0
@export var friction := 800.0
@export var jump_velocity := -550.0
var gravity: float

var is_dead := false

func _ready():
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	var input_dir = Input.get_action_strength("Right") - Input.get_action_strength("Left")

	if input_dir != 0:
		velocity.x = move_toward(velocity.x, input_dir * max_speed, acceleration * delta)
		sprite.flip_h = velocity.x < 0
		sprite.play("Run")
		if not run_sound.playing and is_on_floor():
			run_sound.play()
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		sprite.play("Idle")
		if run_sound.playing:
			run_sound.stop()

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
		sprite.play("Jump")
		jump_sound.play()

	move_and_slide()

func die():
	if is_dead:
		return
	is_dead = true
	set_physics_process(false)
	visible = false
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()
