extends CharacterBody2D

const SPEED = 50
const ATTACK_DURATION = 0.5 # Attack duration in seconds
var current_dir = "none"
var attacking = false
var attack_timer = 0.0

func _ready() -> void:
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta: float) -> void:
	if attacking:
		# Update attack timer while in attack mode
		attack_timer -= delta
		if attack_timer <= 0:
			attacking = false
		return # Skip movement if attacking

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

	# Trigger attack if the attack button is pressed
	if Input.is_action_just_pressed("ui_accept"):
		print("test")
		start_attack()
		return

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

func start_attack() -> void:
	attacking = true
	attack_timer = ATTACK_DURATION
	velocity = Vector2.ZERO # Stop movement
	play_attack_animation()

func play_attack_animation() -> void:
	var anim = $AnimatedSprite2D

	# Choose the attack animation based on direction
	if current_dir in ["right", "left", "down"]:
		anim.play("side_attack")
	elif current_dir == "up":
		anim.play("back_attack")
