extends Control
func _on_sudoku_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sudoku/sudokudiff.tscn")
	
func _on_knight_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/knight/knightmodes.tscn")
	
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")

func _on_farmsim_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/farmsimulator/game.tscn")

func _on_labirint_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/labirint/labirintdiff.tscn")

func _on_zombieland_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/zombieland/zombiediff.tscn")
