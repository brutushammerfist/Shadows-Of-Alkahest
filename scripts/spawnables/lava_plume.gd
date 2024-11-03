class_name LavaPlume
extends Area2D

var dmg := 0.0

func _on_detonator_timeout():
	print("Detonator Timeout")
	for body in get_overlapping_bodies():
		if body.is_in_group("Enemy"):
			body.get_node("HealthComponent").modify_health(dmg)
	
	$AnimatedSprite2D.play("default")
	
	await $AnimatedSprite2D.animation_finished
	
	queue_free()
