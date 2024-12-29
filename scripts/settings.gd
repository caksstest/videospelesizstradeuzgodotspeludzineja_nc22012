extends Control

@onready var check_button: CheckButton = $vbox/HBoxContainer/Label/CheckButton

func _ready():
	check_button.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
		
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")

func _on_check_button_toggled(checked: bool) -> void:
	if checked:
		# If the checkbox is checked, enable fullscreen
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		# If the checkbox is unchecked, disable fullscreen
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
