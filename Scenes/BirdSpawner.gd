extends Node2D
class_name enemySpawner

signal spawn_enemy(enemy, pos)

@onready var spawn_points_path = $SpawnPointsPath
@onready var spawn_point = $SpawnPointsPath/SpawnPoint

@export var enemy_to_spawn: Array[PackedScene]
@export var spawn_time: float = 2
@export var spawn_time_decrease_every_spawn: float = 0

var can_spawn_enemy: bool = false

func _ready():
	$enemySpawnTimer.wait_time = spawn_time
	
func _process(delta):
	if(can_spawn_enemy):
		$SpawnPointsPath/SpawnPoint.progress_ratio = randf_range(0, 1)
		create_enemy(enemy_to_spawn[randi() % enemy_to_spawn.size()], $SpawnPointsPath/SpawnPoint.position)

func create_enemy(enemy: PackedScene, pos: Vector2):
	can_spawn_enemy = false
	spawn_enemy.emit(enemy, pos)
	$enemySpawnTimer.start()


func _on_enemy_spawn_timer_timeout():
	spawn_time -= spawn_time_decrease_every_spawn
	$enemySpawnTimer.wait_time = clamp(spawn_time, 1, 3)
	can_spawn_enemy = true

