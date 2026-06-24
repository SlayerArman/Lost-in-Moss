extends Area2D

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_class("CharacterBody2D"):
		body.die()
