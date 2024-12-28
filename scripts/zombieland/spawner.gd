extends Node3D

@onready var zombie = preload("res://scenes/zombieland/zombie.tscn")
@onready var timer: Timer = $Timer
@onready var enemy_handler: Node3D = get_parent_node_3d().get_node("Enemyhandler")

var spawner_positions: Array = [
	Vector3(31.1767, 0, 25.5844),
	Vector3(-16.7318, 0, -4.78992),
	Vector3(-35.8081, 0, -8.75638),
	Vector3(-38.4192, 0, 10.0295),
	Vector3(23.5964, 0, -28.8781)
]
var current_position_index: int = 0
var zombie_count: int = 0
const MAX_ZOMBIES = 50
const SWITCH_SPAWN_COUNT = 10

func _ready() -> void:
	randomize()
	position = spawner_positions[current_position_index]
	timer.wait_time = 1.0
	timer.start()

func _on_timer_timeout() -> void:
	if enemy_handler.get_child_count() < MAX_ZOMBIES:
		var enemy = zombie.instantiate()
		enemy.position = position + random_offset()  
		enemy_handler.add_child(enemy)
		zombie_count += 1
		if zombie_count >= SWITCH_SPAWN_COUNT:
			zombie_count = 0
			switch_spawner_position()
	timer.wait_time = max(0.1, timer.wait_time - (0.01 * Zombielandglobal.diff))
	timer.start()

func random_offset() -> Vector3:
	const RANDOM_OFFSET = 2.0
	return Vector3(
		randf_range(-RANDOM_OFFSET, RANDOM_OFFSET),
		0,
		randf_range(-RANDOM_OFFSET, RANDOM_OFFSET)
	)

func switch_spawner_position() -> void:
	# Cycle to the next spawner position
	current_position_index = (current_position_index + 1) % spawner_positions.size()
	position = spawner_positions[current_position_index]
