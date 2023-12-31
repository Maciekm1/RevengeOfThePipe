extends Node2D

var score: int = 0:
	set(value):
		score = value
		ui.update_score_label(str(score))
var game_time: float = 0

@onready var player: Player = $Player

var max_wave_credits: int = 8

@onready var left_tap = $UI/LeftTapButton/LeftTap
@onready var right_tap = $UI/RightTapButton/RightTap
@onready var ui = $UI as UI
@onready var parallax_background = $ParallaxBackground as ParallaxBackground

func _ready():
	#Init
	player_health_bar_setup()
	
	$WaveSpawner.connect("spawn_enemy", spawn_enemy)
	$WaveSpawner.connect("wave_started", update_wave_ui)
	$WaveSpawner.connect("wave_credits_changed", update_wave_credits)
	
func _process(delta):
	resize_tap_buttons_to_screen()
	game_time += delta
	
	parallax_background.scroll_offset += .2 * Vector2(1, 0)
	
func reset():
	score = 0
	game_time = 0
	$WaveSpawner.reset()
	
func spawn_enemy(enemy: EnemySpawnInfo, pos: Vector2):
	var new_Enemy: Enemy = get_node(str(enemy.object_pool).replace("../", "")).get_object_from_pool() as Enemy
	new_Enemy.position = pos
	new_Enemy.health.health = new_Enemy.health.max_health
	
	var t = randf()
	new_Enemy.target = $Line2D.points[0].lerp($Line2D.points[1], t)
	if not new_Enemy.is_connected("on_death", on_enemy_death):
		new_Enemy.connect("on_death", on_enemy_death)
	new_Enemy.is_active = true
	new_Enemy.has_dealt_damage = false
	
func on_enemy_death(score_gain: int):
	score += score_gain
	
func player_health_bar_setup():
	$Player.connect("on_health_change", update_health_bar_ui)
	$Player.connect("on_death", reset)
	
	# health Bar For Player
	ui.update_player_health_bar_max($Player.get_node("HealthComponent").max_health)
	update_health_bar_ui($Player.get_node("HealthComponent").max_health)
	
func update_health_bar_ui(new_health):
	ui.update_player_health_bar(new_health)
	
func update_wave_ui(wave, max_credits):
	%CurrentWaveLabel.text = str(wave)
	%WaveProgressBar.max_value = max_credits
	%WaveProgressBar.value = 0
	max_wave_credits = max_credits
	
func update_wave_credits(credits):
	create_tween().tween_property(%WaveProgressBar, 'value', max_wave_credits - credits, 1.5)

func resize_tap_buttons_to_screen():
	var screen_size = get_viewport_rect().size
	left_tap.scale = Vector2(screen_size.x/2, screen_size.y)
	right_tap.scale = Vector2(screen_size.x/2, screen_size.y)
	right_tap.position = Vector2(0, screen_size.y)
