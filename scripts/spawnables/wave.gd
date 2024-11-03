class_name Wave
extends CharacterBody2D

var dmg := 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(position + velocity)
	rotate(deg_to_rad(90.0))
	
func _physics_process(delta):
	move_and_slide()

func _on_damage_area_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("HealthComponent").modify_health(dmg)

func _on_lifetime_timeout():
	print("Wave timing out...")
	queue_free()
