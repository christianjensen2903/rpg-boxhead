extends CharacterBody2D

const SPEED = 50
var current_dir = "none"

func _ready() -> void:
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta: float) -> void:
	handle_movement()

func handle_movement() -> void:
	# Reset velocity and detect movement direction
	velocity = Vector2.ZERO
	detect_direction()

	# Normalize the velocity to maintain consistent speed when moving diagonally
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * SPEED
		
	move_and_slide()

func detect_direction() -> void:
	# Check for input and set direction and velocity
	
	
	if Input.is_action_pressed("ui_down"):
		velocity.y += SPEED
		current_dir = "down"
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= SPEED
		current_dir = "up"
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
		current_dir = "right"
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
		current_dir = "left"

	# Choose animation based on movement
	if velocity != Vector2.ZERO:
		play_animation(true)
	else:
		play_animation(false)

func play_animation(moving: bool) -> void:
	var anim = $AnimatedSprite2D

	# Set flip based on left/right direction
	anim.flip_h = current_dir == "left"

	# Play side walk animations for horizontal and diagonal movement, others based on direction
	if current_dir in ["right", "left", "down"]:
		anim.play("side_walk" if moving else "side_idle")
	elif current_dir == "up":
		anim.play("back_walk" if moving else "back_idle")
