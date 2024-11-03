class_name FireTrail
extends Area2D

var bodies := []
var dmg := 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print("Entered...")
	bodies.append(body)
	
func _on_body_exited(body):
	#for bodi in bodies:
	#	if bodi == body:
	#		bodies.erase()
	bodies.erase(body)

func burn_tick():
	for body in bodies:
		if body.is_in_group("Player"):
			body.get_node("HealthComponent").modify_health(dmg)

func _on_burn_tick_timeout():
	burn_tick()
