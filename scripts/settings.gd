extends Control

func _on_mastervolume_value_changed(value: float) -> void:
	volume(0,value)

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)

func _on_sfxvolume_value_changed(value: float) -> void:
	volume(1,value)
	
func _on_musicvolume_value_changed(value: float) -> void:
	volume(2,value)

func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)

func _on_res_option_item_selected(index: int) -> void:
	match index: 
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))


func _on_window_option_item_selected(index: int) -> void:
	match index: 
		0:
			DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED) 
		1: 
			DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
			
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
