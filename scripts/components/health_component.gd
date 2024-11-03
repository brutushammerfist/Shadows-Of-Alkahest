class_name HealthComponent
extends Node

signal Dead

@export var curr_health := 10.0
@export var max_health := 10.0

func modify_health(dmg):
	var scaler = 1.0
	
	if get_parent().is_in_group("Player"):
		if get_parent().earth_active and dmg > 0.0:
			scaler -= (get_parent().earth_dmg_reduction_percent / 100.0)
		if get_parent().in_menu:
			# Take no damage if resting...
			scaler = 0.0
			
	#if get_parent().is_in_group("Enemy"):
	#	print("Enemy taking damage...")
	#	print(dmg)
	
	if dmg > 0.0 and scaler != 0.0:
		#get_parent().get_node("AnimatedSprite2D/AnimationPlayer").play("flash")
		"""if get_parent().is_in_group("Player"):
			if !get_parent().get_node("AnimatedSprite2D/AnimationPlayer").is_playing():
				get_parent().get_node("AnimatedSprite2D/AnimationPlayer").play("flash")
		else:
			get_parent().get_node("AnimatedSprite2D/AnimationPlayer").play("flash")"""
		if is_instance_valid(get_parent().get_node("AnimatedSprite2D/AnimationPlayer")):
			if !get_parent().get_node("AnimatedSprite2D/AnimationPlayer").is_playing():
				get_parent().get_node("AnimatedSprite2D/AnimationPlayer").play("flash")
		
	curr_health = clampf((curr_health - (dmg * scaler)), 0.0, max_health)
	if curr_health == 0.0:
		Dead.emit()
