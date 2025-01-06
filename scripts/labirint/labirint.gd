extends Node3D
@onready var finishtime: Timer = $finishtime
@onready var label: Label = $Label
var elapsed_time = 0.0 
var timer_stopped = false
@onready var capsules: Node3D = $capsules
@onready var orbs: Node3D = $orbs
@onready var cubes: Node3D = $cubes
var totalcapsules= 0 
var capsules_collected = 0
var totalorbs= 0 
var orbs_collected = 0 # for scoreboard
var totalcubes= 0 
var cubes_collected = 0
var orbcollected = 0 
var cubecollected = 0 
var capsulecollected = 0 
@onready var capsule: Label = $capsule
@onready var collectedcap: Label = $Collectedcap
@onready var orb: Label = $Orbs
@onready var collectedorbs: Label = $Collectedorbs
@onready var cube: Label = $Cubes
@onready var collectedcubes: Label = $Collectedcubes
@onready var record: Label = $Record
@onready var warning: Label = $warning
@onready var warningtimer: Timer = $warningtimer
@onready var lives: Label = $Lives
var save_file = "user://labirint_save_game.save"
var record_score = 0
var is_reloading_scene = false  
var persons_lives = 0 
@onready var panel: Panel = $CanvasLayer/panel
@onready var gameov: Label = $CanvasLayer/panel/Label
@onready var nextlevel: Button = $CanvasLayer/panel/VBoxContainer/nextlevel
@onready var player: CharacterBody3D = $Player
var finishtimet = 0.0
func _ready() -> void:
	persons_lives = Labirintscore.lives
	is_reloading_scene = false
	load_game_state()
	totalcapsules = capsules.get_child_count()
	totalorbs = orbs.get_child_count()
	totalcubes = cubes.get_child_count()
func save_game_state():
	if elapsed_time > 0:  
		var save_data = {}
		if FileAccess.file_exists(save_file):
			var file = FileAccess.open(save_file, FileAccess.READ)
			if file:
				save_data = file.get_var()
				file.close()
		var lives_key = "lives_" + str(Labirintscore.lives)
		var current_best_time = save_data.get(lives_key, null)
		if current_best_time == null or elapsed_time < current_best_time:
			save_data[lives_key] = elapsed_time
		var file = FileAccess.open(save_file, FileAccess.WRITE)
		if file:
			file.store_var(save_data)
			file.close()
		else:
			print("Failed to save game state!")

func load_game_state():
	if FileAccess.file_exists(save_file):
		var file = FileAccess.open(save_file, FileAccess.READ)
		if file:
			var save_data = file.get_var()
			file.close()
			# Define the key based on the current lives
			var lives_key = "lives_" + str(Labirintscore.lives)
			finishtimet = save_data.get(lives_key, null)
			# If no record exists, initialize it to 0
			if finishtimet == float("inf"):
				finishtimet = 0.0
		else:
			print("Failed to open save file!")
	else:
		print("No save data found!")

func _physics_process(delta: float) -> void:
	 # Update elapsed time only if the timer isn't stopped
	if not timer_stopped:
		elapsed_time += delta
		update_score_display()
	check_game_over()
	if persons_lives == 0: # Different levels means different live count !!!
		gameov.text = "Game over!"
		showpanel()

func check_game_over() -> void:
	# Calculate remaining collectibles for each type
	var remaining_capsules = totalcapsules - capsulecollected 
	var remaining_orbs = totalorbs - orbcollected 
	var remaining_cubes = totalcubes - cubecollected
	# Check if it's impossible to collect 3 of any type
	if (capsules_collected + remaining_capsules < 3 or
		orbs_collected + remaining_orbs < 3 or
		cubes_collected + remaining_cubes < 3):
		# Trigger game over if the win condition is unreachable
		gameov.text = "Game over!"
		showpanel()

