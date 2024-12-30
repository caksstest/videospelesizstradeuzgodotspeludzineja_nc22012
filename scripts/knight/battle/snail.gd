extends CharacterBody2D

signal defeated
var hitpoints = 250
var speed = 50
var chase = false
var player = null
@onready var snail_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var attack = false
var close = false
var dead = false
const SAFE_DISTANCE = 15
@onready var snailhealth: ProgressBar = $ProgressBar
@onready var timer: Timer = $ProgressBar/Timer

func _physics_process(delta: float) -> void:
	if snail_sprite_2d.animation == "hide":
		return 
	if chase:
		var direction = player.position - position
		if direction.length() > SAFE_DISTANCE: 
			position += direction.normalized() * speed * delta
			snail_sprite_2d.play("walk")
			snail_sprite_2d.flip_h = direction.x > 0
		else:
			velocity = Vector2.ZERO
			snail_sprite_2d.play("attack")
	else:
		snail_sprite_2d.play("idle")
		velocity = Vector2.ZERO
	move_and_slide()
	snailhealthbar()
	
func take_damage1() -> void:
	if attack and Fighter.playerattack:
		hitpoints -= 120
		snailhealthbar()
		snail_sprite_2d.play("hide")
		timer.stop()  
		timer.start()
		if hitpoints <= 0:
			hitpoints = 0
			emit_signal("defeated")
			self.queue_free()
			
func take_damage2() -> void:
	if attack and Fighter.playerattack:
		hitpoints -= 150
		snailhealthbar()
		snail_sprite_2d.play("hide")
		timer.stop()  
		timer.start()
		if hitpoints <= 0:
			hitpoints = 0
			emit_signal("defeated")
			self.queue_free()
			
func take_damage3() -> void:
	if attack and Fighter.playerattack:
		hitpoints -= 120
		snailhealthbar()
		snail_sprite_2d.play("hide")
		timer.stop()  
		timer.start()
		if hitpoints <= 0:
			hitpoints = 0
			emit_signal("defeated")
			self.queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	if snail_sprite_2d.animation == "hide":
		snail_sprite_2d.play("idle")
	
func _on_rangefollow_body_entered(body: Node2D) -> void:
	if body.is_in_group("playerr"):
		player = body
		chase = true

func _on_rangefollow_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		chase = false

func _on_snailbody_area_entered(area: Area2D) -> void:
	if area.is_in_group("sword1"):
		attack = true
		take_damage1()
		timer.start()
	if area.is_in_group("sword2"):
		attack = true
		take_damage2()
		timer.start()
	if area.is_in_group("sword3"):
		attack = true
		take_damage3()
		timer.start()

func _on_snailbody_area_exited(area: Area2D) -> void:
	if area.is_in_group("sword1"):
		attack = false
	if area.is_in_group("sword2"):
		attack = false
	if area.is_in_group("sword3"):
		attack = false
		
func snailhealthbar() -> void: 
	snailhealth.value = hitpoints
	
func _on_timer_timeout() -> void:
	if hitpoints < 250: 
		hitpoints = hitpoints + 25
		if hitpoints > 250: 
			hitpoints = 250
	if hitpoints <= 0: 
		hitpoints = 0 
