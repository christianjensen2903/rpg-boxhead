extends CharacterBody2D

const SPEED = 40
var player

func _ready():
	player = get_parent().get_node("player")

func _physics_process(delta: float) -> void:
	if not player:
		return
	
	# Fix to weird behaviour with move_and_slide when above
	if position.distance_to(player.position) < 10:
		return
	
	var direction = (player.position - position).normalized()
	velocity = direction * SPEED
	
	$AnimatedSprite2D.play("side_walk")
	
	if (player.position.x - position.x) < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	move_and_slide()
