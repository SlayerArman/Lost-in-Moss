extends Area2D

@onready var sprite = $AnimatedSprite2D

var bounce_force = -1050

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):

	if body.name != "Player":
		return

	if body.velocity.y > 0:
		body.velocity.y = bounce_force
		
		sprite.play("Bounce anim")
