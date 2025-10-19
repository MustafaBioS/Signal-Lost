extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -250.0
var hearts = 3
var enemy_in_zone: Node2D = null
var last_hearts = hearts

@onready var anim = $AnimatedSprite2D
@onready var heart1 = $"../UI/HeartsContainer/Heart1"
@onready var heart2 = $"../UI/HeartsContainer/Heart2"
@onready var heart3 = $"../UI/HeartsContainer/Heart3"


func player():
	pass

func _process(delta):
	if hearts != last_hearts:
		if hearts == 2 and is_instance_valid(heart1):
			heart1.queue_free()
		elif hearts == 1 and is_instance_valid(heart2):
			heart2.queue_free()
		elif hearts <= 0 and is_instance_valid(heart3):
			heart3.queue_free()
			get_tree().reload_current_scene()
		last_hearts = hearts
		
	if enemy_in_zone and Input.is_action_just_pressed("attack"):
		attack_enemy(enemy_in_zone)
		
		
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

func attack_enemy(enemy: Node2D) -> void:
	anim.frame = 4
	if enemy:
		enemy.hearts -= 1
		print("Enemy hearts:", enemy.hearts)
	await get_tree().create_timer(0.2).timeout
	anim.frame = 3

func _on_attack_zone_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_zone = body

func _on_attack_zone_body_exited(body: Node2D) -> void:
	if body == enemy_in_zone:
		enemy_in_zone = null
	anim.frame = 3
