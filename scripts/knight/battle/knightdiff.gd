extends Control

func _on_easy_pressed() -> void:
	Fighter.level = 1
	get_tree().change_scene_to_file("res://scenes/knight/battle/battle.tscn")

func _on_medium_pressed() -> void:
	Fighter.level = 2
	get_tree().change_scene_to_file("res://scenes/knight/battle/battle.tscn")
	
func _on_hard_pressed() -> void:
	Fighter.level = 3
	get_tree().change_scene_to_file("res://scenes/knight/battle/battle.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameselect.tscn")
