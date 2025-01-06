extends Node2D
var elapsed_time = 0.0 
var timer_stopped = false
@onready var game_container: GridContainer = $GridContainer
@onready var numberpad: GridContainer = $SelectGrid
@onready var wronghits: Label = $wronghits
@onready var gamedone: Panel = $CanvasLayer/gamedone
@onready var winorlose: Label = $CanvasLayer/gamedone/winorlose
@onready var undo: Button = $HBoxContainer/Undo
@onready var errortimer: Timer = $errortimer
@onready var time: Label = $time
@onready var difficulty: Label = $difficulty
var SHOW_HINTS = true
var wrong_hits = 0
const MAX_WRONG_HITS = 3
# Sudoku Game Data
var game_board = []  # Holds the buttons displayed in the game
var puzzle_grid = []  # Contains the current puzzle
var completed_grid = []  # Stores the completed solution for the puzzle
var solution_variants = 0  # Tracks the number of solutions for validating unique grids
var move_history = []  # Tracks moves for undo
var number_count = {}
var active_cell: Vector2i = Vector2i(-1, -1)
var active_cell_solution = 0

const BOARD_SIZE = 9
func _ready():
	link_numberpad_actions()
	initialize_game()
	wronghits.text = "Mistakes: " + str(wrong_hits) + "/" + str(MAX_WRONG_HITS)
	update_undo_button()
	initialize_number_count()
	if Sudokuglobal.DIFFICULTY == 22: 
		difficulty.text = "Difficulty: Easy"
	if Sudokuglobal.DIFFICULTY == 33: 
		difficulty.text = "Difficulty: Medium"
	if Sudokuglobal.DIFFICULTY == 44: 
		difficulty.text = "Difficulty: Hard"

func _process(delta: float) -> void:
	if not timer_stopped:
		elapsed_time += delta
		update_score_display()
		
func update_score_display():
	time.text = format_time(elapsed_time)
	
func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var secondsm = int(seconds) % 60
	return "Time: %02d:%02d" % [minutes, secondsm]
	
func initialize_number_count():
	number_count.clear()
	for i in range(1, 10):
		number_count[i] = 9  # Each number can appear at most 9 times
	# Subtract the occurrences already present in the puzzle
	for row in puzzle_grid:
		for value in row:
			if value != 0:
				number_count[value] -= 1
	update_numberpad_buttons()

func update_numberpad_buttons():
	for number_button in numberpad.get_children():
		var btn = number_button as Button
		var num = int(btn.text)
		btn.disabled = number_count[num] <= 0
		if btn.disabled:
			btn.visible = false
# Initialize the Sudoku game
func initialize_game():
	create_empty_board()
	generate_solution(completed_grid)
	create_puzzle()
	populate_game_board()

# Populate the grid container with buttons
func populate_game_board():
	game_board = []
	for row in range(BOARD_SIZE):
		var button_row = []
		for col in range(BOARD_SIZE):
			button_row.append(add_cell(Vector2i(row, col)))
		game_board.append(button_row)

func add_cell(pos: Vector2i):
	var row = pos.x
	var col = pos.y
	var solution_value = completed_grid[row][col]
	
	var cell_button = Button.new()
	if puzzle_grid[row][col] != 0:
		cell_button.text = str(puzzle_grid[row][col])
		cell_button.disabled = true 
		var empty_style = StyleBoxFlat.new()  
		cell_button.add_theme_stylebox_override("focus", empty_style)
		cell_button.add_theme_stylebox_override("hover", empty_style)
	else:
		cell_button.pressed.connect(on_cell_clicked.bind(pos, solution_value))  
	
	cell_button.set("theme_override_font_sizes/font_size", 32)
	cell_button.custom_minimum_size = Vector2(52, 52)
	
	game_container.add_child(cell_button)
	return cell_button

# Handle cell click event
func on_cell_clicked(pos: Vector2i, solution_value):
	active_cell = pos
	active_cell_solution = solution_value  # Tracks the correct answer for the selected cell

# Link number pad buttons to actions
func link_numberpad_actions():
	for number_button in numberpad.get_children():
		var btn = number_button as Button
		btn.pressed.connect(on_numberpad_button_pressed.bind(int(btn.text)))

# Handle number pad input
func on_numberpad_button_pressed(selected_number):
	if active_cell != Vector2i(-1, -1):
		var target_cell = game_board[active_cell.x][active_cell.y]
		var previous_value = target_cell.text.to_int()

		# Restore the count for the previous value if it was valid
		if previous_value != 0:
			number_count[previous_value] += 1  

		# Check if the input is correct
		var correct_match = (selected_number == active_cell_solution)
		if correct_match:
			target_cell.text = str(selected_number)
			number_count[selected_number] -= 1  # Decrement count only for correct numbers

			# Record the move and update buttons
			record_move(active_cell.x, active_cell.y, previous_value, selected_number)
		else:
			# Visual feedback for wrong numbers
			wrong_hits += 1
			wronghits.text = "Mistakes: " + str(wrong_hits) + "/" + str(MAX_WRONG_HITS)
			if wrong_hits >= MAX_WRONG_HITS:
				game_over()
				return
			if SHOW_HINTS:
				var style: StyleBoxFlat = target_cell.get_theme_stylebox("normal").duplicate(true)
				style.bg_color = Color.RED
				target_cell.add_theme_stylebox_override("normal", style)

				errortimer.start()

		update_numberpad_buttons()

		if is_puzzle_solved():
			puzzle_solved()



