extends CharacterBody2D

const SPEED = 120.0
const ENEMY_ATTACK_COOLDOWN1 = 2.0
const ENEMY_ATTACK_COOLDOWN2 = 1
const ENEMY_ATTACK_COOLDOWN3 = 4.0
const ATTACK1_COOLDOWN = 1.0
const ATTACK2_COOLDOWN = 1.5
const ATTACK3_COOLDOWN = 2.0

var direction = "none"
var health = 100
var stillalive = true
var attacking1 = false
var attacking2 = false
var attacking3 = false
var can_take_damage_boar = false
var can_take_damage_bee = false
var can_take_damage_snail = false
var attack1_ready = true
var attack2_ready = true
var attack3_ready = true
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_shape_1: CollisionShape2D = $attack1/CollisionShape2D
@onready var attack_shape_2: CollisionShape2D = $attack2/CollisionShape2D
@onready var attack_shape_3: CollisionShape2D = $attack3/CollisionShape2D
@onready var damagetimer: Timer = $damagetimer
@onready var cooldown_1: Timer = $attack1/cooldown1
@onready var cooldown_2: Timer = $attack2/cooldown2
@onready var cooldown_3: Timer = $attack3/cooldown3
@onready var playershealth: ProgressBar = $"../CanvasLayer/playershealth"
@onready var regen: Timer = $regen
@onready var boar_timer: Timer = $boar_timer
@onready var bee_timer: Timer = $bee_timer
@onready var snail_timer: Timer = $snail_timer

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	if not (attacking1 or attacking2 or attacking3):
		handle_movement_and_animation()
	handle_attacks()
	playerhealth()
	move_and_slide()

	if health <= 0:
		stillalive = false
		health = 0
		get_tree().change_scene_to_file("res://scenes/knight/battle/restartforest.tscn")
		self.queue_free()

func handle_movement_and_animation() -> void:
	if Input.is_action_pressed("right"):
		direction = "right"
		velocity.x += SPEED
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("run")
		flip_attack_shapes(false)
	elif Input.is_action_pressed("left"):
		direction = "left"
		velocity.x -= SPEED
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("run")
		flip_attack_shapes(true)
	elif Input.is_action_pressed("down"):
		direction = "down"
		velocity.y += SPEED
		animated_sprite_2d.play("run")
	elif Input.is_action_pressed("up"):
		direction = "up"
		velocity.y -= SPEED
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
		velocity = Vector2.ZERO

func handle_attacks() -> void:
	if Input.is_action_just_pressed("attack1") and attack1_ready:
		perform_attack(1)
	elif Input.is_action_just_pressed("attack2") and attack2_ready:
		perform_attack(2)
	elif Input.is_action_just_pressed("attack3") and attack3_ready:
		perform_attack(3)

func perform_attack(attack_type: int) -> void:
	if attack_type == 1:
		attacking1 = true
		attack1_ready = false
		cooldown_1.start(ATTACK1_COOLDOWN)
		animated_sprite_2d.play("attack1")
		attack_shape_1.disabled = false
	elif attack_type == 2:
		attacking2 = true
		attack2_ready = false
		cooldown_2.start(ATTACK2_COOLDOWN)
		animated_sprite_2d.play("attack2")
		attack_shape_2.disabled = false
	elif attack_type == 3:
		attacking3 = true
		attack3_ready = false
		cooldown_3.start(ATTACK3_COOLDOWN)
		animated_sprite_2d.play("attack3")
		attack_shape_3.disabled = false
	Fighter.playerattack = true
	damagetimer.start()

func flip_attack_shapes(to_left: bool) -> void:
	var flip_attack1_offset = 18  # Distance to flip attack shapes
	var flip_attack2_offset = 7.125 
	var flip_attack3_offset = 18 
	if to_left:
		attack_shape_1.position.x = -abs(flip_attack1_offset)
		attack_shape_2.position.x = -abs(flip_attack2_offset)
		attack_shape_3.position.x = -abs(flip_attack3_offset)
	else:
		attack_shape_1.position.x = abs(flip_attack1_offset)
		attack_shape_2.position.x = abs(flip_attack2_offset)
		attack_shape_3.position.x = abs(flip_attack3_offset)

