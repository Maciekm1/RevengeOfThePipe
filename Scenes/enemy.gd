extends CharacterBody2D
class_name Enemy

signal on_death(point_gain)

@export var health: HealthComponent
@export var damage_dealt: int = 10
@export var move_speed: float = 3

@export var points_given:int = 1

var target: Vector2
var hurt: bool = false

func _ready():
	health.connect("on_death", death)
	
func _process(delta):
	pass
	
func _physics_process(delta):
	move_towards_target(delta)
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)
	
func handle_collision(col):
	print("I collided with ", col.get_collider().name)

func move_towards_target(delta):
	var direction: Vector2 = (target - position).normalized()
	
	if target.distance_to(position) >= 10:
		velocity = direction * move_speed
	else:
		velocity = Vector2.ZERO
		
func take_damage(damage: int):
	hurt = true
	$Timers/hurtTimer.start()
	health.take_damage(damage)
	
func death():
	on_death.emit(points_given)
	call_deferred("queue_free")


func _on_hurt_timer_timeout():
	hurt = false
