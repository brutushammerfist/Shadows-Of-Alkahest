class_name EnsPrimumController
extends EnemyController

@export var void_chance := 0.0

@export var waves_chance := 20.0
@export var wave_prefab : PackedScene
@export var num_waves := 8
@export var wave_damage := 2.0
@export var wave_lifetime := 10.0

@export var cyclone_chance := 20.0
@export var cyclone_debris_prefab : PackedScene
@export var cyclone_min_num_debris := 3
@export var cyclone_max_num_debris := 10
@export var cyclone_debris_radius := 500.0
@export var cyclone_debris_lifetime := 5.0
@export var cyclone_debris_dmg := 2.0
@export var cyclone_rotation_speed := 1.0

@export var boulder_chance := 20.0
@export var boulder_prefab : PackedScene
@export var boulder_damage := 3.0
@export var boulder_lifetime := 10.0

@export var burn_lifetime := 3.0
@export var burn_tick_interval := 1.0
@export var burn_dmg := 1.0

func _ready():
	super()
	
func _process(delta):
	$CycloneParent.rotate(deg_to_rad(cyclone_rotation_speed))
	
	var rng = random.randi_range(0, 100)
	
	if rng < 50:
		sprite.play("blink")
		await sprite.animation_finished
		sprite.play("idle")
	
func attack():
	var rng = random.randi_range(0, 100)
	
	if rng < void_chance:
		pass
	elif rng >= void_chance and rng < (waves_chance + void_chance):
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
	elif rng >= (waves_chance + void_chance) and rng < (cyclone_chance + waves_chance + void_chance):
		for i in range(random.randi_range(cyclone_min_num_debris, cyclone_max_num_debris)):
			var debris = cyclone_debris_prefab.instantiate()
			debris.position = get_random_debris_point()
			debris.dmg = cyclone_debris_dmg
			$CycloneParent.add_child(debris)
			debris.get_node("Lifetime").wait_time = cyclone_debris_lifetime
			debris.get_node("Lifetime").start()
		global_cooldown.start()
	elif rng >= (cyclone_chance + waves_chance + void_chance) and rng < (boulder_chance + cyclone_chance + waves_chance + void_chance):
		var boulder = boulder_prefab.instantiate()
		boulder.position = self.global_position
		boulder.velocity = self.global_position.direction_to(target.position) * 200.0
		boulder.dmg = boulder_damage
		$ObjectParent.add_child(boulder)
		boulder.get_node("Lifetime").wait_time = boulder_lifetime
		boulder.get_node("Lifetime").start()
		global_cooldown.start()

func _on_damage_area_body_entered(body):
	print("entered...")
	if body.is_in_group("Player"):
		body.get_node("HealthComponent").modify_health(attack_damage)
		global_cooldown.start()
		
		var burn_timer = Timer.new()
		var burn_interval_timer = Timer.new()
		
		burn_timer.wait_time = burn_lifetime
		burn_interval_timer.wait_time = burn_tick_interval
		
		burn_timer.add_child(burn_interval_timer)
		
		burn_timer.autostart = false
		burn_interval_timer.autostart = false
		
		burn_timer.one_shot = true
		burn_interval_timer.one_shot = false
		
		burn_timer.timeout.connect(burn_timer.queue_free)
		burn_interval_timer.timeout.connect(burn_tick.bind(body, burn_dmg))
		
		body.add_child(burn_timer)
		
		burn_tick(body, burn_dmg)
		burn_interval_timer.start()
		burn_timer.start()

func burn_tick(body, dmg):
	body.get_node("HealthComponent").modify_health(dmg)

func get_random_debris_point():
	# Get Random Angle
	var angle := random.randf_range(0.0, 359.9)
	# Get Random Distance
	var distance := random.randf_range(50.0, cyclone_debris_radius)
	# Return Point
	return (Vector2(0.0, -1.0).rotated(angle) * distance)
