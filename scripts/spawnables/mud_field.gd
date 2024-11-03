class_name MudField
extends Area2D

var slow_percent := 0.0
 
func _on_lifetime_timeout():
	for body in get_overlapping_bodies():
		if body.is_in_group("Enemy"):
			body.mud_slow_percent = 0.0
	
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.mud_slow_percent = slow_percent
