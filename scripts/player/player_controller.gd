class_name PlayerController
extends CharacterBody2D

#############################
##      User Interface     ##
#############################
@onready var player_ui : Control = $UI/PlayerUI

#############################
##      Object Parent      ##
#############################
@onready var object_parent : Node = $ObjectParent

#############################
##       Components        ##
#############################
@onready var health_comp : HealthComponent = $HealthComponent

#############################
##     Cooldown  Nodes     ##
#############################
@onready var dash_cd : Timer = $Cooldowns/DashCooldown
@onready var weapon_attack_cd : Timer = $Cooldowns/WeaponAttackCooldown
@onready var alch_attack_cd : Timer = $Cooldowns/AlchAttackCooldown

#############################
##     Targeting Nodes     ##
#############################
@onready var weapon_attack_area : Area2D = $WeaponAttackArea
@onready var weapon_attack_shape : CollisionShape2D = $WeaponAttackArea/WeaponAttack
@onready var none_area : Area2D = $NoneArea
@onready var none_circle_shape : CollisionShape2D = $NoneArea/NoneCircle
@onready var air_area : Area2D = $AirArea
@onready var air_shape : CollisionShape2D = $AirArea/AirShape
@onready var heat_area : Area2D = $HeatArea
@onready var heat_shape : CollisionShape2D = $HeatArea/HeatShape
@onready var lava_area : Area2D = $LavaArea
@onready var lava_shape : CollisionShape2D = $LavaArea/LavaShape
@onready var dust_areas : Node2D = $DustAreas
@onready var dust_area_left : Area2D = $DustAreas/DustAreaLeft
@onready var dust_shape_left : CollisionShape2D = $DustAreas/DustAreaLeft/DustShapeLeft
@onready var dust_area_center : Area2D = $DustAreas/DustAreaCenter
@onready var dust_shape_center : CollisionShape2D = $DustAreas/DustAreaCenter/DustShapeCenter
@onready var dust_area_right : Area2D = $DustAreas/DustAreaRight
@onready var dust_shape_right : CollisionShape2D = $DustAreas/DustAreaRight/DustShapeRight

#############################
##       Buff  Nodes       ##
#############################
@onready var water_lifetime_timer : Timer = $Buffs/WaterLifetime
@onready var earth_lifetime_timer : Timer = $Buffs/EarthLifetime
@onready var steam_lifetime_timer : Timer = $Buffs/SteamLifetime
@onready var cloud_lifetime_timer : Timer = $Buffs/CloudLifetime
@onready var heat_lifetime_timer : Timer = $Buffs/HeatLifetime
@onready var air_timer : Timer = $AirTimer

#############################
##     Graphics Timers     ##
#############################
@onready var dust_gfx_timer : Timer = $DustAreas/DustTimer

#############################
##     Interval  Nodes     ##
#############################
@onready var water_soothe_interval_timer : Timer = $Intervals/WaterTick
@onready var heat_interval_timer : Timer = $Intervals/HeatTick

#############################
##       Heal  Nodes       ##
#############################
@onready var balsam_heal_delay_timer : Timer = $HealDelay

#############################
##      Graphic Nodes      ##
#############################
@onready var weapon_attack_sprite : AnimatedSprite2D = $WeaponSwingPivot/WeaponSwing
@onready var weapon_swing_pivot : Node2D = $WeaponSwingPivot
@onready var trail_timer : Timer = $WeaponSwingPivot/TrailTimer
@onready var alch_attack_pivot : Node2D = $AlchAttackPivot
@onready var alch_attack_sprite : AnimatedSprite2D = $AlchAttackPivot/AlchAttackSprite
@onready var player_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var dust_sprite_left : Node2D = $DustAreas/DustGFXLeft
@onready var dust_sprite_center : AnimatedSprite2D = $DustAreas/DustGFXCenter
@onready var dust_sprite_right : Node2D = $DustAreas/DustGFXRight

#############################
##     Buff  Variables     ##
#############################
var earth_active := false
var steam_active := false
var cloud_active := false

