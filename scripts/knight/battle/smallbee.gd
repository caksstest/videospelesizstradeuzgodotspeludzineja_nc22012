extends CharacterBody2D

signal defeated
var hitpoints = 500
var speed = 100
var chase = false
var player = null
@onready var bee_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var attack_cooldown = true
var attack = false
var close = false
var dead = false
@onready var beehealth: ProgressBar = $ProgressBar
@onready var timer: Timer = $ProgressBar/Timer
const SAFE_DISTANCE = 15 

func _physics_process(delta: float) -> void:
	if bee_sprite_2d.animation == "hit":
		return 
	if chase:
		var direction = player.position - position
		if direction.length() > SAFE_DISTANCE:  # Only move if farther than the safe distance
			position += direction.normalized() * speed * delta
			bee_sprite_2d.play("fly")
			bee_sprite_2d.flip_h = direction.x > 0
		else:
			velocity = Vector2.ZERO
			attack_player(direction) 
	else:
		bee_sprite_2d.play("fly")
		velocity = Vector2.ZERO
	move_and_slide()
	beehealthbar()
	
func attack_player(direction: Vector2) -> void:
	if not attack_cooldown:
		return
	attack_cooldown = false
	attack = true
	# Orient the attack animation toward the player
	bee_sprite_2d.play("attack")
	bee_sprite_2d.flip_h = direction.x > 0
	# Cooldown logic to prevent constant attacks
	attack_cooldown = true
	attack = false

func take_damage1() -> void:
	if attack and Fighter.playerattack:
		hitpoints -= 100
		beehealthbar()
		bee_sprite_2d.play("hit")
		timer.stop()  
		timer.start()
		if hitpoints <= 0:
			emit_signal("defeated")
			self.queue_free()
			
func take_damage2() -> void:
	if attack and Fighter.playerattack:
		hitpoints -= 150
		beehealthbar()
		bee_sprite_2d.play("hit")
		timer.stop()  
		timer.start()
		if hitpoints <= 0:
			emit_signal("defeated")
			self.queue_free()

func take_damage3() -> void:
	if attack and Fighter.playerattack:
		hitpoints -= 120
		beehealthbar()
		bee_sprite_2d.play("hit")
		timer.stop()  
		timer.start()
		if hitpoints <= 0:
			emit_signal("defeated")
			self.queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	if bee_sprite_2d.animation == "hit":
		bee_sprite_2d.play("fly")
			
func _on_spotarea_body_entered(body: Node2D) -> void:
	if body.is_in_group("playerr"):
		player = body
		chase = true

func _on_spotarea_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		chase = false

func _on_beebody_area_entered(area: Area2D) -> void:
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
		
func _on_beebody_area_exited(area: Area2D) -> void:
	if area.is_in_group("sword1"):
		attack = false
	if area.is_in_group("sword2"):
		attack = false
	if area.is_in_group("sword3"):
		attack = false
		
func beehealthbar() -> void: 
	beehealth.value = hitpoints

func _on_timer_timeout() -> void:
	if hitpoints < 500: 
		hitpoints = hitpoints + 50
		if hitpoints > 500: 
			hitpoints = 500
	if hitpoints <= 0: 
		hitpoints = 0 
