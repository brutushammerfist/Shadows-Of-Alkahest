class_name PrimumAereController
extends EnemyController

@export var cyclone_debris_prefab : PackedScene
@export var cyclone_debris_dmg := 2.0
@export var cyclone_debris_radius := 500.0
@export var cyclone_debris_lifetime := 5.0
@export var cyclone_max_num_debris := 10
@export var cyclone_min_num_debris := 3
@export var cyclone_chance := 20.0
@export var cyclone_rotation_speed := 1.0

@export var cannon_prefab : PackedScene
@export var cannon_dmg := 4.0
@export var cannon_lifetime := 10.0
@export var cannon_chance := 25.0

func _ready():
	super()
	
func _process(delta):
	$CycloneParent.rotate(deg_to_rad(cyclone_rotation_speed))
	
func attack():
	var rng = random.randi_range(0, 100)
	if rng < cyclone_chance and $SpecialCooldown.is_stopped():
		for i in range(random.randi_range(cyclone_min_num_debris, cyclone_max_num_debris)):
			var debris = cyclone_debris_prefab.instantiate()
			debris.position = get_random_debris_point()
			debris.dmg = cyclone_debris_dmg
			$CycloneParent.add_child(debris)
			debris.get_node("Lifetime").wait_time = cyclone_debris_lifetime
			debris.get_node("Lifetime").start()
		$SpecialCooldown.start()
	elif rng >= cyclone_chance and rng < (cannon_chance + cyclone_chance) and $SpecialCooldown.is_stopped():
		var cannon = cannon_prefab.instantiate()
		cannon.position = self.global_position
		cannon.dmg = cannon_dmg
		$ObjectParent.add_child(cannon)
		cannon.velocity = self.position.direction_to(target.position) * 250.0
		cannon.get_node("Lifetime").wait_time = cannon_lifetime
		cannon.get_node("Lifetime").start()
		$SpecialCooldown.start()
		

func _on_damage_area_body_entered(body):
	if body.is_in_group("Player") and global_cooldown.is_stopped():
		body.get_node("HealthComponent").modify_health(attack_damage)
		global_cooldown.start()

func get_random_debris_point():
	# Get Random Angle
	var angle := random.randf_range(0.0, 359.9)
	# Get Random Distance
	var distance := random.randf_range(50.0, cyclone_debris_radius)
	# Return Point
	return (Vector2(0.0, -1.0).rotated(angle) * distance)
