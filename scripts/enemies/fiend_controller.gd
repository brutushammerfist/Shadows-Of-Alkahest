class_name FiendController
extends EnemyController

@onready var projectile_charge_timer : Timer = $ProjectileCharge

@export var projectile : PackedScene = null
@export var proj_charge_time = 1.0

func _ready():
	super()
	
	projectile_charge_timer.wait_time = proj_charge_time

#func _physics_process(delta):
#	super(delta)

func attack():
	is_charging_attack = true
	var proj = projectile.instantiate()
	proj.dmg = attack_damage
	$ChargeProjPos.add_child(proj)
	projectile_charge_timer.start()
	await projectile_charge_timer.timeout
	if is_instance_valid(proj):
		var pos = proj.global_position
		$ChargeProjPos.remove_child(proj)
		$ObjectParent.add_child(proj)
		proj.position = pos
		proj.get_node("AnimatedSprite2D").play("flying")
		proj.velocity = self.position.direction_to(target.position) * 5.0
		
		global_cooldown.start()
		is_charging_attack = false

func _on_air_timer_timeout():
	is_knocked_back = false
