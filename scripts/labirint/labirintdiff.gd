extends Control

func _on_easy_pressed() -> void:
	Labirintscore.lives = 5
	get_tree().change_scene_to_file("res://scenes/labirint/labirint.tscn")

func _on_medium_pressed() -> void:
	Labirintscore.lives = 4
	get_tree().change_scene_to_file("res://scenes/labirint/labirint.tscn")

func _on_hard_pressed() -> void:
	Labirintscore.lives = 3
	get_tree().change_scene_to_file("res://scenes/labirint/labirint.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameselect.tscn")
