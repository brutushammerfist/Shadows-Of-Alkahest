class_name PrimumAquaeController
extends EnemyController

@export var tendril_prefab : PackedScene
@export var wave_prefab : PackedScene

@export var water_tendril_damage := 3.0
@export var water_tendril_lifetime := 3.0
@export var water_tendril_chance := 20.0
@export var min_num_tendrils := 1
@export var max_num_tendrils := 5
@export var tendril_radius := 500.0
@export var wave_damage := 2.0
@export var wave_lifetime := 10.0
@export var wave_chance := 25.0
@export var num_waves := 8

func _ready():
	super()
	
func _process(delta):
	pass
	
func attack():
	var rng = random.randi_range(0, 100)
	if rng < water_tendril_chance and global_cooldown.is_stopped():
		# Spawn tendrils...
		var num_tendrils = random.randi_range(min_num_tendrils, max_num_tendrils)
		
		for i in range(num_tendrils):
			var tendril = tendril_prefab.instantiate()
			tendril.dmg = water_tendril_damage
			tendril.get_node("Lifetime").wait_time = water_tendril_lifetime
			tendril.global_position = get_random_tendril_point()
			$ObjectParent.add_child(tendril)
			tendril.get_node("Lifetime").start()
	elif rng >= water_tendril_chance and rng < water_tendril_chance + wave_chance and global_cooldown.is_stopped():
		# Spawn waves...
		var spread_angle = 360.0 / num_waves
		
		for i in range(num_waves):
			var wave = wave_prefab.instantiate()
			wave.dmg = wave_damage
			wave.position = self.position
			$ObjectParent.add_child(wave)
			wave.get_node("Lifetime").wait_time = wave_lifetime
			wave.get_node("Lifetime").start()
			wave.rotation = spread_angle * i
			wave.velocity = Vector2(0.0, -1.0).rotated(deg_to_rad(spread_angle * i)) * 50.0
			
	global_cooldown.start()
		
func get_random_tendril_point():
	# Get Random Angle
	var angle := random.randf_range(0.0, 359.9)
	# Get Random Distance
	var distance := random.randf_range(50.0, tendril_radius)
	# Return Point
	return global_position + (Vector2(0.0, -1.0).rotated(angle) * distance)

func _on_damage_area_body_entered(body):
	if body.is_in_group("Player") and $GlobalCooldown.is_stopped():
		# Contact Damage...
		# None for this boss...
		pass
