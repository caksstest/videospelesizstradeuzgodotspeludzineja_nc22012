extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack: Area2D = $attack
@onready var attack_shape_2d: CollisionShape2D = $attack/CollisionShape2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var attacking = false
var elapsed_time = 0.0 
var timer_stopped = false
@onready var score: Label = $"../CanvasLayer/Score"
@onready var time: Label = $"../CanvasLayer/Time"
func _ready() -> void:
	Autogame.score = 0 
func _physics_process(delta: float) -> void:
	 # Update elapsed time only if the timer isn't stopped
	if not timer_stopped:
		elapsed_time += delta
		update_timer_display()
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("left", "right")
	# Flip the sprite
	if direction > 0: 
		animated_sprite_2d.flip_h = false
		attack.scale.x = abs(attack.scale.x)
	if direction < 0: 
		animated_sprite_2d.flip_h = true
		attack.scale.x = -abs(attack.scale.x)
	# Character's animations
	if not attacking:
		if is_on_floor():
			if direction == 0:
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("jump")
	
	if Input.is_action_just_pressed("attack"):
		animated_sprite_2d.play("attack")
		attacking = true
		attack_shape_2d.disabled = false	
	# Player's movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	score.text = "Orcs: " + str(Autogame.score)
# Attack animation finnished
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "attack": 
		attack_shape_2d.disabled = true
		attacking = false
		
func update_timer_display():
	time.text = "Time: " + str(floor(elapsed_time)) + "s"
	
# Called when the player enters the finish area
func on_player_finished():
	timer_stopped = true  
	Autogame.time = elapsed_time
