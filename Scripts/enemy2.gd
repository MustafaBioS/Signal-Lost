extends CharacterBody2D

const SPEED = 7.5
const GRAVITY = 500.0
var on_cd = false
var right = true
var can_turn = true
@onready var ray = $RayCast2D
@onready var anim = $AnimatedSprite2D

func _process(delta):
	move_enemy(delta)
	turn()

func move_enemy(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	velocity.x = SPEED if right else -SPEED
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
		await get_tree().create_timer(1.5).timeout
		if on_cd == false:
			anim.play("attack")
			body.hearts -= 1
			on_cd = true
			on_cd = false

func _on_attack_zone_body_exited(body: Node2D) -> void:
	anim.play("default")
