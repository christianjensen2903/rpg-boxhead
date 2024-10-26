extends CharacterBody2D

const SPEED = 10
const DIRECTION_UPDATE_DELAY = 0.2  # Delay in seconds before updating direction

var player
var current_dir = "down" # Default direction
var anim_sprite
var last_direction_update_time = 0.0  # Tracks time since the last direction update

func _ready() -> void:
	player = get_parent().get_node("player")
	anim_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	last_direction_update_time += delta
	handle_movement()

func handle_movement() -> void:
	if not player:
		return
		
	if position.distance_to(player.position) < 10:
		return
	
	# Only update the direction after the delay has passed
	if last_direction_update_time >= DIRECTION_UPDATE_DELAY:
		last_direction_update_time = 0.0  # Reset timer
		
		# Determine direction towards the player
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED
		
		# Update animation based on movement direction
		update_animation_direction(direction)
	
	move_and_slide()

func update_animation_direction(direction: Vector2) -> void:
	# Determine the main direction
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			current_dir = "right"
		else:
			current_dir = "left"
	else:
		if direction.y > 0:
			current_dir = "down"
		else:
			current_dir = "up"
	anim_sprite.flip_h = current_dir == "left"

	# Play side walk animations for horizontal and diagonal movement, others based on direction
	if current_dir in ["right", "left", "down"]:
		anim_sprite.play("side_walk")
	elif current_dir == "up":
		anim_sprite.play("back_walk")
		
