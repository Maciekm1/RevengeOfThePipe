extends CharacterBody2D
class_name Player

@export var jump_speed: float = -700
@export var accel: float = 150
@export var player_damage: float = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var upper_pipe_offset: int = $UpperPipeConnection.position.y
@onready var lower_pipe_offset: int = $LowerPipeConnection.position.y

@onready var upper_start_value: int = $UpperPipe.position.y
@onready var lower_start_value: int = $LowerPipe.position.y

signal smash
signal on_death
signal on_health_change(current_health)

var screen_size: Vector2
var jump_pressed: bool = false
var smash_pressed: bool = false
var smashing: bool = false
var smashing_invul: bool = false

func _ready():
	screen_size = get_viewport_rect().size
	
	$HealthComponent.connect("on_health_change",health_change)
	$HealthComponent.connect("on_death", death)

func health_change(current_health):
	on_health_change.emit(current_health)

func _input(event):
	if event.is_action_pressed("player_jump"):
		jump_pressed = true
	elif event.is_action_released("player_jump"):
		jump_pressed = false
		
	if event.is_action_pressed("smash"):
		smash_pressed = true
		smashing_invul = true

func _process(delta):
	
	#Magic Function
	clamp_pipe_position_to_screen(delta)
		
	if jump_pressed:
#		velocity.y = jump_speed
		velocity.y = lerp(velocity.y, jump_speed, accel * delta)
		
	if smash_pressed:
		if not smashing:
			smashing_invul = true
			smashing = true
			execute_smash()
		smash_pressed = false
	
	move_and_slide()
	
func execute_smash():
	smash.emit()
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($UpperPipe/UpperPipeH, "modulate", Color(0.8, 0.6, 0.8), 0.05)
	tween.tween_property($LowerPipe/LowerPipeH, "modulate", Color(0.8, 0.6, 0.8), 0.05)
	tween.tween_property($LowerPipe, "position:y", 0, 0.15)
	tween.tween_property($UpperPipe, "position:y", 0, 0.15)
	
	await get_tree().create_timer(.8).timeout
	
	smashing_invul = false
	
	var tween_back = get_tree().create_tween()
	tween_back.set_parallel(true)
	tween_back.tween_property($UpperPipe/UpperPipeH, "modulate", Color(1, 1, 1), 0.3)
	tween_back.tween_property($LowerPipe/LowerPipeH, "modulate", Color(1, 1, 1), 0.3)
	tween_back.tween_property($LowerPipe, "position:y", lower_start_value, 0.4)
	await tween_back.tween_property($UpperPipe, "position:y", upper_start_value, 0.4).finished
	
	smashing = false

func clamp_pipe_position_to_screen(delta):
	#Clamp Position - No idea how it works >.< - it just does.
	#Takes into account the canvas and viewport scaling (app is set to expand) to work on multiple screen resolutions
	var diff = get_viewport_transform()[2].y * 1/get_viewport_transform().y.y
	screen_size = get_viewport_rect().size
	position.y = clamp(position.y,lower_pipe_offset - diff, screen_size.y+ upper_pipe_offset - diff)
	
	if(position.y < lower_pipe_offset):
		velocity.y += gravity * delta
	elif(position.y > screen_size.y + upper_pipe_offset - diff - 1):
		velocity.y = 0
	else:
		velocity.y += gravity * delta

func _on_lower_area_2d_body_entered(body):
	if "take_damage" in body:
		body.take_damage(player_damage)
	if "damage_dealt" in body and not body.has_dealt_damage:
		take_damage(body.damage_dealt)
		body.has_dealt_damage = true
		
func _on_upper_area_2d_body_entered(body):
	if "take_damage" in body:
		body.take_damage(player_damage)
	if "damage_dealt" in body and not body.has_dealt_damage:
		take_damage(body.damage_dealt)
		body.has_dealt_damage = true
		
		
func death():
	on_death.emit()
	reset()

func reset():
	velocity.y = 0
	smashing = false
	jump_pressed = false
	smash_pressed = false
	$HealthComponent.health = $HealthComponent.max_health

func take_damage(damage: int):
	if not smashing_invul:
		$HealthComponent.take_damage(damage)
