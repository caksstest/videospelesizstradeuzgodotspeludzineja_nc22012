extends Control

func _on_gameselect_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameselect.tscn")
	
func _on_difficulty_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/knight/battle/knightdiff.tscn")
