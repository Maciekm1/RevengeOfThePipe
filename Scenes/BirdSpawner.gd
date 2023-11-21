extends Node2D
class_name BirdSpawner

signal spawn_bird(bird, pos)

@onready var spawn_points_path = $SpawnPointsPath
@onready var spawn_point = $SpawnPointsPath/SpawnPoint

@export var enemy_to_spawn: PackedScene
@export var spawn_time: float = 2

var can_spawn_bird: bool = false

func _ready():
	$BirdSpawnTimer.wait_time = spawn_time
	
func _process(delta):
	if(can_spawn_bird):
		$SpawnPointsPath/SpawnPoint.progress_ratio = randf_range(0, 1)
		create_bird(enemy_to_spawn, $SpawnPointsPath/SpawnPoint.position)

func create_bird(bird: PackedScene, pos: Vector2):
	can_spawn_bird = false
	spawn_bird.emit(bird, pos)
	$BirdSpawnTimer.start()


func _on_bird_spawn_timer_timeout():
	can_spawn_bird = true
