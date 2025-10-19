extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -250.0

@onready var anim = $AnimatedSprite2D

func player():
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction = 0.0

	if Input.is_action_pressed("a") and State.in_dialogue == false:
		direction -= 1
		anim.frame = 2
		
	elif Input.is_action_pressed("d") and State.in_dialogue == false:
		direction += 1
		anim.frame = 3
	
	else:
		anim.frame = 0
	
	velocity.x = direction * SPEED

	move_and_slide()
