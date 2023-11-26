extends Node2D

# Wave Data
var current_wave: int = 0
var current_wave_credits: int = 0
@export var enemy_spawn_infos: Array[EnemySpawnInfo]

# Booleans
var is_spawning: bool = false # Spawn between waves

# Signals
signal wave_started
signal spawn_enemy(enemy: PackedScene, pos: Vector2)
signal wave_complete
signal wave_failed

# Timer Logic
var can_spawn: bool = false # True when SpawnCdTimer timeouts
var spawn_time: float = 1 #Time to wait between spawns

func _ready():
	start_wave(0)
	
func _process(delta):
	print(current_wave)
	print(current_wave_credits)
	
	print(is_spawning)
	print(can_spawn)
	if(current_wave_credits <= 0):
		is_spawning = false
		await get_tree().create_timer(2).timeout
		start_wave(current_wave+1)
	elif is_spawning and can_spawn:
		spawn_wave_enemy()

func start_wave(wave: int):
	current_wave = wave
	current_wave_credits = get_wave_credits()
	wave_started.emit()
	can_spawn = true
	is_spawning = true

func get_wave_credits() -> int:
	return 6 + (2 * current_wave)

func spawn_wave_enemy():
	if current_wave_credits > 0 and can_spawn:
		var enemy = enemy_spawn_infos[0]
		current_wave_credits -= enemy.spawn_cost
		
		spawn_enemy.emit(enemy.enemy, $Path2D/EnemySpawner.position)
		can_spawn = false
		$SpawnCdTimer.wait_time = spawn_time
		$SpawnCdTimer.start()

func _on_spawn_cd_timer_timeout():
	can_spawn = true
