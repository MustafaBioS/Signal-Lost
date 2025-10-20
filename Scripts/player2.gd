extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -250.0
var hearts = 3
var enemy_in_zone: Node2D = null
var player_near_door = false
var last_hearts = hearts
var dir = Vector2.ZERO
@onready var anim = $AnimatedSprite2D
@onready var heart1 = $"../UI/HeartsContainer/Heart1"
@onready var heart2 = $"../UI/HeartsContainer/Heart2"
@onready var heart3 = $"../UI/HeartsContainer/Heart3"
@onready var pause = $"../UI/Pause Menu"


func player():
	pass

func _ready():
	pause.visible = false

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
		
	if enemy_in_zone and Input.is_action_just_pressed("attack") and State.paused == false:
		attack_enemy(enemy_in_zone)
		
	if Input.is_action_just_pressed("pause"):
		if State.paused == false:
			pause.visible = true
			State.paused = true
		elif State.paused == true:
			pause.visible = false
			State.paused = false
			
	if player_near_door and Input.is_action_just_pressed("interact"):
		print("interacted")
		get_tree().change_scene_to_file("res://Scenes/office.tscn")
		
func _physics_process(delta: float) -> void:
	if State.paused or State.in_dialogue:
		return
		
	# reset direction every frame
	dir = Vector2.ZERO

	# collect input
	if Input.is_action_pressed("w"):
		dir.y -= 1
	if Input.is_action_pressed("s"):
		dir.y += 1
	if Input.is_action_pressed("a"):
		dir.x -= 1
	if Input.is_action_pressed("d"):
		dir.x += 1

	# normalize and move
	velocity = dir.normalized() * SPEED
	move_and_slide()

	# animation logic
	if dir.y < 0:
		anim.frame = 1  # up
	elif dir.y > 0:
		anim.frame = 0  # down
	elif dir.x < 0:
		anim.frame = 2  # left
	elif dir.x > 0:
		anim.frame = 3  # right
	else:
		anim.frame = 0  # idle

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


func _on_resume_pressed() -> void:
	pause.visible = false
	State.paused = false


func _on_door_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_near_door = true
		print("player entered")


func _on_door_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_near_door = false
		print("player left")