# Record moves for undo/redo
func record_move(row, col, previous_value, new_value):
	move_history.append({"row": row, "col": col, "prev": previous_value, "new": new_value})
	update_undo_button()

# Undo the last move
func undo_move():
	if move_history.size() > 0:
		var last_move = move_history.pop_back()
		var row = last_move.row
		var col = last_move.col
		var prev_value = last_move.prev

		if prev_value != 0:
			number_count[prev_value] -= 1  # Decrement the count for the previous value
		
		if prev_value != 0:
			game_board[row][col].text = str(prev_value)
		else:
			game_board[row][col].text = ""
		
		update_numberpad_buttons()
		update_undo_button()

func update_undo_button():
	undo.disabled = move_history.size() == 0
	
# Create an empty board
func create_empty_board():
	completed_grid = []
	for row in range(BOARD_SIZE):
		var empty_row = []
		for col in range(BOARD_SIZE):
			empty_row.append(0)
		completed_grid.append(empty_row)

# Generate a valid Sudoku solution
func generate_solution(grid_data):
	for row in range(BOARD_SIZE):
		for col in range(BOARD_SIZE):
			if grid_data[row][col] == 0:
				var candidates = [1, 2, 3, 4, 5, 6, 7, 8, 9]
				candidates.shuffle()
				for value in candidates:
					if is_entry_valid(grid_data, row, col, value):
						grid_data[row][col] = value
						if generate_solution(grid_data):
							return true
						grid_data[row][col] = 0
				return false
	return true

func is_entry_valid(board_data, row, col, value):
	return (
		value not in board_data[row] and 
		value not in get_column_values(board_data, col) and 
		value not in get_subgrid_values(board_data, row, col)
	)

func get_column_values(board_data, col):
	var column_entries = []
	for row in range(BOARD_SIZE):
		column_entries.append(board_data[row][col])
	return column_entries

func get_subgrid_values(board_data, row, col):
	var subgrid_entries = []
	var start_row = (row / 3) * 3
	var start_col = (col / 3) * 3
	for r in range(start_row, start_row + 3):
		for c in range(start_col, start_col + 3):
			subgrid_entries.append(board_data[r][c])
	return subgrid_entries

# Create a puzzle by removing numbers
func create_puzzle():
	puzzle_grid = completed_grid.duplicate(true)
	var cells_to_remove = Sudokuglobal.DIFFICULTY
	while cells_to_remove > 0:
		var row = randi_range(0, 8)
		var col = randi_range(0, 8)
		if puzzle_grid[row][col] != 0:
			var saved_value = puzzle_grid[row][col]
			puzzle_grid[row][col] = 0
			if not puzzle_has_unique_solution(puzzle_grid):
				puzzle_grid[row][col] = saved_value
			else:
				cells_to_remove -= 1

func puzzle_has_unique_solution(puzzle_board):
	solution_variants = 0
	attempt_solve_puzzle(puzzle_board)
	return solution_variants == 1

func attempt_solve_puzzle(puzzle_board):
	for row in range(BOARD_SIZE):
		for col in range(BOARD_SIZE):
			if puzzle_board[row][col] == 0:
				for value in range(1, 10):
					if is_entry_valid(puzzle_board, row, col, value):
						puzzle_board[row][col] = value
						attempt_solve_puzzle(puzzle_board)
						puzzle_board[row][col] = 0
				return
	solution_variants += 1
	if solution_variants > 1:
		return
func is_puzzle_solved() -> bool:
	for row in range(BOARD_SIZE):
		for col in range(BOARD_SIZE):
			if game_board[row][col].text.to_int() != completed_grid[row][col]:
				return false
	return true
	
func puzzle_solved():
	# Disable all interactions
	for row in game_board:
		for cell in row:
			cell.disabled = true
	undo.visible = false
	winorlose.text = "You won!"  # Display a victory message
	gamedone.visible = true  # Show the end game panel
	timer_stopped = true

func game_over():
	# Disable all interactions
	for row in game_board:
		for cell in row:
			cell.disabled = true
	for number_button in numberpad.get_children():
		var btn = number_button as Button
		if btn:
			btn.disabled = true 	
			var normal_style = StyleBoxFlat.new()
			normal_style.bg_color = Color(0, 0, 0, 0)  # Set a normal-looking background	
			btn.add_theme_stylebox_override("disabled", normal_style)
	winorlose.text = "You lost!"
	gamedone.visible = true
	undo.visible = false
	timer_stopped = true

func _on_undo_pressed() -> void:
	undo_move()

func _on_restart_pressed() -> void:
	elapsed_time = 0.0
	timer_stopped = false
	get_tree().reload_current_scene()

func _on_choosediff_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sudoku/sudokudiff.tscn")

func _on_gamemenu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameselect.tscn")

func _on_errortimer_timeout() -> void:
	if active_cell != Vector2i(-1, -1):
		var target_cell = game_board[active_cell.x][active_cell.y]
		target_cell.remove_theme_stylebox_override("normal")
