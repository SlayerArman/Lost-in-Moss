extends Area2D

func _ready():
	# Connect the signal to a function on this node
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_class("CharacterBody2D"):
		body.die()
