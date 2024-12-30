extends CharacterBody2D

signal deafeated
var hitpoints = 1000
var speed = 70
var chase = false
var player = null
@onready var boar_sprite_2d: AnimatedSprite2D = $AnimatedSprite2
var attack_cooldown = true
var attack = false #Player's attack 
var close = false
var dead = false
@onready var boarhealth: ProgressBar = $ProgressBar
@onready var timer: Timer = $ProgressBar/Timer
const SAFE_DISTANCE = 20

func _physics_process(delta: float) -> void:
	if boar_sprite_2d.animation == "hitted":
		return  
	if chase:
		var direction = player.position - position
		if direction.length() > SAFE_DISTANCE:  
			position += direction.normalized() * speed * delta
			boar_sprite_2d.play("run")
			boar_sprite_2d.flip_h = direction.x > 0
		else:
			velocity = Vector2.ZERO
			boar_sprite_2d.play("run")
	else:
		boar_sprite_2d.play("idle")
		velocity = Vector2.ZERO
		
	move_and_slide()	
	blackboarhealth()
	
func _on_rangetarget_body_entered(body: Node2D) -> void:
	if body.is_in_group("playerr"):
		player = body
		chase = true
		
func _on_rangetarget_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		chase = false

func take_damage1() -> void:
	if attack and Fighter.playerattack:
		hitpoints -= 100
		blackboarhealth()
		boar_sprite_2d.play("hitted")
		timer.stop()  
		timer.start()
		if hitpoints <= 0:
			emit_signal("deafeated")
			self.queue_free()

func take_damage2() -> void:
	if attack and Fighter.playerattack:
		hitpoints -= 150
		blackboarhealth()
		boar_sprite_2d.play("hitted")
		timer.stop()  
		timer.start()
		if hitpoints <= 0:
			emit_signal("deafeated")
			self.queue_free()

func take_damage3() -> void:
	if attack and Fighter.playerattack:
		hitpoints -= 120
		blackboarhealth()
		boar_sprite_2d.play("hitted")
		timer.stop()  
		timer.start()
		if hitpoints <= 0:
			emit_signal("deafeated")
			self.queue_free()

func _on_animated_sprite_2_animation_finished() -> void:
	if boar_sprite_2d.animation == "hitted":
		boar_sprite_2d.play("idle")
	
func _on_boarbody_area_entered(area: Area2D) -> void:
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
	
func _on_boarbody_area_exited(area: Area2D) -> void:
	if area.is_in_group("sword1"):
		attack = false
	if area.is_in_group("sword2"):
		attack = false
	if area.is_in_group("sword3"):
		attack = false
		
func blackboarhealth() -> void: 
	boarhealth.value = hitpoints

func _on_timer_timeout() -> void:
	if hitpoints < 1000: 
		hitpoints = hitpoints + 100
		if hitpoints > 1000: 
			hitpoints = 1000
	if hitpoints <= 0: 
		hitpoints = 0 
