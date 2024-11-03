extends Node

@onready var player_scene = preload("res://scenes/player/player.tscn")
@onready var beginning_scene = preload("res://scenes/UI/main_menu.tscn")
@onready var portal = preload("res://scenes/environment/portal.tscn")
@onready var ens_primum = preload("res://scenes/enemies/ens_primum.tscn")
@onready var scene_root = get_tree().root.get_child(get_tree().root.get_child_count() - 1)

var curr_scene = null
var curr_scene_instance = null

var is_faded_out = false
var b_fade_out = false
var b_fade_in = false
var currently_fading = false

var transitioning = false

signal fade_out_complete
signal fade_in_complete

func _ready():
	curr_scene_instance = beginning_scene.instantiate()
	curr_scene = beginning_scene
	if curr_scene_instance.is_in_group("UIScene"):
		scene_root.get_node("UI").add_child(curr_scene_instance)
	else:
		scene_root.add_child(curr_scene_instance)
	
func _process(delta):
	if b_fade_out:
		scene_root.get_node("UI/Fade").modulate = Color(0.0, 0.0, 0.0, lerp(scene_root.get_node("UI/Fade").modulate.a, 1.0, 3 * delta))
		if (1.0 - scene_root.get_node("UI/Fade").modulate.a) < 0.01:
			scene_root.get_node("UI/Fade").modulate.a = 1.0
			b_fade_out = false
			fade_out_complete.emit()
	
	if b_fade_in:
		scene_root.get_node("UI/Fade").modulate = Color(0.0, 0.0, 0.0, lerp(scene_root.get_node("UI/Fade").modulate.a, 0.0, 3 * delta))
		if scene_root.get_node("UI/Fade").modulate.a < 0.01:
			scene_root.get_node("UI/Fade").modulate.a = 0.0
			b_fade_in = false
			fade_in_complete.emit()

func reload_curr_scene():
	b_fade_out = true
	await fade_out_complete
	
	#scene_root.get_node("Player").position = scene_root.get_node("Player").last_checkpoint
	scene_root.get_node("Player").position = Vector2.ZERO
	scene_root.get_node("Player").num_balsam_available = scene_root.get_node("Player").max_num_balsam
	scene_root.get_node("Player").health_comp.modify_health(-1.0 * scene_root.get_node("Player").health_comp.max_health)
	
	if scene_root.get_node("EnsPrimum"):
		scene_root.get_node("EnsPrimum").queue_free()
	if scene_root.get_node_or_null("Cave"):
		scene_root.get_node("Cave/PrimumTerrae").target = null
	if scene_root.get_node_or_null("Volcano"):
		scene_root.get_node("Volcano/PrimumIgnis").target = null
	if scene_root.get_node_or_null("Clouds"):
		scene_root.get_node("Clouds/PrimumAere").target = null
	if scene_root.get_node_or_null("Swamp"):
		scene_root.get_node("Swamp/PrimumAquae").target = null
	if scene_root.get_node_or_null("Void"):
		scene_root.get_node("Void/Lysander").target = null
		
	scene_root.remove_child(curr_scene_instance)
	curr_scene_instance.queue_free()
	curr_scene_instance = curr_scene.instantiate()
	if curr_scene_instance.is_in_group("UIScene"):
		scene_root.get_node("UI").add_child(curr_scene_instance)
	else:
		scene_root.add_child(curr_scene_instance)
		
	scene_root.get_node("Player").position = scene_root.get_node("Player").last_checkpoint
	scene_root.get_node("Player").hide_boss_bar()
	
	b_fade_in = true
	
func workstation_reload():
	#scene_root.get_node("Player").num_balsam_available = scene_root.get_node("Player").max_num_balsam
	#scene_root.get_node("Player").health_comp.modify_health(-1.0 * scene_root.get_node("Player").health_comp.max_health)
	
	
	scene_root.remove_child(curr_scene_instance)
	curr_scene_instance.queue_free()
	curr_scene_instance = curr_scene.instantiate()
	if curr_scene_instance.is_in_group("UIScene"):
		scene_root.get_node("UI").add_child(curr_scene_instance)
	else:
		scene_root.add_child(curr_scene_instance)

func swap_scene(destination, spawn_point):
	b_fade_out = true
	await fade_out_complete
	
	scene_root.get_node("Player").position = Vector2.ZERO
	
	if curr_scene_instance.is_in_group("UIScene"):
		scene_root.get_node("UI").remove_child(curr_scene_instance)
	else:
		scene_root.remove_child(curr_scene_instance)
	curr_scene = destination
	curr_scene_instance = curr_scene.instantiate()
	if curr_scene_instance.is_in_group("UIScene"):
		scene_root.get_node("UI").add_child(curr_scene_instance)
	else:
		scene_root.add_child(curr_scene_instance)
	scene_root.get_node("Player").position = curr_scene_instance.get_node("Spawns/" + str(spawn_point)).position
	scene_root.get_node("Player").last_checkpoint = curr_scene_instance.get_node("Spawns/" + str(spawn_point)).position
	
	if scene_root.get_node_or_null("Portal") != null:
		scene_root.get_node("Portal").queue_free()
	
	MusicDirector.play(curr_scene_instance.name)
	
	b_fade_in = true
	
func fade_out():
	if b_fade_in:
		b_fade_in = false
		
	is_faded_out = true
	b_fade_out = true

func fade_in():
	if b_fade_out:
		b_fade_out = false
	
	is_faded_out = false
	b_fade_in = true

func spawn_player():
	scene_root.add_child(player_scene.instantiate())
	var camera = Camera2D.new()
	scene_root.get_node("Player").add_child(camera)
	camera.zoom = Vector2(1.0, 1.0)

func player_left_menu():
	scene_root.get_node("Player").in_menu = false
	scene_root.get_node("Player").set_process_input(true)

func boss_dead(death_pos):
	scene_root.get_node("Player").remove_boss_bar()
	var portal_out = portal.instantiate()
	portal_out.portal_none = true
	portal_out.position = death_pos
	scene_root.add_child(portal_out)
	
func lysander_dead(death_pos):
	scene_root.get_node("EnsPrimumSpawnTimer").timeout.connect(spawn_ens_primum.bind(death_pos))
	scene_root.get_node("Player").update_location("The Shadows Beckon...\nThe Void Calls...")
	scene_root.get_node("EnsPrimumSpawnTimer").start()
	
func spawn_ens_primum(pos):
	scene_root.get_node("Player").hide_location()
	var ens = ens_primum.instantiate()
	ens.position = pos
	scene_root.get_node("Void/Lysander").queue_free()
	scene_root.add_child(ens)
