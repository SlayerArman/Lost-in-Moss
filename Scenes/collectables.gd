extends Area2D

@export var player_node_path: NodePath = "../Player"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	var player = get_node(player_node_path)
	if body != player:
		return

	var sound = $AudioStreamPlayer2D
	sound.get_parent().remove_child(sound)
	get_tree().current_scene.add_child(sound)
	sound.play()

	Score.count += 1
	if Score.label:
		Score.label.text = "Orbs: %d / %d" % [Score.count, Score.total]

	queue_free()
