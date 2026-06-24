extends Area2D

var activated := false

func _ready():
	self.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if activated:
		return

	if body.is_in_group("Player"):
		if Score.count >= 5:
			activated = true
			await get_tree().create_timer(1.0).timeout
			get_tree().change_scene_to_file("res://outro.tscn")
		else:
			if Score.label:
				Score.label.text = "Collect at least 5 orbs! (%d/5)" % Score.count
				_hide_message_delayed()


func _hide_message_delayed() -> void:
	var t = Timer.new()
	t.wait_time = 2.0
	t.one_shot = true
	add_child(t)
	t.start()
	t.timeout.connect(func():
		if Score.label:
			Score.label.text = ""
		t.queue_free()
	)
