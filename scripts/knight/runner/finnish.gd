extends Area2D
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.call("on_player_finished")
		timer.wait_time = 2.5
		timer.start()
		
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/knight/runner/gamedone.tscn")
