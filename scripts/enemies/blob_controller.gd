class_name BlobController
extends EnemyController

func attack():
	is_charging_attack = false
	for body in $DamageArea.get_overlapping_bodies():
		if body.is_in_group("Player"):
			body.get_node("HealthComponent").modify_health(attack_damage)
			global_cooldown.start()

func _on_air_timer_timeout():
	is_knocked_back = false
