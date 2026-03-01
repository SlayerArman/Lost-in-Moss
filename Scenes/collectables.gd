extends Area2D

@export var player_node_path: NodePath = "../Player"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	var player = get_node(player_node_path)
	if body == player:
		# Play 2D sound
		var sound = $AudioStreamPlayer2D
		sound.play()
		# Detach sound from herb so it continues playing after herb is removed
		sound.get_parent().remove_child(sound)
		get_tree().current_scene.add_child(sound)
		# Remove the herb immediately
		queue_free()
