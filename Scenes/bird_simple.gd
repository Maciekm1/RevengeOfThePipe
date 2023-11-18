extends CharacterBody2D

@export var jump_speed = -400
@export var min_jump_cd: float = 0.2
@export var max_jump_cd: float = 1.4
@export var travel_speed: float = 3
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var target: Marker2D

var can_jump: bool = true

func _ready():
	pass


func _process(delta):
	update_sprite()
	
	var direction: Vector2 = (-position + target.position)
	velocity.x += direction.normalized().x * travel_speed
	
	if can_jump:
		jump()
	else:
		velocity.y += gravity * delta
	
	move_and_slide()
	
func jump():
	velocity.y = jump_speed
	can_jump = false
	$JumpTimer.wait_time = randf_range(min_jump_cd, max_jump_cd)
	$JumpTimer.start()

func update_sprite():
#	var tween = create_tween()
#	tween.tween_property($Sprite2D, "rotation", $Sprite2D.rotation_degrees, clamp(90 * (velocity.y / 1000), 0, 90))
	$Sprite2D.rotation_degrees = 90 * (velocity.y / 1000)

func _on_jump_timer_timeout():
	can_jump = true
