class_name FiendProjectile
extends CharacterBody2D

var lifetime := 0.0
var dmg := 0.0

func _ready():
	pass
	
func _process(delta):
	look_at(position + velocity)

func _physics_process(delta):
	move_and_collide(velocity)
	
func _on_damage_area_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("HealthComponent").modify_health(dmg)
		queue_free()

# Ensure that projectile does not live forever...
func _on_lifetime_timer_timeout():
	queue_free()