func update_score_display():
	var display_time = finishtimet
	if finishtimet == null:
		display_time = 0.0
	var seconds = floor(elapsed_time)
	var milliseconds = int((elapsed_time - seconds) * 100)  
	label.text = "Time: " + str(seconds) + "." + str(milliseconds).pad_zeros(2) + " sec"
	capsule.text = "Collect capsules: " + str(totalcapsules - 1)
	collectedcap.text = "Collected capsules: " + str(capsules_collected)
	orb.text = "Collect orbs: " + str(totalorbs - 1)
	collectedorbs.text = "Collected orbs: " + str(orbs_collected)
	cube.text = "Collect cubes: " + str(totalcubes - 1)
	collectedcubes.text = "Collected cubes: " + str(cubes_collected)
	lives.text = "Lives: " + str(persons_lives)
	record.text = "Record: " + str(display_time).pad_decimals(2) + " sec"
	
func _on_player_playertime() -> void:
	if capsules_collected >= totalcapsules-1 and orbs_collected >= totalorbs-1 and cubes_collected >= totalcubes-1:
		timer_stopped = true
		gameov.text = "You won!"
		if Labirintscore.lives == 3: 
			nextlevel.visible = false
		else:
			nextlevel.visible = true
		showpanel()
		save_game_state()
	else: 
		if capsules_collected < totalcapsules-1 and orbs_collected >= totalorbs-1 and cubes_collected >= totalcubes-1:
			show_warning("Collect capsules!")
		if capsules_collected < totalcapsules-1 and orbs_collected < totalorbs-1 and cubes_collected >= totalcubes-1:
			show_warning("Collect orbs and capsules!")
		if capsules_collected < totalcapsules-1 and orbs_collected < totalorbs-1 and cubes_collected < totalcubes-1: 
			show_warning("Collect capsules, orbs and cubes!")
		if capsules_collected < totalcapsules-1 and orbs_collected >= totalorbs-1 and cubes_collected < totalcubes-1: 
			show_warning("Collect capsules and cubes!")
		if capsules_collected >= totalcapsules-1 and orbs_collected < totalorbs-1 and cubes_collected < totalcubes-1: 
			show_warning("Collect orbs and cubes!")	
		if capsules_collected >= totalcapsules-1 and orbs_collected >= totalorbs-1 and cubes_collected < totalcubes-1: 
			show_warning("Collect cubes!")
		if capsules_collected >= totalcapsules-1 and orbs_collected < totalorbs-1 and cubes_collected >= totalcubes-1: 
			show_warning("Collect orbs!")
		
func _on_player_capsule() -> void:
	capsules_collected +=1
	capsulecollected +=1
	check_game_over()
	
func _on_player_negativcapsule() -> void:
	if capsules_collected > 0: 
		capsules_collected -=1
		show_warning("Collected wrong capsule! Minus 1 point!")
	else: 
		if persons_lives > 0:
			persons_lives -=1
			show_warning("Collected wrong capsule! Minus 1 live")
	check_game_over()
	
func _on_player_orb() -> void:
	orbs_collected +=1
	orbcollected +=1
	check_game_over()

func _on_player_negativorb() -> void:
	if orbs_collected > 0: 
		orbs_collected -=1
		show_warning("Collected wrong orb! Minus 1 point!")
	else: 
		if persons_lives > 0:
			persons_lives -=1
			show_warning("Collected wrong orb! Minus 1 live")
	check_game_over()

func _on_player_cube() -> void:
	cubes_collected +=1
	cubecollected +=1
	check_game_over()
	
func _on_player_negativcube() -> void:
	if cubes_collected > 0: 
		cubes_collected -=1
		show_warning("Collected wrong cube! Minus 1 point!")
	else: 
		if persons_lives > 0:
			persons_lives -=1
			show_warning("Collected wrong cube! Minus 1 live")
	check_game_over()

func show_warning(message: String):
	warning.text = message
	warning.visible = true
	warningtimer.start(2)  

func _on_warningtimer_timeout() -> void:
	warning.visible = false

func showpanel():
	panel.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	player.set_physics_process(false)
	player.set_process(false)
	player.set_process_unhandled_input(false)

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_nextlevel_pressed() -> void:
	if Labirintscore.lives >3:
		Labirintscore.lives -=1
		get_tree().reload_current_scene()

func _on_gameselect_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameselect.tscn")
