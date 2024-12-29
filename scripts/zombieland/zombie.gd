extends CharacterBody3D

var health = 100
var speed = 3.0
var zombieattackrange = 0.75
var gravity = Vector3(0, -9.8, 0)  # Gravity vector
var walk_animation_speed = 9
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack: RayCast3D = $Armature/attack
var is_attacking: bool = false

func _ready():
	position.y += -0.5
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += gravity * delta
	else:
		velocity.y = 0  

	var dir = player.global_position - global_position
	dir.y = 0.0
	var distance = dir.length()

	if distance > zombieattackrange:
		is_attacking = false
		dir = dir.normalized()
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
		if not animation_player.is_playing() or animation_player.current_animation != "Walk":
			animation_player.play("Walk")
			animation_player.advance(delta * walk_animation_speed)
	else:
		is_attacking = true
		velocity.x = 0
		velocity.z = 0
		if not animation_player.is_playing() or animation_player.current_animation != "Attack1":
			animation_player.play("Attack1")
			start_attack_damage_timer()

	if dir.length() > 0.01:
		rotation.y = atan2(dir.x, dir.z)
	move_and_slide()

func take_damage(damage: int = 50):
	health -= damage
	if health <= 0:
		die()
		Zombielandglobal.kills +=1

func die():
	queue_free()

func deal_damage_to_player():
	if attack.is_colliding():
		var collider = attack.get_collider()
		if collider and collider.has_method("take_damage_from_enemy"):
			collider.take_damage_from_enemy()

func start_attack_damage_timer():
	var duration = animation_player.get_animation("Attack1").length
	var middle_time = duration / 2.0
	var timer = Timer.new()
	timer.wait_time = middle_time
	timer.one_shot = true
	add_child(timer)  
	timer.start()
	await timer.timeout
	deal_damage_to_player()
	timer.queue_free() 
