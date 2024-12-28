extends Control
var level_scenes = {
	1: "res://scenes/knight/runner/knightrunner.tscn",
	2: "res://scenes/knight/runner/knightrunner2.tscn",
	3: "res://scenes/knight/runner/knightrunner3.tscn"
}

func _on_restart_pressed() -> void:
	if Autogame.level in level_scenes:
		get_tree().change_scene_to_file(level_scenes[Autogame.level])

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/knight/runner/levelselect.tscn")