#############################
## Interactable  Variables ##
#############################
@onready var interactable_area : Area2D = $InteractableArea
var interactable_in_range := false
var in_menu := false

#############################
##    Overlap Variables    ##
#############################
var dust_bodies_left : Array = []
var dust_bodies_center : Array = []
var dust_bodies_right : Array = []

#############################
##  Checkpoint  Variables  ##
#############################
var last_checkpoint : Vector2 = Vector2.ZERO

#############################
##    Crasis  Variables    ##
#############################
var curr_crasis := 0

@export_category("Base Player Values")
@export var dash_power := 20.0
@export var move_speed := 300.0

@export_category("Balsam of Soot")
@export var num_balsam_available := 3
@export var max_num_balsam := 3
@export var balsam_heal_delay := 0.5
@export var balsam_heal_amount := 10.0

@export_category("Weapon Attack")
@export var weapon_attack_reach := 120.0
@export var weapon_attack_dmg := 5.0
@export var weapon_attack_cooldown_time := 0.5

@export_category("Alchemical Attack")
@export var alch_reagent := Enums.Reagents.NONE
@export_group("None")
@export var none_angle := 60.0
@export var none_range := 150.0
@export var none_dmg := 10.0
@export var none_cooldown_time := 10.0
@export_group("Fire")
@export var fire_projectile : PackedScene = null
@export var fire_projectile_speed := 10.0
@export var fire_burn_lifetime := 5.0
@export var fire_burn_tick_dmg := 3.0
@export var fire_burn_tick_interval := 0.5
@export var fire_initial_dmg := 10.0
@export var fire_cooldown_time := 10.0
@export_group("Water")
@export var water_soothe_lifetime := 5.0
@export var water_soothe_tick_dmg := 3.0
@export var water_soothe_tick_interval := 0.5
@export var water_initial_dmg := 10.0
@export var water_cooldown_time := 10.0
@export_group("Air")
@export var air_pushback_strength := 50.0
@export var air_radius := 150.0
@export var air_cooldown_time := 10.0
@export_group("Earth")
@export var earth_dmg_reduction_percent := 50.0
@export var earth_lifetime := 10.0
@export var earth_cooldown_time := 10.0
@export_group("Steam")
@export var steam_lifetime := 15.0
@export var steam_strength := 6.0
@export var steam_cooldown_time := 10.0
@export_group("Heat")
@export var heat_lifetime := 3.0
@export var heat_radius := 150.0
@export var heat_tick_dmg := 3.0
@export var heat_tick_interval := 0.5
@export var heat_cooldown_time := 10.0
@export_group("Lava")
@export var lava_plume : PackedScene = null
@export var lava_pillar_count := 3
@export var lava_pillar_damage := 10.0
@export var lava_radius := 10.0
@export var lava_cooldown_time := 10.0
@export_group("Cloud")
@export var cloud_lifetime := 5.0
@export var cloud_move_speed_percent := 30.0
@export var cloud_cooldown_time := 10.0
@export_group("Mud")
@export var mud_field : PackedScene = null
@export var mud_field_scale := 5.0
@export var mud_slow_percent := 30.0
@export var mud_field_lifetime := 5.0
@export var mud_cooldown_time := 10.0
@export_group("Dust")
@export var dust_angle := 45.0
@export var dust_dmg := 5.0
@export var dust_range := 100.0
@export var dust_width := 10.0
@export var dust_cooldown_time := 10.0

