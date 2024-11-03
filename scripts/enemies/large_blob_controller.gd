class_name LargeBlobController
extends EnemyController

func _ready():
	super()
	$ChargeTimer.wait_time = charge_windup
	$ChargeLifetime.wait_time = charge_lifetime
	$ChargeCooldown.wait_time = charge_cooldown
	
func _process(delta):
	#super()
	var charge_rng = random.randi_range(0, 100)
	if (charge_rng < charge_chance) and $ChargeCooldown.is_stopped() and !is_charging_attack and target:
		is_charging_attack = true
		$ChargeTimer.start()
	
func attack():
	#var chnce = random.randi_range(0, 100)
	#if chnce <= 50:
	#	for body in $DamageArea.get_overlapping_bodies():
	#		if body.is_in_group("Player"):
	#			body.get_node("HealthComponent").modify_health(attack_damage)
	pass

func _on_charge_timer_timeout():
	is_charging_attack = false
	charge_dir = position.direction_to(target.position)
	charge_active = true
	global_cooldown.start()
	$DamageArea.body_entered.connect(_on_damage_area_body_entered)
	$ChargeLifetime.start()
	#$ChargeCooldown.stawwrt()
	
func _on_charge_lifetime_timeout():
	charge_active = false
	$ChargeCooldown.start()

func _on_damage_area_body_entered(body):
	#if charge_active and body.is_in_group("Player") and $GlobalCooldown.is_stopped():
	if body.is_in_group("Player") and $GlobalCooldown.is_stopped():
		body.get_node("HealthComponent").modify_health(attack_damage)
		global_cooldown.start()

func _on_air_timer_timeout():
	is_knocked_back = false
