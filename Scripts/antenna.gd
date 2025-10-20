extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
var start = false
const Balloon = preload("uid://b4kt58sx1oul5")

func _process(delta):
	if start == true:
		if Input.is_action_just_pressed("interact"):	
			print("start dial")
			action()

func action() -> void:
	if State.finished_dialogue == false:
		var balloon: Node = Balloon.instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start(dialogue_resource, dialogue_start)

func _on_body_entered(body: Node2D) -> void:
	print("entered")
	if State.finished_dialogue == false:
		start = true


func _on_body_exited(body: Node2D) -> void:
	start = false
