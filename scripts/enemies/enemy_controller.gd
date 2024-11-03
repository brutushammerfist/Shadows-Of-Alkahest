class_name EnemyController
extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var global_cooldown = $GlobalCooldown

@export var display_name := ""
@export var crasis_value := 0
@export var move_speed := 150.0
@export var global_cooldown_time := 3.0
@export var is_melee := false
@export var max_optimal_range := 10.0
@export var min_optimal_range := 5.0
@export var attack_damage := 2.0
@export var attack_reach := 100.0
@export var charge_windup := 2.0
@export var charge_strength := 5.0
@export var charge_chance := 20
@export var charge_lifetime := 1.5
@export var charge_cooldown := 15.0
@export var boss_catalyst_to_grant := Enums.Reagents.FIRE
@export var stationary := false

var charge_dir := Vector2.ZERO

var random : RandomNumberGenerator = null

var mud_slow_percent = 0.0
var target : Node2D = null
var is_charging_attack : bool = false
var charge_active : bool = false
var is_knocked_back : bool = false

func _ready():
	random = RandomNumberGenerator.new()
	random.randomize()
	get_node("AnimatedSprite2D/AnimationPlayer").play("flash")
	
	global_cooldown.wait_time = global_cooldown_time

func _physics_process(delta):
	if self.is_in_group("Boss") or !is_knocked_back:
		if target and !stationary:
			if is_charging_attack:
				velocity = Vector2.ZERO
			elif charge_active:
				velocity = charge_dir * (move_speed * charge_strength)
			else:
				if is_melee:
					velocity = position.direction_to(target.position) * (move_speed * (1.0 - (mud_slow_percent / 100.0)))
				else:
					if self.position.distance_to(target.position) > max_optimal_range:
						velocity = position.direction_to(target.position) * (move_speed * (1.0 - (mud_slow_percent / 100.0)))
					elif self.position.distance_to(target.position) < min_optimal_range:
						velocity = -1.0 * position.direction_to(target.position) * (move_speed * (1.0 - (mud_slow_percent / 100.0)))
					else:
						velocity = Vector2(move_toward(velocity.x, 0, (move_speed * (1.0 - (mud_slow_percent / 100.0)))), move_toward(velocity.y, 0, (move_speed * (1.0 - (mud_slow_percent / 100.0)))))
		else:
			velocity = Vector2(move_toward(velocity.x, 0, (move_speed * (1.0 - (mud_slow_percent / 100.0)))), move_toward(velocity.y, 0, (move_speed * (1.0 - (mud_slow_percent / 100.0)))))
	
	if velocity.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
		
	if velocity.x != 0.0 or velocity.y != 0.0:
		# Moving...
		sprite.play("walk")
	else:
		sprite.play("idle")
		
	if global_cooldown.is_stopped() and target != null and !is_charging_attack:
		attack()
	
	move_and_slide()

func _on_health_component_dead():
	sprite.play("death")
	#await sprite.animation_finished
	if self.is_in_group("Boss"):
		# Clear Boss Bar from UI
		SceneDirector.boss_dead(self.global_position)
		GameDirector.unlocked_primum_essentia[boss_catalyst_to_grant] = true
	
	queue_free()

func _on_vision_area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		
		if self.is_in_group("Boss"):
			body.show_boss_bar(self)
		
		if self.get_node("SpecialCooldown"):
			self.get_node("SpecialCooldown").start()

func attack():
	print("Attack not written for " + self.name)

func _on_air_timer_timeout():
	is_knocked_back = false