func _on_damagetimer_timeout() -> void:
	# Reset attack states after damage timer ends
	damagetimer.stop()
	Fighter.playerattack = false
	attack_shape_1.disabled = true
	attack_shape_2.disabled = true
	attack_shape_3.disabled = true
	attacking1 = false
	attacking2 = false
	attacking3 = false

func _on_animated_sprite_2d_animation_finished() -> void:
	# Reset attack state if an attack animation ends
	if animated_sprite_2d.animation == "attack1":
		attacking1 = false
		attack_shape_1.disabled = true
	elif animated_sprite_2d.animation == "attack2":
		attacking2 = false
		attack_shape_2.disabled = true
	elif animated_sprite_2d.animation == "attack3":
		attacking3 = false
		attack_shape_3.disabled = true

func take_damage1(amount: int) -> void:
	var scaled_damage = amount + (Fighter.level * 2.5)
	health -= scaled_damage
	regen.stop()  
	regen.start()
	if health < 0:
		health = 0

func take_damage2(amount: int) -> void:
	var scaled_damage = amount + (Fighter.level * 2) 
	health -= scaled_damage
	health -= amount
	regen.stop()  
	regen.start()
	if health < 0:
		health = 0
	
func take_damage3(amount: int) -> void:
	var scaled_damage = amount + (Fighter.level * 6) 
	health -= scaled_damage
	health -= amount
	regen.stop()  
	regen.start()
	if health < 0:
		health = 0

func _on_playerbody_area_entered(area: Area2D) -> void:
	if area.is_in_group("blackboarattack"):
		if not can_take_damage_boar:
			can_take_damage_boar = true
			boar_timer.start(ENEMY_ATTACK_COOLDOWN1)
	if area.is_in_group("beeattack"):
		if not can_take_damage_bee:
			can_take_damage_bee = true
			bee_timer.start(ENEMY_ATTACK_COOLDOWN2)
	if area.is_in_group("snailattack"):
			can_take_damage_snail = true
			snail_timer.start(ENEMY_ATTACK_COOLDOWN3)
	
func _on_boar_timer_timeout() -> void:
	if can_take_damage_boar:
		take_damage1(10)
		boar_timer.start(ENEMY_ATTACK_COOLDOWN1)

func _on_bee_timer_timeout() -> void:
	if can_take_damage_bee:
		take_damage2(5)
		bee_timer.start(ENEMY_ATTACK_COOLDOWN2)

func _on_snail_timer_timeout() -> void:
	if can_take_damage_snail:
		take_damage3(20)
		snail_timer.start(ENEMY_ATTACK_COOLDOWN3)
		
func _on_playerbody_area_exited(area: Area2D) -> void:
	if area.is_in_group("blackboarattack"):
		can_take_damage_boar = false
		boar_timer.stop()	
		boar_timer.start(ENEMY_ATTACK_COOLDOWN1)
	if area.is_in_group("beeattack"):
		can_take_damage_bee = false
		bee_timer.stop()
		bee_timer.start(ENEMY_ATTACK_COOLDOWN2)
	if area.is_in_group("snailattack"):
		can_take_damage_snail = false
		snail_timer.stop()
		snail_timer.start(ENEMY_ATTACK_COOLDOWN3)
		
func _on_cooldown_1_timeout() -> void:
	attack1_ready = true

func _on_cooldown_2_timeout() -> void:
	attack2_ready = true

func _on_cooldown_3_timeout() -> void:
	attack3_ready = true

func playerhealth() -> void: 
	playershealth.value = health
	
func _on_regen_timeout() -> void:
	if health < 100: 
		health = health + 10
		if health > 100: 
			health = 100
	if health <= 0: 
		health = 0 
