extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		await get_tree().create_timer(1).timeout  # optional delay
		get_tree().change_scene_to_file("res://outro.tscn")
