extends CanvasLayer
class_name UI

@onready var pause_button = %PauseButton
@onready var shop_button = %ShopButton
@onready var settings_button = %SettingsButton
@onready var player_health_bar = %PlayerHealthBar
@onready var score_label = %ScoreLabel


func _on_pause_button_button_down():
	on_pause()
	get_tree().paused = not get_tree().paused

func on_pause():
	var tween = create_tween()
	tween.set_parallel(true)
	if(not get_tree().paused):
		shop_button.disabled = false
		settings_button.disabled = false
		tween.tween_property(shop_button, "modulate:a", 1, .5)
		tween.tween_property(settings_button, "modulate:a", 1, .5)
	else:
		tween.tween_property(settings_button, "modulate:a", 0, .5)
		tween.tween_property(shop_button, "modulate:a", 0, .5)
		shop_button.disabled = true
		settings_button.disabled = true

func _on_shop_button_button_down():
	print('shop')

func _on_settings_button_button_down():
	print('settings')

func update_player_health_bar_max(value: float):
	player_health_bar.max_value = value
	
func update_player_health_bar(value: float):
	var tween = create_tween()
	tween.tween_property(player_health_bar, "value", value, 0.1)

func update_score_label(text: String):
	score_label.text = text
