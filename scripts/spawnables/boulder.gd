class_name Boulder
extends CharacterBody2D

var dmg := 3.0

func _physics_process(delta):
	move_and_slide()

func _on_damage_area_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("HealthComponent").modify_health(dmg)
		queue_free()
