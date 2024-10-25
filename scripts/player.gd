extends CharacterBody2D


const SPEED = 100
var current_dir = "none"

func _physics_process(delta: float) -> void:
	player_movement(delta)
	
	
func _ready():
	$AnimatedSprite2D.play("front_idle")
	
func player_movement(delta: float) -> void:
	
	velocity.x = 0
	velocity.y = 0

	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -SPEED
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = SPEED
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -SPEED
	else:
		play_anim(0)
		
	move_and_slide()
	
	
func play_anim(movement: int):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "left":
		anim.flip_h = true
	else:
		anim.flip_h = false
	
	if dir == "right" or dir == "left":
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	elif dir == "down":
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
	elif dir == "up":
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")
			
