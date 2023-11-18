extends Node2D

var score: int = 0
var game_time: float = 0

@onready var player: Player = $Player

func _ready():
	pass
	
func _process(delta):
	game_time += delta
	
func reset():
	player.reset()
