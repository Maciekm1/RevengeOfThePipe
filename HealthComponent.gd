extends Node2D
class_name HealthComponent

signal on_health_change(current_health)
signal on_death()

@export var max_health: int = 1
var health: int:
	set(value):
		health = value
		on_health_change.emit(health)
		if(health <= 0):
			health = 0
			death()
@export var regeneration: float = 0

func _ready():
	health = max_health

func _process(delta):
	if regeneration:
		health += regeneration * delta

func take_damage(damage: int):
	health -= damage

func death():
	on_death.emit()
