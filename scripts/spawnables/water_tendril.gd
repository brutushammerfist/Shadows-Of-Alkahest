class_name WaterTendril
extends Area2D

var dmg := 2.0

func _on_lifetime_timeout():
	$AnimatedSprite2D.play("crash")
	await $AnimatedSprite2D.animation_finished
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			body.get_node("HealthComponent").modify_health(dmg)
	queue_free()
