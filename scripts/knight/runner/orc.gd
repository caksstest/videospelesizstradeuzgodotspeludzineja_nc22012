extends Node2D

@onready var left: RayCast2D = $Left
@onready var right: RayCast2D = $Right
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $restartzone/CollisionShape2D
const speed = 30
var dead = false
var dir = 1 
func _process(delta: float) -> void:
	if dead == false: 
		if right.is_colliding():
			dir = -1
			animated_sprite_2d.flip_h = true
		if left.is_colliding():
			dir = 1
			animated_sprite_2d.flip_h = false
		position.x += dir * speed * delta

func _on_orcbody_area_entered(area: Area2D) -> void:
	if area.is_in_group("sword") and not dead: 
		dead = true
		animated_sprite_2d.play("death")
		Autogame.score +=1
		collision_shape_2d.call_deferred("set_disabled", true)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "death":
		queue_free()
