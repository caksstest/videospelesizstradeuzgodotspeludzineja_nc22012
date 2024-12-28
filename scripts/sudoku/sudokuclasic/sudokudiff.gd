extends Control


func _on_easy_pressed() -> void:
	Sudokuglobal.DIFFICULTY = 22
	get_tree().change_scene_to_file("res://scenes/sudoku/sudoku.tscn")

func _on_medium_pressed() -> void:
	Sudokuglobal.DIFFICULTY = 33
	get_tree().change_scene_to_file("res://scenes/sudoku/sudoku.tscn")

func _on_hard_pressed() -> void:
	Sudokuglobal.DIFFICULTY = 44
	get_tree().change_scene_to_file("res://scenes/sudoku/sudoku.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameselect.tscn")
