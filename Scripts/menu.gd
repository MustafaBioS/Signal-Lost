extends Control

@onready var btns = $MainButtons
@onready var settings = $Settings
@onready var title = $Title


func _ready():
	btns.visible = true
	title.visible = true
	settings.visible = false

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_options_pressed() -> void:
	btns.visible = false
	title.visible = false
	settings.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	_ready()
