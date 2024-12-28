extends CharacterBody3D
const walk_speed = 3
const sprint_speed = 5
const JUMP_VELOCITY = 4
const sens = 0.001
const max_ammo = 30
#players variables
const player_fre = 4.0
const player_amp = 0.01
var player_far = 0.0
var current_speed = 0.0
@onready var ammo: Label = $CanvasLayer/ammo
@onready var head: Node3D = $head
@onready var camera: Camera3D = $head/Camera3D
@onready var rig: Node3D = $Rig
@onready var crosshair: ColorRect = $CanvasLayer/crosshair
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_3d: RayCast3D = $head/Camera3D/RayCast3D
@onready var reloadtimer: Timer = $reloadtimer
@onready var kills: Label = $CanvasLayer/kills
@onready var playershealth: ProgressBar = $CanvasLayer/ProgressBar
var shoot = true
var reload = false
const SHOOT_COOLDOWN = 0.3
var ammocount = 30 
var shoot_timer = 0.0 
var fullreload_timer = 4.6
var notfullreload_timer = 3.4
const FIRE_ANIMATION_SPEED = 8
var health = 100
@onready var muzzle_flash: GPUParticles3D = $Rig/Muzzleflash
signal player_died 
var is_alive: bool = true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	crosshair.mouse_filter = Control.MOUSE_FILTER_IGNORE
	animation_player.play("Rig|VSK_Idle")
	ammo.text = "Ammo: " +str(ammocount) + "/" + str(max_ammo)
	Zombielandglobal.kills = 0
	kills.text = "Kills: " + str(Zombielandglobal.kills)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sens)
		camera.rotate_x(-event.relative.y * sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-17), deg_to_rad(17))
		
		var target_rig_x_rotation = -camera.rotation.x + deg_to_rad(-90)
		rig.rotation_degrees.x = rad_to_deg(clamp(target_rig_x_rotation, deg_to_rad(-107), deg_to_rad(-63)))
		
		rig.rotation_degrees.z = 0
		rig.rotation_degrees.y += -event.relative.x * sens * 57.2958 # Increment rotation around Y-axis
		rig.rotation_degrees.y = wrapf(rig.rotation_degrees.y, 0, 360)
		
func _process(delta):
	if Input.is_action_just_pressed("reload") and ammocount < max_ammo and !reload:
		start_reload()
		
	if Input.is_action_pressed("shoot"):
		shootgun(delta) 
	if ammocount <= 0 and !reload:
		start_reload()
	update_display()
	playerhealth()

func update_display():
	kills.text = "Kills: " + str(Zombielandglobal.kills)
	playerhealth()
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	else:
		current_speed = walk_speed
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		_play_movement_animation(current_speed)
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	# Players head sine wave
	player_far +=delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = playerhead(player_far)
	
	move_and_slide()

func _play_movement_animation(speed: float) -> void:
	# Play the appropriate animation based on speed
	if reload:
		return 
	if shoot:
		if speed == walk_speed:
			animation_player.play("Rig|VSK_Walk")
		elif speed == sprint_speed:
			animation_player.play("Rig|VSK_Sprint")
		else:
			animation_player.play("Rig|VSK_Idle")
	else:
		animation_player.play("Rig|VSK_Fire")

func playerhead(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * player_fre) * player_amp
	pos.y = cos(time * player_fre) * player_amp
	return pos 

func shootgun(delta):
	if !shoot or reload or ammocount <= 0 or current_speed == sprint_speed:
		return
	shoot = false
	shoot_timer = SHOOT_COOLDOWN
	animation_player.play("Rig|VSK_Fire")
	animation_player.advance(delta * FIRE_ANIMATION_SPEED)
	muzzle_flash.restart()
	muzzle_flash.emitting = true
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		if collider and collider.has_method("take_damage"):
			collider.take_damage() 

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Rig|VSK_ReloadFull" or anim_name == "Rig|VSK_ReloadNotFull":
		_finish_reload()
	elif anim_name == "Rig|VSK_Fire":
		if ammocount > 0:
			ammocount -= 1
			update_ammo_label()
		shoot = true
		_play_movement_animation(current_speed)

func start_reload():
	if reload:
		return 
	reload = true
	shoot = false
	ammo.text = "Reloading..."
	if ammocount == 0:
		animation_player.play("Rig|VSK_ReloadFull")
		reloadtimer.start(fullreload_timer)
	if ammocount < max_ammo:
		animation_player.play("Rig|VSK_ReloadNotFull")
		reloadtimer.start(notfullreload_timer)
	else:
		reload = false
		return 
		
func _finish_reload():
	reloadtimer.stop()
	reload = false
	shoot = true
	ammocount = max_ammo 
	update_ammo_label()

func update_ammo_label():
	ammo.text = "Ammo: " + str(ammocount) + "/" + str(max_ammo)

func _on_reloadtimer_timeout() -> void:
	_finish_reload()     
	
func take_damage_from_enemy(damage: int = 10):
	if not is_alive:
		return
	health -= damage
	update_display()
	if health <= 0:
		health = 0
		is_alive = false
		emit_signal("player_died")

func playerhealth() -> void: 
	playershealth.value = health

func _on_regentimer_timeout() -> void:
	if not is_alive:
		return 
	if health < 100: 
		health = health + 10
		if health > 100: 
			health = 100
	if health <= 0: 
		health = 0 
	update_display()
