extends Control

func _on_level_1_pressed() -> void:
	Autogame.level = 1
	get_tree().change_scene_to_file("res://scenes/knight/runner/knightrunner.tscn")

func _on_level_2_pressed() -> void:
	Autogame.level = 2
	get_tree().change_scene_to_file("res://scenes/knight/runner/knightrunner2.tscn")

func _on_level_3_pressed() -> void:
	Autogame.level = 3
	get_tree().change_scene_to_file("res://scenes/knight/runner/knightrunner3.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/knight/knightmodes.tscn")
