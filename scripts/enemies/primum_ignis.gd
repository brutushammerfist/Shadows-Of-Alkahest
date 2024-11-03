class_name PrimumIgnisController
extends EnemyController

@export var fire_trail_prefab : PackedScene
@export var fire_trail_damage := 1.0

@export var burn_lifetime = 3.0
@export var burn_tick_interval = 1.0
@export var burn_dmg := 1.0

var last_placed_fire_pos := Vector2.ZERO

func _ready():
	super()
	$ChargeTimer.wait_time = charge_windup
	$ChargeLifetime.wait_time = charge_lifetime
	$ChargeCooldown.wait_time = charge_cooldown
	
func _process(delta):
	var charge_rng = random.randi_range(0, 100)
	if (charge_rng < charge_chance) and $ChargeCooldown.is_stopped() and !is_charging_attack and is_instance_valid(target):
		is_charging_attack = true
		$ChargeTimer.start()
		
	if charge_active and (last_placed_fire_pos.distance_to(self.global_position) > 50.0):
		var trail = fire_trail_prefab.instantiate()
		trail.dmg = fire_trail_damage
		trail.global_position = self.global_position
		last_placed_fire_pos = self.global_position
		$ObjectParent.add_child(trail)
	
func attack():
	pass

func _on_charge_timer_timeout():
	is_charging_attack = false
	charge_dir = position.direction_to(target.position)
	charge_active = true
	global_cooldown.start()
	$DamageArea.body_entered.connect(_on_damage_area_body_entered)
	$ChargeLifetime.start()
	
func _on_charge_lifetime_timeout():
	charge_active = false
	$ChargeCooldown.start()

func _on_damage_area_body_entered(body):
	if body.is_in_group("Player") and $GlobalCooldown.is_stopped():
		body.get_node("HealthComponent").modify_health(attack_damage)
		global_cooldown.start()

		var burn_timer = Timer.new()
		var burn_interval_timer = Timer.new()
		
		burn_timer.wait_time = burn_lifetime
		burn_interval_timer.wait_time = burn_tick_interval
		
		burn_timer.add_child(burn_interval_timer)
		
		burn_timer.autostart = false
		burn_interval_timer.autostart = false
		
		burn_timer.one_shot = true
		burn_interval_timer.one_shot = false
		
		burn_timer.timeout.connect(burn_timer.queue_free)
		burn_interval_timer.timeout.connect(burn_tick.bind(body, burn_dmg))
		
		body.add_child(burn_timer)
		
		burn_tick(body, burn_dmg)
		burn_interval_timer.start()
		burn_timer.start()

func burn_tick(body, dmg):
	body.get_node("HealthComponent").modify_health(dmg)
