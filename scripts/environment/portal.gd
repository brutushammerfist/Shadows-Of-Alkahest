class_name Portal
extends Area2D

@export var portal_none : bool = false
@export var portal_fire : bool = false
@export var portal_water : bool = false
@export var portal_earth : bool = false
@export var portal_air : bool = false
@export var portal_void : bool = false

@export_group("Sprites")
@export var fire_portal_sprite : SpriteFrames = null
@export var water_portal_sprite : SpriteFrames = null
@export var earth_portal_sprite : SpriteFrames = null
@export var air_portal_sprite : SpriteFrames = null
@export var void_portal_sprite : SpriteFrames = null

@export_group("Destinations")
@export var none_portal_destination = preload("res://scenes/maps/percivals_workshop.tscn")
@export var none_portal_spawn_point = 1
@export var fire_portal_destination = preload("res://scenes/maps/volcano.tscn")
@export var fire_portal_spawn_point = 1
@export var water_portal_destination = preload("res://scenes/maps/swamp.tscn")
@export var water_portal_spawn_point = 1
@export var earth_portal_destination = preload("res://scenes/maps/cave.tscn")
@export var earth_portal_spawn_point = 1
@export var air_portal_destination = preload("res://scenes/maps/clouds.tscn")
@export var air_portal_spawn_point = 1
@export var void_portal_destination = preload("res://scenes/maps/void.tscn")
@export var void_portal_spawn_point = 1

var is_disabled : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if portal_none:
		$Sprite.sprite_frames = void_portal_sprite
	elif portal_fire:
		$Sprite.sprite_frames = fire_portal_sprite
	elif portal_water:
		$Sprite.sprite_frames = water_portal_sprite
	elif portal_earth:
		$Sprite.sprite_frames = earth_portal_sprite
	elif portal_air:
		$Sprite.sprite_frames = air_portal_sprite
	elif portal_void:
		$Sprite.sprite_frames = void_portal_sprite

func teleport():
	if portal_none:
		SceneDirector.swap_scene(none_portal_destination, none_portal_spawn_point)
	elif portal_fire:
		SceneDirector.swap_scene(fire_portal_destination, fire_portal_spawn_point)
	elif portal_water:
		SceneDirector.swap_scene(water_portal_destination, water_portal_spawn_point)
	elif portal_earth:
		SceneDirector.swap_scene(earth_portal_destination, earth_portal_spawn_point)
	elif portal_air:
		SceneDirector.swap_scene(air_portal_destination, air_portal_spawn_point)
	elif portal_void:
		SceneDirector.swap_scene(void_portal_destination, void_portal_spawn_point)

func _on_body_entered(body):
	if body.is_in_group("Player") and !is_disabled:
		teleport()

func disable():
	visible = false
	is_disabled = true
	
func enable():
	visible = true
	is_disabled = false
