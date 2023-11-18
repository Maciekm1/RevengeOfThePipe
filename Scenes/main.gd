extends Node2D

var score: int = 0:
	set(value):
		score = value
		score_label.text = str(score)
var game_time: float = 0

@onready var player: Player = $Player
@onready var score_label = $UI/LabelMarginContainer/Score

func _ready():
	pass
	
func _process(delta):
	game_time += delta
	
func reset():
	player.reset()
	score = 0
	game_time = 0
