extends Control

@onready var time: Label = $CanvasLayer/Time
@onready var score: Label = $CanvasLayer/Score
@onready var nextlvl: Button = $VBoxContainer/nextlvl

var level_scenes = {
	1: "res://scenes/knight/runner/knightrunner2.tscn",
	2: "res://scenes/knight/runner/knightrunner3.tscn"
}

func _ready() -> void:
	score.text = "Orcs: " + str(Autogame.score)
	time.text = "Time: " + str(Autogame.time).pad_decimals(2)
	if Autogame.level == 3: 
		nextlvl.visible = false

func _on_gameselect_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameselect.tscn")

func _on_nextlvl_pressed() -> void:
	if Autogame.level in level_scenes:
		Autogame.level += 1
		get_tree().change_scene_to_file(level_scenes[Autogame.level - 1])
