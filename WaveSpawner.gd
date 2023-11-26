extends Node2D

# Wave Data
var current_wave: int = 0
var current_wave_credits: int = 0:
	set(value):
		current_wave_credits = value
		wave_credits_changed.emit(current_wave_credits)
@export var enemy_spawn_infos: Array[EnemySpawnInfo]

# Booleans
var is_spawning: bool = false # Spawn between waves

# Signals
signal wave_started(wave)
signal wave_credits_changed(credits)
signal spawn_enemy(enemy: PackedScene, pos: Vector2)
signal wave_complete
signal wave_failed

# Timer Logic
var can_spawn_enemy: bool = false # True when SpawnCdTimer timeouts
var spawn_time: float = 2 #Time to wait between spawns

func _ready():
	start_wave(1)
	
func _process(delta):
	
	if(current_wave_credits <= 0 and is_spawning):
		is_spawning = false
		await get_tree().create_timer(6).timeout
		start_wave(current_wave+1)
	elif is_spawning and can_spawn_enemy:
		spawn_wave_enemy()

func start_wave(wave: int):
	current_wave = wave
	current_wave_credits = get_wave_credits()
	wave_started.emit(current_wave)
	can_spawn_enemy = true
	is_spawning = true

func get_wave_credits() -> int:
	return 6 + (2 * current_wave)

func spawn_wave_enemy():
	if current_wave_credits > 0 and can_spawn_enemy:
		var enemy = get_current_wave_enemy()
		current_wave_credits -= enemy.spawn_cost
		
		var t = randf()
		$Path2D/EnemySpawner.progress_ratio = t
		spawn_enemy.emit(enemy.enemy, $Path2D/EnemySpawner.global_position)
		
		can_spawn_enemy = false
		$SpawnCdTimer.wait_time = randf_range(1.2, 1.8)
		$SpawnCdTimer.start()

func get_current_wave_enemy() -> EnemySpawnInfo:
	#TODO - Calculate spawn chance using weights
	var possible_enemies = get_possible_enemies_array()
	var total_weights = 0
	for x in possible_enemies:
		total_weights += x.spawn_weight
	var enemy = possible_enemies.pick_random()
	return enemy

func get_possible_enemies_array() -> Array:
	var a: Array = []
	for x in enemy_spawn_infos:
		if x.min_wave_req <= current_wave and current_wave_credits - x.spawn_cost >= 0:
			a.append(x)
	return a
func _on_spawn_cd_timer_timeout():
	can_spawn_enemy = true

func reset():
	start_wave(clamp(current_wave - 3, 1, current_wave))
