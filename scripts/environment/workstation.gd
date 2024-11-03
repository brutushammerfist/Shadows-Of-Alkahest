class_name Workstation
extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_interactable_area_body_entered(body):
	if body.is_in_group("Player"):
		body.interactable_in_range = true
		
func _on_interactable_area_body_exited(body):
	if body.is_in_group("Player"):
		body.interactable_in_range = false

func interact(interacter):
	interacter.num_balsam_available = interacter.max_num_balsam
	interacter.health_comp.modify_health(-1.0 * interacter.health_comp.max_health)
	interacter.in_menu = true
	
	SceneDirector.workstation_reload()

	interacter.get_node("UI/WorkstationMenu").visible = true
	interacter.set_process_input(false)
	
	interacter.last_checkpoint = $SpawnPoint.global_position
