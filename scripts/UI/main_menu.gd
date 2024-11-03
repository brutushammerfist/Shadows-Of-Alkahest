class_name MainMenu
extends Control

@onready var play_scene = preload("res://scenes/maps/percivals_workshop.tscn")
var play_spawn_point = 1

func _on_play_button_pressed():
	SceneDirector.spawn_player()
	SceneDirector.swap_scene(play_scene, play_spawn_point)

func _on_credits_button_pressed():
	$Credits.visible = true

func _on_controls_button_pressed():
	$Controls.visible = true
