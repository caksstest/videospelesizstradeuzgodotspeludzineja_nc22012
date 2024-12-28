extends Control

func _on_runner_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/knight/runner/levelselect.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameselect.tscn")

func _on_battle_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/knight/battle/knightdiff.tscn")
