extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const sens = 0.001
#players variables
const player_fre = 2.0
const player_amp = 0.08
var player_far = 0.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
signal playertime
signal capsule
signal negativcapsule
signal orb
signal negativorb
signal cube
signal negativcube

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sens)
		camera.rotate_x(-event.relative.y * sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	# Players head sine wave
	player_far +=delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = playerhead(player_far)

	move_and_slide()

func playerhead(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * player_fre) * player_amp
	pos.y = cos(time * player_fre) * player_amp
	return pos 
	
func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("finish"):
		emit_signal("playertime")
	if area.is_in_group("capsule"):
		area.queue_free()
		emit_signal("capsule")
	if area.is_in_group("negativcapsule"):
		area.queue_free()
		emit_signal("negativcapsule")
	if area.is_in_group("orb"):
		area.queue_free()
		emit_signal("orb")
	if area.is_in_group("negativorb"):
		area.queue_free()
		emit_signal("negativorb")
	if area.is_in_group("cube"):
		area.queue_free()
		emit_signal("cube")
	if area.is_in_group("negativcube"):
		area.queue_free()
		emit_signal("negativcube")
