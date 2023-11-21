extends Node2D

var score: int = 0:
	set(value):
		score = value
		score_label.text = str(score)
var game_time: float = 0

@onready var player: Player = $Player
@onready var score_label = $UI/LabelMarginContainer/Score

func _ready():
	$BirdSpawner.connect("spawn_bird", spawn_bird)
	
func _process(delta):
	game_time += delta
	
func reset():
	player.reset()
	score = 0
	game_time = 0
	
func spawn_bird(bird: PackedScene, pos: Vector2):
	var new_bird: Bird = bird.instantiate() as Bird
	new_bird.position = pos
	new_bird.target = $BirdTarget
	new_bird.connect("destroyed", on_bird_destroy)
	add_child(new_bird)
	
func on_bird_destroy(score_gain: int):
	score += score_gain
	
