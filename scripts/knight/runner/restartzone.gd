extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	Engine.time_scale = 0.5
	var player_sprite = body.get_node("AnimatedSprite2D")
	player_sprite.play("death")
	body.get_node("CollisionShape2D").set_deferred("disabled", true)  
	body.set_physics_process(false) 
	timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/knight/runner/restart.tscn")
	Autogame.score = 0
