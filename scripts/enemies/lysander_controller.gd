class_name LysanderController
extends EnemyController

@onready var weapon_attack_area : Area2D = $WeaponAttackArea
@onready var weapon_attack_shape : CollisionShape2D = $WeaponAttackArea/WeaponAttack
@onready var weapon_swing_pivot : Node2D = $WeaponSwingPivot
@onready var weapon_attack_sprite : AnimatedSprite2D = $WeaponSwingPivot/WeaponSwing
@onready var trail_timer : Timer = $WeaponSwingPivot/TrailTimer
@onready var air_area : Area2D = $AirArea
@onready var air_shape : CollisionShape2D = $AirArea/AirShape

@export var weapon_attack_chance := 60.0
@export var weapon_attack_dmg := 4.0

@export var air_attack_chance := 20.0
@export var air_attack_force := 100.0
var air_area_bodies = []

@export var steam_attack_chance := 15.0
@export var steam_strength := 20.0
@export var steam_lifetime := 5.0

var is_dead := false

func _ready():
	super()
	
	weapon_attack_shape.shape.size.y = 120.0
	weapon_attack_shape.shape.size.x = weapon_attack_shape.shape.size.y / 4.0
	weapon_attack_shape.position.y = weapon_attack_shape.shape.size.y / 2.0
	
	$SteamBuff.wait_time = steam_lifetime
	
func _process(delta):
	if is_dead:
		return
		
	if global_cooldown.is_stopped() and target:
		attack()

func _physics_process(delta):
	if is_dead:
		return
		
	if target:
		velocity = position.direction_to(target.position) * (move_speed * (1.0 - (mud_slow_percent / 100.0)))
	
	if velocity.x != 0.0 or velocity.y != 0.0:
		if abs(velocity.x) > abs(velocity.y):
			# Moving more horizontally than vertically...
			if velocity.x > 0.0:
				# Moving Right...
				sprite.animation = "walk_side"
				sprite.flip_h = false
			else:
				# Moving left...
				sprite.animation = "walk_side"
				sprite.flip_h = true
		else:
			if velocity.y > 0.0:
				# Moving down...
				sprite.animation = "walk_down"
				sprite.flip_h = false
			else:
				# Moving up...
				sprite.animation = "walk_up"
				sprite.flip_h = false
				
	move_and_slide()
	
func attack():
	if global_cooldown.is_stopped():
		var rng = random.randi_range(0, 100)
		
		if rng < weapon_attack_chance:
			weapon_attack_area.look_at(target.position)
			weapon_attack_area.rotate(deg_to_rad(-90.0))
			
			weapon_swing_pivot.look_at(target.position)
			weapon_swing_pivot.rotate(deg_to_rad(90.0))
			
			weapon_attack_sprite.visible = true
			weapon_attack_sprite.play()
			weapon_attack_shape.disabled = false
			trail_timer.start()
			
			global_cooldown.start()
		elif rng >= weapon_attack_chance and rng < (air_attack_chance + weapon_attack_chance):
			# Traverse all bodies found in the area...
			for body in air_area_bodies:
				# Get direction to shove...
				var dir = self.position.direction_to(body.position)
				if body.get_node("AirTimer"):
					body.get_node("AirTimer").start()
				# Apply force...
				body.velocity += (dir * air_attack_force)
			
			$HeatGFX.visible = true
			$HeatGFX/AnimationPlayer.play("air_burst")
			await $HeatGFX/AnimationPlayer.animation_finished
			$HeatGFX.visible = false
			
			global_cooldown.start()
		elif rng >= (air_attack_chance + weapon_attack_chance) and rng < (steam_attack_chance + air_attack_chance + weapon_attack_chance):
			# apply steam buff
			$SteamBuff.start()
			$AnimatedSprite2D/AnimationPlayer.play("buffed")
			
func hide_anim(sprite):
	sprite.visible = false

func _on_weapon_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		var scaler = 1.0
		
		if !$SteamBuff.is_stopped():
			scaler += (steam_strength / 100.0)
		
		body.get_node("HealthComponent").modify_health(attack_damage * scaler)
		global_cooldown.start()

func _on_health_component_dead():
	is_dead = true
	sprite.play("death")
	SceneDirector.lysander_dead(self.position)

func _on_trail_timer_timeout():
	weapon_attack_sprite.visible = false
	weapon_attack_shape.disabled = true

func _on_air_area_body_entered(body):
	air_area_bodies.append(body)

func _on_air_area_body_exited(body):
	air_area_bodies.erase(body)

func _on_steam_buff_timeout():
	$AnimatedSprite2D/AnimationPlayer.stop()
