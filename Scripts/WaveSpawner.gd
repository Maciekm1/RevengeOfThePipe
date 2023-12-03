extends Node2D

@export var enemy_spawn_infos: Array[EnemySpawnInfo]

# Wave Data
var current_wave: int = 0
var current_wave_credits: int = 0:
	set(value):
		current_wave_credits = value
		wave_credits_changed.emit(current_wave_credits)

# Booleans
var is_spawning: bool = false # Spawn between waves

# Signals
signal wave_started(wave, max_wave_credits)
signal wave_credits_changed(credits)
signal spawn_enemy(enemy: EnemySpawnInfo, pos: Vector2)

# UNUSED
signal wave_complete
signal wave_failed

# Timer Logic
var can_spawn_enemy: bool = false # True when SpawnCdTimer timeouts
@export var spawn_time_min: float = 1.2
@export var spawn_time_max: float = 1.8

@export var wait_time_bwtn_waves: float = 6
@export var wave_loss_on_reset: int = 3

func _ready():
	start_wave(1)
	
func _process(delta):
	
	if(current_wave_credits <= 0 and is_spawning):
		is_spawning = false
		await get_tree().create_timer(wait_time_bwtn_waves).timeout
		start_wave(current_wave+1)
	elif is_spawning and can_spawn_enemy:
		spawn_wave_enemy()

func start_wave(wave: int):
	current_wave = wave
	current_wave_credits = get_wave_credits()
	wave_started.emit(current_wave, current_wave_credits)
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
		spawn_enemy.emit(enemy, $Path2D/EnemySpawner.global_position)
		
		can_spawn_enemy = false
		$SpawnCdTimer.wait_time = randf_range(spawn_time_min, spawn_time_max)
		$SpawnCdTimer.start()

func get_current_wave_enemy() -> EnemySpawnInfo:
	var possible_enemies = get_possible_enemies_array()
	var total_weights = 0
	for x in possible_enemies:
		total_weights += x.spawn_weight
		
	var random_number = randf()
	var cum_spawn_chance = 0
	
	for enemy in possible_enemies:
		var spawn_chance: float = float(enemy.spawn_weight) / float(total_weights)
		cum_spawn_chance += spawn_chance
		if random_number <= cum_spawn_chance:
			return enemy
	return null

func get_possible_enemies_array() -> Array:
	var a: Array = []
	for x in enemy_spawn_infos:
		if x.min_wave_req <= current_wave and current_wave_credits - x.spawn_cost >= 0:
			a.append(x)
	return a
	
func _on_spawn_cd_timer_timeout():
	can_spawn_enemy = true

func reset():
	start_wave(clamp(current_wave - wave_loss_on_reset, 1, current_wave))
