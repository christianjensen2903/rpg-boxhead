extends CharacterBody2D

const SPEED = 10
const DIRECTION_UPDATE_DELAY = 0.2  # Delay in seconds before updating direction

var player
var down = false
var right = false
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
	right = direction.x > 0
	down = direction.y > 0
	
	anim_sprite.flip_h = !right

	# Play side walk animations for horizontal and diagonal movement, others based on direction
	if down:
		anim_sprite.play("side_walk")
	else:
		anim_sprite.play("back_walk")
		