func _ready():
	# Weapon Attack Cooldown
	weapon_attack_cd.wait_time = weapon_attack_cooldown_time
	
	# Buffs
	water_lifetime_timer.wait_time = water_soothe_lifetime
	earth_lifetime_timer.wait_time = earth_lifetime
	steam_lifetime_timer.wait_time = steam_lifetime
	cloud_lifetime_timer.wait_time = cloud_lifetime
	heat_lifetime_timer.wait_time = heat_lifetime
	
	# Intervals
	water_soothe_interval_timer.wait_time = water_soothe_tick_interval
	heat_interval_timer.wait_time = heat_tick_interval
	
	# Heal Delay
	balsam_heal_delay_timer.wait_time = balsam_heal_delay
	
	# Shape Sizes
	none_circle_shape.shape.radius = none_range
	air_shape.shape.radius = air_radius
	heat_shape.shape.radius = heat_radius
	lava_shape.shape.radius = lava_radius
	dust_shape_left.shape.height = dust_range
	dust_shape_center.shape.height = dust_range
	dust_shape_right.shape.height = dust_range
	dust_shape_left.position.y = (-1.0 * (dust_range / 2.0))
	dust_shape_center.position.y = (-1.0 * (dust_range / 2.0))
	dust_shape_right.position.y = (-1.0 * (dust_range / 2.0))
	
	dust_area_left.rotate(deg_to_rad(-1.0 * (dust_angle / 2.0)))
	dust_area_right.rotate(deg_to_rad(dust_angle / 2.0))
	dust_sprite_left.rotate(deg_to_rad(-1.0 * (dust_angle / 2.0)))
	dust_sprite_right.rotate(deg_to_rad(dust_angle / 2.0))
	
	weapon_attack_shape.shape.size.y = weapon_attack_reach
	weapon_attack_shape.shape.size.x = weapon_attack_shape.shape.size.y / 4.0
	weapon_attack_shape.position.y = weapon_attack_shape.shape.size.y / 2.0
	
	weapon_attack_sprite.position.y = weapon_attack_shape.shape.size.y / -2.0
	
	# UI Hooking
	player_ui.get_node("HealthBar").health_comp_to_watch = health_comp
	player_ui.get_node("CooldownsBackground/Cooldowns/WeaponAttack").timer_to_watch = weapon_attack_cd
	player_ui.get_node("CooldownsBackground/Cooldowns/AlchAttack").timer_to_watch = alch_attack_cd
	player_ui.get_node("CooldownsBackground/Cooldowns/Dash").timer_to_watch = dash_cd
	player_ui.get_node("Balsams").player = self

func _physics_process(delta):
	# Handle resting.
	if in_menu:
		return
	
	# Handle Cloud buff.
	var speed_buff = 1.0
	
	if cloud_active:
		speed_buff += cloud_move_speed_percent / 100.0
	
	# Handle movement.
	if air_timer.is_stopped():
		var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
		
		if direction:
			velocity = direction * move_speed * speed_buff
		else:
			velocity = Vector2(move_toward(velocity.x, 0, move_speed), move_toward(velocity.y, 0, move_speed))
			
		# Handle dash.
		if Input.is_action_pressed("dash") and dash_cd.is_stopped():
			velocity = direction * move_speed * speed_buff * dash_power
			dash_cd.start()
		
	# Handle animations.
	if velocity.x != 0.0 or velocity.y != 0.0:
		if abs(velocity.x) > abs(velocity.y):
			# Moving more horizontally than vertically...
			if velocity.x > 0.0:
				# Moving Right...
				player_sprite.animation = "walk_side"
				player_sprite.flip_h = false
			else:
				# Moving left...
				player_sprite.animation = "walk_side"
				player_sprite.flip_h = true
		else:
			if velocity.y > 0.0:
				# Moving down...
				player_sprite.animation = "walk_down"
				player_sprite.flip_h = false
			else:
				# Moving up...
				player_sprite.animation = "walk_up"
				player_sprite.flip_h = false
	else:
		if !player_sprite.animation.contains("idle"):
			match player_sprite.animation:
				"walk_side":
					player_sprite.animation = "idle_side"
				"walk_down":
					player_sprite.animation = "idle_down"
				"walk_up":
					player_sprite.animation = "idle_up"

	move_and_slide()

