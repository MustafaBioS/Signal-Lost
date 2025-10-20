extends CharacterBody2D

const SPEED = 7.5
const GRAVITY = 500.0
var attacking = false
var on_cd = false
var target = null
var right = true
var can_turn = true
var hearts = 1
@onready var ray = $RayCast2D
@onready var anim = $AnimatedSprite2D

func enemy():
	pass

func _process(delta):
	if State.paused == false:
		move_enemy(delta)
		turn()
	if hearts <= 0:
		queue_free()

func move_enemy(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	velocity.x = -SPEED if right else SPEED
	move_and_slide()

func turn():
	if ray.is_colliding() and is_on_floor():
		right = !right
		scale.x *= -1
		can_turn = false
		await get_tree().create_timer(1).timeout
		can_turn = true
		print("turn")


func _on_attack_zone_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		target = body
		attacking = true
		attack_loop()

func _on_attack_zone_body_exited(body: Node2D) -> void:
	if body == target:
		attacking = false
		target = null
		anim.play("default")
		
func attack_loop():
	while attacking and target and not on_cd and State.paused == false:
		on_cd = true
		anim.play("attack")

		# damage check
		if target and target.has_method("player") and State.paused == false:
			target.hearts -= 1
			
		await get_tree().create_timer(1.5).timeout
		on_cd = false

		await get_tree().process_frame
