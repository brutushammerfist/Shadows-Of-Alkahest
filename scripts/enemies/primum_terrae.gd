class_name PrimumTerraeController
extends EnemyController

@export var crystal_spike_prefab : PackedScene
@export var boulder_prefab : PackedScene

@export var fracture_chance := 10.0
@export var fracture_damage := 2.0
@export var boulder_toss_chance := 15.0
@export var boulder_damage := 3.0
@export var boulder_lifetime := 10.0

func _ready():
	super()
	
func _process(delta):
	pass
	
func attack():
	var rng = random.randi_range(0, 100)
	if rng < fracture_chance and $SpecialCooldown.is_stopped():
		for pos_offset in get_fracture_points():
			var spike = crystal_spike_prefab.instantiate()
			spike.position = self.position + pos_offset
			spike.dmg = fracture_damage
			$ObjectParent.add_child(spike)
			spike.get_node("AnimatedSprite2D/AnimationPlayer").play("spawn")
			
		$SpecialCooldown.start()
	elif rng >= fracture_chance and rng < boulder_toss_chance + fracture_chance and $SpecialCooldown.is_stopped():
		var boulder = boulder_prefab.instantiate()
		boulder.position = self.global_position
		boulder.velocity = self.global_position.direction_to(target.position) * 200.0
		boulder.dmg = boulder_damage
		$ObjectParent.add_child(boulder)
		boulder.get_node("Lifetime").wait_time = boulder_lifetime
		boulder.get_node("Lifetime").start()
		
		$SpecialCooldown.start()

func get_fracture_points():
	var positions = []
	
	#for FracturePaths.get_
	for path in $FracturePaths.get_children():
		for i in range(path.curve.point_count):
			positions.append(path.curve.get_point_position(i).rotated(deg_to_rad(path.rotation_degrees)))
			
	return positions

func _on_damage_area_body_entered(body):
	if body.is_in_group("Player") and global_cooldown.is_stopped():
		body.get_node("HealthComponent").modify_health(attack_damage)
		
		global_cooldown.start()
