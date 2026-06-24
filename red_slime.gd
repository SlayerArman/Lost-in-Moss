extends CharacterBody2D

const DIRECTION_INVERT: int = -1 

@export var speed: float = 60
@export var gravity: float = 900
@export var chase_range: float = 200
@export var damage: int = 10

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var edge_ray: RayCast2D = $EdgeRay

var player: CharacterBody2D = null
var patrol_dir: int = 1
var is_dead: bool = false

func _ready() -> void:
	add_to_group("Enemy")
	_find_player()

func _physics_process(delta: float) -> void:
	if is_dead: return
	if not is_instance_valid(player): _find_player()

	var move_direction: int = 0

	if is_instance_valid(player) and abs(player.global_position.x - global_position.x) <= chase_range:
		
		move_direction = sign(player.global_position.x - global_position.x) * DIRECTION_INVERT
	else:
		if is_on_wall() or (is_on_floor() and not edge_ray.is_colliding()):
			patrol_dir *= -1
		move_direction = patrol_dir

	velocity.x = move_direction * speed
	velocity.y += gravity * delta
	move_and_slide()


	if move_direction != 0:
		sprite.flip_h = (move_direction < 0)

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("Player") and collider.has_method("take_damage"):
			collider.take_damage(damage)

func _find_player() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0: player = players[0]
