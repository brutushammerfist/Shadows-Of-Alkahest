class_name HealthBar
extends TextureProgressBar

var health_comp_to_watch : HealthComponent = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(health_comp_to_watch):
		#var percent = health_comp_to_watch.curr_health / health_comp_to_watch.max_health
		
		value = (health_comp_to_watch.curr_health / health_comp_to_watch.max_health) * 100.0
