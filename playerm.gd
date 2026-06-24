extends CharacterBody2D

@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var run_sound: AudioStreamPlayer2D = $RunSound
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: ProgressBar = $"CanvasLayer/Health Bar"

@export var max_speed: float = 250.0
@export var acceleration: float = 1200.0
@export var friction: float = 800.0
@export var jump_velocity: float = -550.0

@export var max_health: int = 100
@export var invincibility_time: float = 0.5
var health: int
var can_take_damage: bool = true

var gravity: float
var is_dead: bool = false

func _ready():
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	add_to_group("Player")

	health = max_health
	update_health_bar()

	if health_bar == null:
		push_error("HealthBar not found! Check node path.")

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

func take_damage(amount: int) -> void:
	if is_dead:
		return
	if not can_take_damage:
		return

	print("Player hit:", amount)

	can_take_damage = false

	health -= amount
	health = clamp(health, 0, max_health)

	update_health_bar()

	if health <= 0:
		die()
	else:
		sprite.modulate = Color(1, 0.5, 0.5)

		await get_tree().create_timer(invincibility_time).timeout
		sprite.modulate = Color(1, 1, 1)
		can_take_damage = true

func update_health_bar():
	if health_bar:
		health_bar.value = health
	else:
		print("HealthBar missing!")

func die() -> void:
	if is_dead:
		return

	is_dead = true
	set_physics_process(false)
	sprite.modulate = Color(1, 0, 0)
	visible = false

	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()
