class_name Cannon
extends CharacterBody2D

var dmg := 4.0

func _process(delta):
	look_at(position + velocity)

func _physics_process(delta):
	move_and_slide()

func _on_lifetime_timeout():
	queue_free()

func _on_damage_area_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("HealthComponent").modify_health(dmg)
