extends CanvasLayer
@onready var money: Label = $VBoxContainer/money
@onready var warning: Label = $Warning
@onready var warning_timer: Timer = $WarningTimer
@onready var goal: ProgressBar = $VBoxContainer/ProgressBar
@onready var goalcheck: Label = $VBoxContainer/ProgressBar/goalcheck
@onready var reward: Label = $VBoxContainer/ProgressBar/Reward

var save_file = "user://save_game.save"
var current_goal = 1000  # Initial goal
var automatic_farm_index = 0  # Track which farm becomes automatic
var automatic_farms = []  # List to hold automatic farms

@onready var farms = {
	"farm1": {
		"progress": $VBoxContainer/HBoxContainer/VBoxContainer/farm1/progress,
		"timer": $VBoxContainer/HBoxContainer/VBoxContainer/farm1/Timer1,
		"nextup": $VBoxContainer/HBoxContainer/VBoxContainer/farm1/nextup,
		"costlabel": $VBoxContainer/HBoxContainer/VBoxContainer/farm1/buy1/Label,
		"farmcost": $VBoxContainer/HBoxContainer/VBoxContainer/farm1buy/cost,
		"income": $VBoxContainer/HBoxContainer/VBoxContainer/farm1/income,
		"time": $VBoxContainer/HBoxContainer/VBoxContainer/farm1/Label,
		"timer_duration": 0.04,
		"speed": 0.1,
		"cost": 1,
		"value": 1,
		"value_per_level": 1,
		"level_cost": 2.0,
		"current_level": 1,
		"max_level": 25,
		"is_progressing": false,
		"unlocked": false
	},
	"farm2": {
		"progress": $VBoxContainer/HBoxContainer/VBoxContainer/farm2/progress,
		"timer": $VBoxContainer/HBoxContainer/VBoxContainer/farm2/Timer2,
		"nextup": $VBoxContainer/HBoxContainer/VBoxContainer/farm2/nextup,
		"costlabel": $VBoxContainer/HBoxContainer/VBoxContainer/farm2/buy2/Label,
		"farmcost": $VBoxContainer/HBoxContainer/VBoxContainer/farm2buy/cost,
		"income": $VBoxContainer/HBoxContainer/VBoxContainer/farm2/income,
		"time": $VBoxContainer/HBoxContainer/VBoxContainer/farm2/Label,
		"timer_duration": 0.04,
		"speed": 0.05,
		"cost": 10,
		"value": 10,
		"value_per_level": 10,
		"level_cost": 20.0,
		"current_level": 1,
		"max_level": 25,
		"is_progressing": false,
		"unlocked": false
	},
	"farm3": {
		"progress": $VBoxContainer/HBoxContainer/VBoxContainer/farm3/progress,
		"timer": $VBoxContainer/HBoxContainer/VBoxContainer/farm3/Timer3,
		"nextup": $VBoxContainer/HBoxContainer/VBoxContainer/farm3/nextup,
		"costlabel": $VBoxContainer/HBoxContainer/VBoxContainer/farm3/buy3/Label,
		"farmcost": $VBoxContainer/HBoxContainer/VBoxContainer/farm3buy/cost,
		"income": $VBoxContainer/HBoxContainer/VBoxContainer/farm3/income,
		"time": $VBoxContainer/HBoxContainer/VBoxContainer/farm3/Label,
		"timer_duration": 0.04,
		"speed": 0.025,
		"cost": 20,
		"value": 20,
		"value_per_level": 20,
		"level_cost": 40.0,
		"current_level": 1,
		"max_level": 25,
		"is_progressing": false,
		"unlocked": false
	},
	"farm4": {
		"progress": $VBoxContainer/HBoxContainer/VBoxContainer/farm4/progress,
		"timer": $VBoxContainer/HBoxContainer/VBoxContainer/farm4/Timer4,
		"nextup": $VBoxContainer/HBoxContainer/VBoxContainer/farm4/nextup,
		"costlabel": $VBoxContainer/HBoxContainer/VBoxContainer/farm4/buy4/Label,
		"farmcost": $VBoxContainer/HBoxContainer/VBoxContainer/farm4buy/cost,
		"income": $VBoxContainer/HBoxContainer/VBoxContainer/farm4/income,
		"time": $VBoxContainer/HBoxContainer/VBoxContainer/farm4/Label,
		"timer_duration": 0.04,
		"speed": 0.0125,
		"value": 100,
		"cost": 100,
		"value_per_level": 100,
		"level_cost": 250.0,
		"current_level": 1,
		"max_level": 25,
		"is_progressing": false,
		"unlocked": false
	},
	"farm5": {
		"progress": $VBoxContainer/HBoxContainer/VBoxContainer/farm5/progress,
		"timer": $VBoxContainer/HBoxContainer/VBoxContainer/farm5/Timer5,
		"nextup": $VBoxContainer/HBoxContainer/VBoxContainer/farm5/nextup,
		"costlabel": $VBoxContainer/HBoxContainer/VBoxContainer/farm5/buy5/Label,
		"farmcost": $VBoxContainer/HBoxContainer/VBoxContainer/farm5buy/cost,
		"income": $VBoxContainer/HBoxContainer/VBoxContainer/farm5/income,
		"time": $VBoxContainer/HBoxContainer/VBoxContainer/farm5/Label,
		"timer_duration": 0.04,
		"speed": 0.00625,
		"value": 250,
		"cost": 250,
		"value_per_level": 250,
		"level_cost": 500.0,
		"current_level": 1,
		"max_level": 25,
		"is_progressing": false,
		"unlocked": false
	},
	"farm6": {
		"progress": $VBoxContainer/HBoxContainer/VBoxContainer2/farm6/progress,
		"timer": $VBoxContainer/HBoxContainer/VBoxContainer2/farm6/Timer6,
		"nextup": $VBoxContainer/HBoxContainer/VBoxContainer2/farm6/nextup,
		"costlabel": $VBoxContainer/HBoxContainer/VBoxContainer2/farm6/buy6/Label,
		"farmcost": $VBoxContainer/HBoxContainer/VBoxContainer2/farm6buy/cost,
		"income": $VBoxContainer/HBoxContainer/VBoxContainer2/farm6/income,
		"time": $VBoxContainer/HBoxContainer/VBoxContainer2/farm6/Label,
		"timer_duration": 0.04,
		"speed": 0.003125,
		"value": 5000,
		"cost": 10000,
		"value_per_level": 5000,
		"level_cost": 10000.0,
		"current_level": 1,
		"max_level": 25,
		"is_progressing": false,
		"unlocked": false
	},
	"farm7": {
		"progress": $VBoxContainer/HBoxContainer/VBoxContainer2/farm7/progress,
		"timer": $VBoxContainer/HBoxContainer/VBoxContainer2/farm7/Timer7,
		"nextup": $VBoxContainer/HBoxContainer/VBoxContainer2/farm7/nextup,
		"costlabel": $VBoxContainer/HBoxContainer/VBoxContainer2/farm7/buy7/Label,
		"farmcost": $VBoxContainer/HBoxContainer/VBoxContainer2/farm7buy/cost,
		"income": $VBoxContainer/HBoxContainer/VBoxContainer2/farm7/income,
		"time": $VBoxContainer/HBoxContainer/VBoxContainer2/farm7/Label,
		"timer_duration": 0.04,
		"speed": 0.0015635,
		"value": 10000,
		"cost": 25000,
		"value_per_level": 10000,
		"level_cost": 25000.0,
		"current_level": 1,
		"max_level": 25,
		"is_progressing": false,
		"unlocked": false
	},
	"farm8": {
		"progress": $VBoxContainer/HBoxContainer/VBoxContainer2/farm8/progress,
		"timer": $VBoxContainer/HBoxContainer/VBoxContainer2/farm8/Timer8,
		"nextup": $VBoxContainer/HBoxContainer/VBoxContainer2/farm8/nextup,
		"costlabel": $VBoxContainer/HBoxContainer/VBoxContainer2/farm8/buy8/Label,
		"farmcost": $VBoxContainer/HBoxContainer/VBoxContainer2/farm8buy/cost,
		"income": $VBoxContainer/HBoxContainer/VBoxContainer2/farm8/income,
		"time": $VBoxContainer/HBoxContainer/VBoxContainer2/farm8/Label,
		"timer_duration": 0.08,
		"speed": 0.0015635,
		"value": 25000,
		"cost": 50000,
		"value_per_level": 25000,
		"level_cost": 50000.0,
		"current_level": 1,
		"max_level": 25,
		"is_progressing": false,
		"unlocked": false
	},
	"farm9": {
		"progress": $VBoxContainer/HBoxContainer/VBoxContainer2/farm9/progress,
		"timer": $VBoxContainer/HBoxContainer/VBoxContainer2/farm9/Timer9,
		"nextup": $VBoxContainer/HBoxContainer/VBoxContainer2/farm9/nextup,
		"costlabel": $VBoxContainer/HBoxContainer/VBoxContainer2/farm9/buy9/Label,
		"farmcost": $VBoxContainer/HBoxContainer/VBoxContainer2/farm9buy/cost,
		"income": $VBoxContainer/HBoxContainer/VBoxContainer2/farm9/income,
		"time": $VBoxContainer/HBoxContainer/VBoxContainer2/farm9/Label,
		"timer_duration": 0.16,
		"speed": 0.0015635,
		"value": 50000,
		"cost": 100000,
		"value_per_level": 50000,
		"level_cost": 100000.0,
		"current_level": 1,
		"max_level": 25,
		"is_progressing": false,
		"unlocked": false
	},
	"farm10": {
		"progress": $VBoxContainer/HBoxContainer/VBoxContainer2/farm10/progress,
		"timer": $VBoxContainer/HBoxContainer/VBoxContainer2/farm10/Timer10,
		"nextup": $VBoxContainer/HBoxContainer/VBoxContainer2/farm10/nextup,
		"costlabel": $VBoxContainer/HBoxContainer/VBoxContainer2/farm10/buy10/Label,
		"farmcost": $VBoxContainer/HBoxContainer/VBoxContainer2/farm10buy/cost,
		"income": $VBoxContainer/HBoxContainer/VBoxContainer2/farm10/income,
		"time": $VBoxContainer/HBoxContainer/VBoxContainer2/farm10/Label,
		"timer_duration": 0.32,
		"speed": 0.0015635,
		"value": 100000,
		"cost": 200000,
		"value_per_level": 100000,
		"level_cost": 200000.0,
		"current_level": 1,
		"max_level": 25,
		"is_progressing": false,
		"unlocked": false
	}
}
func save_game_state():
	var save_data = {
		"score": Farmglobal.score,
		"current_goal": current_goal,
		"automatic_farm_index": automatic_farm_index,
		"automatic_farms": automatic_farms,
		"farms": {}
	}
	
	for farm_name in farms.keys():
		var farm = farms[farm_name]
		save_data["farms"][farm_name] = {
			"current_level": farm["current_level"],
			"value": farm["value"],
			"value_per_level": farm["value_per_level"],
			"speed": farm["speed"],
			"max_level": farm["max_level"],
			"level_cost": farm["level_cost"],
			"unlocked": farm["unlocked"],
			"progress": farm["progress"].value
		}
	
	var file = FileAccess.open(save_file, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()
		
func load_game_state():
	if FileAccess.file_exists(save_file):
		var file = FileAccess.open(save_file, FileAccess.READ)
		if file:
			var save_data = file.get_var() 
			file.close()
			# Restore global score and goal
			Farmglobal.score = save_data.get("score", 5)  
			current_goal = save_data.get("current_goal", 1000)  
			automatic_farm_index = save_data.get("automatic_farm_index", 0)
			automatic_farms = save_data.get("automatic_farms", [])
			# Restore farm states
			for farm_name in farms.keys():
				if farm_name in save_data["farms"]:
					var saved_farm = save_data["farms"][farm_name]
					var farm = farms[farm_name]
					farm["current_level"] = saved_farm.get("current_level", 1)
					farm["value"] = saved_farm.get("value", farm["value"])
					farm["value_per_level"] = saved_farm.get("value_per_level", farm["value_per_level"])
					farm["speed"] = saved_farm.get("speed", farm["speed"])
					farm["max_level"] = saved_farm.get("max_level", farm["max_level"])
					farm["level_cost"] = saved_farm.get("level_cost", farm["level_cost"])
					farm["progress"].value = saved_farm.get("progress", 0)
					farm["unlocked"] = saved_farm.get("unlocked", false)
					# Unlock the farm if it was previously unlocked
					if farm["unlocked"]:
						unlock_farm(farm_name)
					_update_farm_labels(farm)
		else:
			print("Failed to open save file!")
	else:
		Farmglobal.score = 5
		print("No save data found!")
func _ready():
	load_game_state()
	for farm in farms.values():
		farm["nextup"].text =  str(farm["current_level"]) + "/" + str(farm["max_level"])
		farm["costlabel"].text = str(farm["level_cost"]).pad_decimals(2)
		if "farmcost" in farm:
			farm["farmcost"].text = str(farm["cost"]).pad_decimals(2)
	for farm_name in farms.keys():
		# Update the UI based on the saved unlock state
		if farms[farm_name]["unlocked"]:
			update_farm_ui(farm_name)
	goal.max_value = current_goal
		
func _process(delta: float) -> void:
	_update_score_display()
	_check_goal_progress()
	_run_automatic_farms(delta)
	if Engine.get_frames_drawn() % 300 == 0:  # Save every 5 seconds at 60 FPS
		save_game_state()
	
func _check_goal_progress():
	goal.max_value = current_goal
	goal.value = Farmglobal.score
	goalcheck.text = "Goal: " + str(Farmglobal.score).pad_decimals(2) + "/" + str(current_goal)
	update_reward_label()
	if Farmglobal.score >= current_goal:
		Farmglobal.score -= current_goal
		current_goal *= 2  # Double the goal
		goal.max_value = current_goal
		goal.value = 0
		make_next_farm_automatic()

func update_reward_label():
	# Determine reward based on the current state
	if automatic_farm_index < 10:
		# Next automatic farm
		reward.text = "Next reward: Unlock " + "farm" + str(automatic_farm_index + 1)
	else:
		# After all farms, provide speed x2 or time extension
		var reward_type = "Speed Boost x2" if automatic_farm_index % 2 == 0 else "All farms x1.5"
		reward.text = "Next reward: " + reward_type
			
func make_next_farm_automatic():
	if automatic_farm_index < 10:
		# Unlock the next farm
		var farm_names = farms.keys()
		if automatic_farm_index < farm_names.size():
			var farm_name = farm_names[automatic_farm_index]
			automatic_farms.append(farm_name)
			automatic_farm_index += 1
			$Warning.add_theme_color_override("font_color", Color.GREEN)
			show_warning(farm_name + " is now automatic!")
	else:
		# Alternate between speed boost and time extension
		if automatic_farm_index % 2 == 0:
			apply_speed_boost()
		else:
			apply_values()
		automatic_farm_index += 1

func apply_speed_boost():
	for farm in farms.values():
		farm["speed"] *= 2  # Double the speed
	$Warning.add_theme_color_override("font_color", Color.GREEN)
	show_warning("Speed Boost x2!")

func apply_values():
	for farm in farms.values():
		farm["value"] *= 1.5  
	$Warning.add_theme_color_override("font_color", Color.GREEN)
	show_warning("All farms incomes multiplied by 1.5!")
	
func _run_automatic_farms(delta: float):
	for farm_name in automatic_farms:
		var farm = farms[farm_name]
		# Check if the farm is unlocked before starting progress
		if farm["unlocked"] and not farm["is_progressing"]:
			start_farm_progress(farm_name)

func show_warning(message: String):
	warning.text = message
	warning.visible = true
	warning_timer.start(2)  

func _on_warning_timer_timeout():
	warning.visible = false	
	
func _update_score_display() -> void:
	money.text = "Money: " + str(Farmglobal.score).pad_decimals(2) + " $"

func _update_farm_labels(farm: Dictionary) -> void:
	# Update income label to show money earned per progress
	farm["income"].text = "Earn: " + str(farm["value"]).pad_decimals(2) + " $"
	# Update time label to show time to earn money
	var time_to_earn = farm["timer_duration"] * (farm["progress"].max_value / farm["speed"])
	farm["time"].text = "Time: " + str(time_to_earn).pad_decimals(2) + " s"

func start_farm_progress(farm_name: String):
	var farm = farms[farm_name]
	if not farm["is_progressing"]:
		farm["is_progressing"] = true
		farm["timer"].start(farm["timer_duration"])

	
func update_farm_progress(farm_name: String):
	var farm = farms[farm_name]
	if farm["progress"].value < farm["progress"].max_value:
		farm["progress"].value += farm["speed"]
		_update_time_label(farm)
	else:
		farm["progress"].value = 0
		Farmglobal.score += farm["value"]
		farm["is_progressing"] = false
		farm["timer"].stop()
		_update_farm_labels(farm) 
		
func _update_time_label(farm: Dictionary):
	# Calculate remaining time based on progress
	var time_to_earn = farm["timer_duration"] * (farm["progress"].max_value / farm["speed"])
	var remaining_time = time_to_earn - (farm["timer_duration"] * ((farm["progress"].value / farm["speed"])))
	farm["time"].text = "Time: " + str(remaining_time).pad_decimals(2) + " s"

func purchase_upgrade(farm_name: String):
	var farm = farms[farm_name]
	if Farmglobal.score >= farm["level_cost"]:
		Farmglobal.score -= farm["level_cost"]
		if farm["current_level"] + 1 < farm["max_level"]:
			farm["current_level"] += 1
		else:
			farm["value_per_level"] *=2
			farm["value"] *= 2 
			farm["max_level"] *= 2
			farm["current_level"] += 1
		farm["value"] = farm["current_level"] * farm["value_per_level"]
		farm["level_cost"] *= 1.1
		farm["costlabel"].text = str(farm["level_cost"]).pad_decimals(2)
		farm["nextup"].text = str(farm["current_level"]) + "/" + str(farm["max_level"])
		_update_farm_labels(farm) 
		_update_time_label(farm)
	else:
		$Warning.add_theme_color_override("font_color", Color.RED)
		show_warning("Not enough score to buy the next level!")

func update_farm_ui(farm_name: String) -> void:
		var parent_path = "VBoxContainer/HBoxContainer/"
		if farm_name in ["farm6", "farm7", "farm8", "farm9", "farm10"]:
			parent_path += "VBoxContainer2"
		else:
			parent_path += "VBoxContainer"

		var farm_node = get_node(parent_path).get_node(farm_name)
		farm_node.visible = true
		
		var button_name = farm_name + "buy" 
		var button_node = get_node(parent_path + "/" + button_name) 
		button_node.visible = false
		button_node.disabled = true
		
func unlock_farm(farm_name: String) -> void:
	# Check if the farm is not already unlocked
	var farm = farms[farm_name]
	if farm["unlocked"]:
		return
	# Check if the player has enough money to unlock the farm
	if Farmglobal.score >= farm["cost"]:  # Check if player has enough score
		# Deduct the money
		Farmglobal.score -= farm["cost"]

		# Unlock the farm and make it visible
		farm["unlocked"] = true
		var parent_path = "VBoxContainer/HBoxContainer/"
		if farm_name in ["farm6", "farm7", "farm8", "farm9", "farm10"]:
			parent_path += "VBoxContainer2"
		else:
			parent_path += "VBoxContainer"

		var farm_node = get_node(parent_path).get_node(farm_name)
		farm_node.visible = true
		
		var button_name = farm_name + "buy" 
		var button_node = get_node(parent_path + "/" + button_name) 
		button_node.visible = false
		button_node.disabled = true
		_update_farm_labels(farm) 
		$Warning.add_theme_color_override("font_color", Color.GREEN)
		show_warning("Farm unlocked!")
	else:
		$Warning.add_theme_color_override("font_color", Color.RED)
		show_warning("Not enough money to unlock farm!")
	
# Function to handle button presses for unlocking farms
func _on_farm_1_buy_pressed() -> void:
	var farm_name = "farm1"
	unlock_farm(farm_name)
func _on_farm_2_buy_pressed() -> void:
	var farm_name = "farm2"
	unlock_farm(farm_name)
func _on_farm_3_buy_pressed() -> void:
	var farm_name = "farm3"
	unlock_farm(farm_name)
func _on_farm_4_buy_pressed() -> void:
	var farm_name = "farm4"
	unlock_farm(farm_name)
func _on_farm_5_buy_pressed() -> void:
	var farm_name = "farm5"
	unlock_farm(farm_name)
func _on_farm_6_buy_pressed() -> void:
	var farm_name = "farm6"
	unlock_farm(farm_name)
func _on_farm_7_buy_pressed() -> void:
	var farm_name = "farm7"
	unlock_farm(farm_name)
func _on_farm_8_buy_pressed() -> void:
	var farm_name = "farm8"
	unlock_farm(farm_name)
func _on_farm_9_buy_pressed() -> void:
	var farm_name = "farm9"
	unlock_farm(farm_name)
func _on_farm_10_buy_pressed() -> void:
	var farm_name = "farm10"
	unlock_farm(farm_name)
	
func _on_farm_1_pressed() -> void:
	start_farm_progress("farm1")
func _on_timer_1_timeout() -> void:
	update_farm_progress("farm1")
func _on_buy_1_pressed() -> void:
	purchase_upgrade("farm1")
func _on_farm_2_pressed() -> void:
	start_farm_progress("farm2")
func _on_timer_2_timeout() -> void:
	update_farm_progress("farm2")
func _on_buy_2_pressed() -> void:
	purchase_upgrade("farm2")
func _on_farm_3_pressed() -> void:
	start_farm_progress("farm3")
func _on_timer_3_timeout() -> void:
	update_farm_progress("farm3")
func _on_buy_3_pressed() -> void:
	purchase_upgrade("farm3")
func _on_farm_4_pressed() -> void:
	start_farm_progress("farm4")
func _on_timer_4_timeout() -> void:
	update_farm_progress("farm4")
func _on_buy_4_pressed() -> void:
	purchase_upgrade("farm4")
func _on_farm_5_pressed() -> void:
	start_farm_progress("farm5")
func _on_timer_5_timeout() -> void:
	update_farm_progress("farm5")
func _on_buy_5_pressed() -> void:
	purchase_upgrade("farm5")
func _on_farm_6_pressed() -> void:
	start_farm_progress("farm6")
func _on_timer_6_timeout() -> void:
	update_farm_progress("farm6")
func _on_buy_6_pressed() -> void:
	purchase_upgrade("farm6")
func _on_farm_7_pressed() -> void:
	start_farm_progress("farm7")
func _on_timer_7_timeout() -> void:
	update_farm_progress("farm7")
func _on_buy_7_pressed() -> void:
	purchase_upgrade("farm7")
func _on_farm_8_pressed() -> void:
	start_farm_progress("farm8")
func _on_timer_8_timeout() -> void:
	update_farm_progress("farm8")
func _on_buy_8_pressed() -> void:
	purchase_upgrade("farm8")
func _on_farm_9_pressed() -> void:
	start_farm_progress("farm9")
func _on_timer_9_timeout() -> void:
	update_farm_progress("farm9")
func _on_buy_9_pressed() -> void:
	purchase_upgrade("farm9")
func _on_farm_10_pressed() -> void:
	start_farm_progress("farm10")
func _on_timer_10_timeout() -> void:
	update_farm_progress("farm10")
func _on_buy_10_pressed() -> void:
	purchase_upgrade("farm10")
func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameselect.tscn")
