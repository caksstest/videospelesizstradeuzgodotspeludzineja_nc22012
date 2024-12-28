extends Node3D

@onready var time: Label = $Time
@onready var timer: Timer = $Timer
var survivetime = 180
@onready var panel: Panel = $CanvasLayer/panel
@onready var player: CharacterBody3D = $player
@onready var enemyhandler: Node3D = $Enemyhandler
@onready var spawner: Node3D = $spawner
@onready var nextlevel: Button = $CanvasLayer/panel/VBoxContainer/nextlevel
@onready var label: Label = $CanvasLayer/panel/Label

var game_over: bool = false  # Tracks if the game is over (win or lose)
var still_alive: bool = true  # Tracks if the player is still alive
var time_remaining: float = 0.0  # Tracks the remaining time

func _ready() -> void:
	time_remaining = survivetime
	timer.start(survivetime)
	time.text = str(survivetime)

func _process(delta: float) -> void:
	if game_over:
		return  
	time_remaining = timer.time_left
	if time_remaining > 0:
		time.text = format_time(time_remaining)
	else:
		time_remaining = 0.0

func _on_timer_timeout() -> void:
	if game_over:
		return 
	if still_alive:
		game_over = true
		label.text = "You won!"
		panel.visible = true
		if Zombielandglobal.diff >= 7:
			nextlevel.visible = false
		else:
			nextlevel.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		stop_game()

func _on_player_player_died() -> void:
	if game_over:
		return  # Prevent processing if the game is already over
	still_alive = false
	game_over = true
	panel.visible = true
	label.text = "Lost!"
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	stop_game()

func stop_game() -> void:
	# Stops player and enemy processing and freezes everything
	timer.stop()
	player.set_physics_process(false)
	player.set_process(false)
	player.set_process_unhandled_input(false)
	player.velocity = Vector3.ZERO
	stop_enemy_processes()
	# Stop all spawners
	spawner.get_node("Timer").stop()

func stop_enemy_processes() -> void:
	for enemy in enemyhandler.get_children():
		if enemy is CharacterBody3D:  # Check if it's a CharacterBody3D
			enemy.set_physics_process(false)  # Stops physics processing
			enemy.set_process(false)          # Stops logic processing
			enemy.velocity = Vector3.ZERO     # Ensures they stop moving
			var animation_player = enemy.get_node_or_null("AnimationPlayer")
			if animation_player:
				animation_player.stop()  # Stops the current animation

func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var remaining_seconds = int(seconds) % 60
	return "Survive time: %02d:%02d" % [minutes, remaining_seconds]

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_nextlevel_pressed() -> void:
	if Zombielandglobal.diff < 7:
		Zombielandglobal.diff +=2
		get_tree().reload_current_scene()

func _on_gameselect_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameselect.tscn")
