extends Node2D
class_name HealthComponent

signal on_health_change(current_health)
signal on_death()

@export var max_health: int = 1
var health: int:
	set(value):
		health = value
		on_health_change.emit(health)
		if health_bar:
			update_health_bar()
		if(health <= 0):
			health = 0
			death()
@export var regeneration: float = 0

@export var health_bar: ProgressBar

func _ready():
	health = max_health
	
	if health_bar:
		if max_health == 1:
			health_bar.hide()
		health_bar.max_value = max_health

func _process(delta):
	if regeneration:
		health += regeneration * delta

func take_damage(damage: int):
	health -= damage

func death():
	on_death.emit()

func update_health_bar():
	var tween = create_tween()
	tween.tween_property(health_bar, "value", health, 0.1)
