extends Control
class_name PopUp

@onready var top_title = %TopTitle
@onready var bottom_button = %BottomButton
@onready var content_label = %ContentLabel

signal bottom_button_press

func set_top_title(title: String):
	top_title.text = title
	
func set_bottom_button_text(text: String):
	bottom_button.text = text
	
func set_content_text(text: String):
	content_label.text = text
	
func _on_bottom_button_button_down():
	bottom_button_press.emit()