func _process(delta):
	# Handle resting.
	if in_menu:
		return
		
	# Handle interact.
	if Input.is_action_just_pressed("interact"):
		var interactables = interactable_area.get_overlapping_areas()
		if interactables.size() > 0:
			interactables[0].get_parent().interact(self)
	
	# Handle weapon attack.
	if Input.is_action_pressed("weapon_atk"):
		weapon_attack()
	
	# Handle alchemical attack.
	if Input.is_action_pressed("alch_atk"):
		alchemical_attack()
		
	# Handle heal.
	if Input.is_action_just_pressed("heal"):
		if num_balsam_available > 0:
			balsam_heal_delay_timer.start()
			
	# Handle Interact Popup
	if interactable_in_range:
		player_ui.get_node("InteractPopup").visible = true
	else:
		player_ui.get_node("InteractPopup").visible = false

#############################
##    Helper  Functions    ##
#############################

func weapon_attack():
	if !weapon_attack_cd.is_stopped():
		return
	
	weapon_attack_area.look_at(get_global_mouse_position())
	weapon_attack_area.rotate(deg_to_rad(-90.0))
	
	weapon_swing_pivot.look_at(get_global_mouse_position())
	weapon_swing_pivot.rotate(deg_to_rad(90.0))
		
	weapon_attack_sprite.visible = true
	weapon_attack_sprite.play()
	weapon_attack_shape.disabled = false
	trail_timer.start()
	
	weapon_attack_cd.start()

