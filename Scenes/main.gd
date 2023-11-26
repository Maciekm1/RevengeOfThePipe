extends Node2D

var score: int = 0:
	set(value):
		score = value
		score_label.text = str(score)
var game_time: float = 0

@onready var player: Player = $Player
@onready var score_label = $UI/LabelMarginContainer/Score

func _ready():
	#Init
	Globals.camera = $Camera2D
	player_health_bar_setup()
	
	$BirdSpawner.connect("spawn_enemy", spawn_enemy)

func _process(delta):
	game_time += delta
	
func reset():
	score = 0
	game_time = 0
	
func spawn_enemy(enemy: PackedScene, pos: Vector2):
	var new_Enemy: Enemy = enemy.instantiate() as Enemy
	new_Enemy.position = pos
	
	var t = randf()
	new_Enemy.target = $Line2D.points[0].lerp($Line2D.points[1], t)
	new_Enemy.connect("on_death", on_enemy_death)
	add_child(new_Enemy)
	
func on_enemy_death(score_gain: int):
	score += score_gain
	
func player_health_bar_setup():
	$Player.connect("on_health_change", update_health_bar_ui)
	$Player.connect("on_death", reset)
	
	# health Bar For Player
	$UI/MarginContainer/HealthBar.max_value = $Player.get_node("HealthComponent").max_health
	update_health_bar_ui($Player.get_node("HealthComponent").max_health)
	
func update_health_bar_ui(new_health):
	var tween = create_tween()
	tween.tween_property($UI/MarginContainer/HealthBar, "value", new_health, 0.1)
