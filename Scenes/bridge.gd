extends Area2D

var touch_count := 0
var player_inside := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(_body):
	# Only one node exists (the player), so we can count
	if not player_inside:
		player_inside = true
		touch_count += 1
		print("Touches:", touch_count)
		
		if touch_count >= 3:
			get_tree().change_scene_to_file("res://transtion.tscn")

func _on_body_exited(_body):
	player_inside = false
