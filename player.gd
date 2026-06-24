extends CharacterBody2D

@onready var jump_sound = $JumpSound
@onready var run_sound = $RunSound


const SPEED = 100.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("Jump")
		jump_sound.play()

	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play("Run")
		if not run_sound.playing:
			run_sound.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("Idle")
		if run_sound.playing:
			run_sound.stop()

	move_and_slide()

var is_dead := false

func die():
	if is_dead:
		return
	is_dead = true
	set_physics_process(false)
	visible = false
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()
