class_name CycloneDebris
extends Area2D

var dmg := 2.0

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("HealthComponent").modify_health(dmg)

func _on_lifetime_timeout():
	queue_free()
