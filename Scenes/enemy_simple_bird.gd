extends Enemy

@export var jump_strength_max: float = 450
@export var jump_strength_min: float = 250

@export var jump_cd: float = .5
var can_jump: bool = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	super._ready()
	$Timers/JumpCdTimer.wait_time = jump_cd
	
func _process(delta):
	super._process(delta)
	rotate_sprite_t_velocity()
	
func rotate_sprite_t_velocity():
	$Sprite2D.rotation_degrees = 90 * (velocity.y / 1000)

func move_towards_target(delta):
	var direction_x: int = 1 if target.x > position.x else -1
	
	if can_jump:
		jump()
	else:
		velocity.y += gravity * delta
	
	if abs(target.x - position.x) >= 10:
		velocity.x = direction_x * move_speed
	else:
		velocity = Vector2.ZERO

func jump():
	can_jump = false
	$Timers/JumpCdTimer.wait_time = randf()
	
	velocity.y = -randf_range(jump_strength_min, jump_strength_max)
	$Timers/JumpCdTimer.start()


func _on_jump_cd_timer_timeout():
	can_jump = true
