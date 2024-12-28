extends Node

var total_monsters: int = 0
@onready var enemies: Label = $CanvasLayer/enemies
@onready var playersurv: CharacterBody2D = $playersurv

func _ready() -> void:
	initialize_monsters()
	update_monster_count_display()

func initialize_monsters() -> void:
	# Find all monsters in the scene by group
	var monsters = get_tree().get_nodes_in_group("monsters")
	total_monsters = monsters.size()
	update_monster_count_display()
	
func update_monster_count_display() -> void:
	enemies.text = "ENEMIES LEFT: " + str(total_monsters)

func _on_snail_defeated() -> void:
	total_monsters -= 1
	update_monster_count_display()
	if total_monsters <= 0:
		victory()

func _on_blackboar_deafeated() -> void:
	total_monsters -= 1
	update_monster_count_display()
	if total_monsters <= 0:
		victory()

func _on_smallbee_defeated() -> void:
	total_monsters -= 1
	update_monster_count_display()
	if total_monsters <= 0:
		victory()

func victory():
	call_deferred("change_scene")

func change_scene():
	get_tree().change_scene_to_file("res://scenes/knight/battle/gamedoneforest.tscn")