func alchemical_attack():
	# If cooldown timer is running, return...
	if !alch_attack_cd.is_stopped():
		return
	
	# Not running, activate alch attack...
	match alch_reagent:
		Enums.Reagents.NONE:
			# Get outter boundary angles...
			var boundary = none_angle / 2.0
			var hits = []
			
			# Traverse all bodies in the circle around the player...
			# If the absolute value of the angle between the direction to the enemy and
			# the direction to the mouse is less than than the boundary angle, it is inside of the cone...
			for body in none_area.get_overlapping_bodies():
				var dir_to_enemy = position.direction_to(body.position)
				var angle = get_mouse_dir().angle_to(dir_to_enemy)
				if abs(rad_to_deg(angle)) < boundary:
					hits.append(body)
			
			# Apply damage to everything found inside the cone...s
			for hit in hits:
				hit.get_node("HealthComponent").modify_health(none_dmg)
			
			alch_attack_cd.wait_time = none_cooldown_time
			
			alch_attack_pivot.look_at(get_global_mouse_position())
			alch_attack_pivot.rotate(deg_to_rad(90.0))
			
			alch_attack_sprite.visible = true
			alch_attack_sprite.play("none")
			alch_attack_sprite.animation_finished.connect(hide_anim.bind(alch_attack_sprite))
			
		Enums.Reagents.FIRE:
			# Instantiate new projectile...
			var projectile = fire_projectile.instantiate()
			
			# Apply necessary stats and velocity...
			projectile.lifetime = fire_burn_lifetime
			projectile.initial_dmg = fire_initial_dmg
			projectile.burn_dmg = fire_burn_tick_dmg
			projectile.burn_tick_interval = fire_burn_tick_interval
			projectile.position = self.position
			projectile.velocity = get_mouse_dir() * fire_projectile_speed
			
			# Add to normal node to decouple movement with player...
			object_parent.add_child(projectile)
			
			alch_attack_cd.wait_time = fire_cooldown_time
		Enums.Reagents.WATER:
			# Apply initial heal
			health_comp.modify_health(-1.0 * water_initial_dmg)
			# Perform initial tick
			soothe_tick()
			# Start tick timer
			water_soothe_interval_timer.start()
			# Start buff timer
			water_lifetime_timer.start()
			
			alch_attack_cd.wait_time = water_cooldown_time
		Enums.Reagents.AIR:
			# Get all bodies in range for the attack...
			var bodies = air_area.get_overlapping_bodies()
			
			# Traverse all bodies found in the area...
			for body in bodies:
				# Get direction to shove...
				var dir = self.position.direction_to(body.position)
				body.is_knocked_back = true
				if body.get_node("AirTimer"):
					body.get_node("AirTimer").start()
				# Apply force...
				body.velocity += (dir * air_pushback_strength)
			
			$HeatGFX.visible = true
			$HeatGFX/AnimationPlayer.play("air_burst")
			#$HeatGFX/AnimationPlayer.animation_finished.connect(hide_anim.bind($HeatGFX))
			await $HeatGFX/AnimationPlayer.animation_finished
			$HeatGFX.visible = false
			alch_attack_cd.wait_time = air_cooldown_time
		Enums.Reagents.EARTH:
			# Mark buff as active...
			earth_active = true
			# Start lifetime timer...
			earth_lifetime_timer.start()
			
			$AnimatedSprite2D/AnimationPlayer.play("earth_buff")
			
			alch_attack_cd.wait_time = earth_cooldown_time
		Enums.Reagents.STEAM:
			# Mark buff as active...
			steam_active = true
			# Start lifetime timer...
			steam_lifetime_timer.start()
			
			$AnimatedSprite2D/AnimationPlayer.play("steam_buff")
			
			alch_attack_cd.wait_time = steam_cooldown_time
		Enums.Reagents.HEAT:
			# Perform initial tick
			heat_tick()
			# Start tick timer
			heat_interval_timer.start()
			# Start buff timer
			heat_lifetime_timer.start()
			$HeatGFX.visible = true
			
			alch_attack_cd.wait_time = heat_cooldown_time
		Enums.Reagents.LAVA:
			#var origin = (lava_shape.global_position - lava_shape.shape.extents)
			
			# For number of pillars to spawn...
			for i in range(lava_pillar_count):
				# Create new lava plume...
				var plume = lava_plume.instantiate()
				# Set plume dmg...
				plume.dmg = lava_pillar_damage
				# Set spawn position to random point in range...
				#plume.position = get_random_point(origin, lava_shape.shape.extents)
				plume.position = get_random_lava_point()
				# Add to normal node to decouple movement with player...
				object_parent.add_child(plume)
			
			alch_attack_cd.wait_time = lava_cooldown_time
		Enums.Reagents.CLOUD:
			# Mark buff as active...
			cloud_active = true
			# Start lifetime timer...
			cloud_lifetime_timer.start()
			
			$AnimatedSprite2D/AnimationPlayer.play("cloud_buff")
			
			alch_attack_cd.wait_time = cloud_cooldown_time
		Enums.Reagents.MUD:
			# Instantiate new field...
			var field = mud_field.instantiate()
			
			# Apply necessary stats
			field.get_node("Lifetime").wait_time = mud_field_lifetime
			field.slow_percent = mud_slow_percent
			field.scale = field.scale * mud_field_scale
			
			# Set position
			field.position = get_global_mouse_position()
			
			# Add to normal node to decouple movement with player...
			object_parent.add_child(field)
			
			alch_attack_cd.wait_time = mud_cooldown_time
		Enums.Reagents.DUST:
			# Rotate to point towards the cursor...
			dust_areas.look_at(get_global_mouse_position())
			dust_areas.rotate(deg_to_rad(90.0))
			
			var seen = []
			
			# Only target each body once...
			"""for body in dust_area_left.get_overlapping_bodies():
				if body not in hits and body.is_in_group("Enemy"):
					hits.append(body)
				
			for body in dust_area_center.get_overlapping_bodies():
				if body not in hits and body.is_in_group("Enemy"):
					hits.append(body)
				
			for body in dust_area_right.get_overlapping_bodies():
				if body not in hits and body.is_in_group("Enemy"):
					hits.append(body)"""
					
			for body in dust_bodies_left:
				if !seen.has(body):
					body.get_node("HealthComponent").modify_health(dust_dmg)
					seen.append(body)
			
			# Apply damage...
			#for hit in hits:
			#	hit.get_node("HealthComponent").modify_health(dust_dmg)
				
			dust_areas.visible = true
			dust_gfx_timer.start()
			
			alch_attack_cd.wait_time = dust_cooldown_time
	
	# Start cooldown timer...
	alch_attack_cd.start()
	
#############################
##    Utility Functions    ##
#############################

func get_mouse_dir():
	return (get_global_mouse_position() - self.position).normalized()
	
func get_random_lava_point():
	# Get Random Angle
	var angle := randf_range(0.0, 359.9)
	# Get Random Distance
	var distance := randf_range(50.0, lava_radius)
	# Return Point
	return global_position + (Vector2(0.0, -1.0).rotated(angle) * distance)
	
