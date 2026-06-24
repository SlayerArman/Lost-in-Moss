extends Area2D

@onready var sfx_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	monitoring = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):

	if body.is_in_group("Player"):
		sfx_player.play()
		Score.count += 1
		if Score.label:
			Score.label.text = "Orbs: %d / %d" % [Score.count, Score.total]
		queue_free()
