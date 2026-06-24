extends CanvasLayer

@onready var score_label = $"void label"

func _ready():
	Score.label = score_label
	Score.count = 0

	call_deferred("_count_total_orbs")

func _count_total_orbs():
	Score.total = 5
	_update_label()

func _update_label():
	if Score.label:
		Score.label.text = "Orbs: %d / %d" % [Score.count, Score.total]