func hide_anim(sprite):
	sprite.visible = false
	
func show_boss_bar(boss):
	player_ui.get_node("BossHealthBar").visible = true
	#player_ui.get_node("BossHealthBar/HealthBar").max_value = boss.get_node("HealthComponent").max_health
	player_ui.get_node("BossHealthBar/BossTitle").text = "[center][outline_color=black][outline_size=8]" + boss.display_name + "[/outline_size][/outline_color][/center]"
	
	player_ui.get_node("BossHealthBar/HealthBar").health_comp_to_watch = boss.get_node("HealthComponent")
	
func remove_boss_bar():
	player_ui.get_node("BossHealthBar").visible = false
	player_ui.get_node("BossDefeatPopup").visible = true
	await get_tree().create_timer(3.0).timeout
	player_ui.get_node("BossDefeatPopup").visible = false

func hide_boss_bar():
	player_ui.get_node("BossHealthBar").visible = false
	
func update_location(loc):
	player_ui.get_node("LocationPopup").text = "[center][outline_color=black][outline_size=8]" + loc + "[/outline_size][/outline_color][/center]"
	player_ui.get_node("LocationPopup").visible = true
	
func hide_location():
	player_ui.get_node("LocationPopup").visible = false

#############################
##     Timer Functions     ##
#############################

func soothe_tick():
	# Apply heal tick...
	health_comp.modify_health(-water_soothe_tick_dmg)

func heat_tick():
	# Get all bodies overlapping the heat area...
	var bodies = heat_area.get_overlapping_bodies()
	
	# Traverse all bodies and apply damage...
	for body in bodies:
		body.get_node("HealthComponent").modify_health(heat_tick_dmg)
		
	$HeatGFX/AnimationPlayer.play("heat_flash")

func _on_water_lifetime_timeout():
	water_soothe_interval_timer.stop()

func _on_earth_lifetime_timeout():
	earth_active = false
	$AnimatedSprite2D/AnimationPlayer.stop()

func _on_steam_lifetime_timeout():
	steam_active = false
	$AnimatedSprite2D/AnimationPlayer.stop()

func _on_cloud_lifetime_timeout():
	cloud_active = false
	$AnimatedSprite2D/AnimationPlayer.stop()

func _on_heat_lifetime_timeout():
	heat_interval_timer.stop()
	$HeatGFX.visible = false

func _on_water_tick_timeout():
	soothe_tick()

func _on_heat_tick_timeout():
	heat_tick()

func _on_heal_delay_timeout():
	health_comp.modify_health(-1.0 * balsam_heal_amount)
	num_balsam_available -= 1

func _on_trail_timer_timeout():
	weapon_attack_sprite.visible = false

func _on_weapon_attack_area_body_entered(body):
	var add_steam_dmg = 0.0
	if steam_active:
		add_steam_dmg += steam_strength
	
	body.get_node("HealthComponent").modify_health(weapon_attack_dmg + add_steam_dmg)

func _on_weapon_attack_cooldown_timeout():
	weapon_attack_shape.disabled = true

func _on_dust_timer_timeout():
	dust_areas.visible = false

func _on_health_component_dead():
	SceneDirector.reload_curr_scene()

func _on_dust_area_left_body_entered(body):
	if body not in dust_bodies_left:
		dust_bodies_left.append(body)

func _on_dust_area_center_body_entered(body):
	if body not in dust_bodies_center:
		dust_bodies_center.append(body)

func _on_dust_area_right_body_entered(body):
	if body not in dust_bodies_right:
		dust_bodies_right.append(body)

func _on_dust_area_left_body_exited(body):
	if body in dust_bodies_left:
		dust_bodies_left.erase(body)

func _on_dust_area_center_body_exited(body):
	if body in dust_bodies_center:
		dust_bodies_center.erase(body)

func _on_dust_area_right_body_exited(body):
	if body in dust_bodies_right:
		dust_bodies_right.erase(body)
