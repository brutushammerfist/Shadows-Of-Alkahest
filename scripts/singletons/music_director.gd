extends Node

@onready var music_player : AudioStreamPlayer = get_tree().root.get_child(get_tree().root.get_child_count() - 1).get_node("MusicPlayer")

@onready var main_menu_audio = preload("res://assets/audio/Itch/DavidKBD/DavidKBD - 08 - Beethoven - Moonlight Sonata (1st Movement) - Concerto2.ogg")
@onready var percivals_audio = preload("res://assets/audio/Itch/DavidKBD/DavidKBD - 07 - J.S. Bach - Prelude in C Major - Concerto2.ogg")
@onready var caves_audio = preload("res://assets/audio/Itch/DavidKBD/DavidKBD - Concerto Pack - 02 - In the Hall of the Mountain King (Grieg).ogg")
@onready var swamp_audio = preload("res://assets/audio/Itch/DavidKBD/DavidKBD - 02 - The Four Seasons RV 269 Spring - Concerto2.ogg")
@onready var clouds_audio = preload("res://assets/audio/Itch/DavidKBD/DavidKBD - Concerto Pack - 03 - Les Toreadors from Carmen Suite No. 1 (Georges Bizet).ogg")
@onready var volcano_audio = preload("res://assets/audio/Itch/DavidKBD/DavidKBD - Concerto Pack - 05 - Asturias, Suite espanola V (Albeniz).ogg")
@onready var void_audio = preload("res://assets/audio/Itch/DavidKBD/DavidKBD - 04 - Ludwig Van Beethoven, Bagatelle N25 In A Minor (Fur Elise) - Concerto2.ogg")

func _ready():
	music_player.stream = main_menu_audio
	music_player.play()

func play(scene_name):
	match scene_name:
		"PercivalsWorkshop":
			music_player.stream = percivals_audio
		"Caves":
			music_player.stream = caves_audio
		"Swamp":
			music_player.stream = swamp_audio
		"Clouds":
			music_player.stream = clouds_audio
		"Volcano":
			music_player.stream = volcano_audio
		"Void":
			music_player.stream = void_audio

	if !music_player.playing:
		music_player.play()

func play_sfx():
	pass
