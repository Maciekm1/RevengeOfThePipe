extends CanvasLayer

@onready var pause_button = %PauseButton
@onready var shop_button = %ShopButton
@onready var settings_button = %SettingsButton


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
		await tween.finished
		shop_button.disabled = true
		settings_button.disabled = true

func _on_shop_button_button_down():
	print('shop')

func _on_settings_button_button_down():
	print('settings')
