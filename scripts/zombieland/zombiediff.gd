extends Control
func _on_easy_pressed() -> void:
	Zombielandglobal.diff = 3
	get_tree().change_scene_to_file("res://scenes/zombieland/zombieland.tscn")
	
func _on_hard_pressed() -> void:
	Zombielandglobal.diff = 5
	get_tree().change_scene_to_file("res://scenes/zombieland/zombieland.tscn")

func _on_imposible_pressed() -> void:
	Zombielandglobal.diff = 7
	get_tree().change_scene_to_file("res://scenes/zombieland/zombieland.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameselect.tscn")
