class_name FireProjectile
extends CharacterBody2D

#var burn_timer : Timer = null
#var burn_interval_timer : Timer = null

var lifetime := 0.0
var initial_dmg := 0.0
var burn_dmg := 0.0
var burn_tick_interval := 0.0

func _ready():
	# Create timers...
	"""burn_timer = Timer.new()
	burn_interval_timer = Timer.new()
	
	# Set timer wait times...
	burn_timer.wait_time = lifetime
	burn_interval_timer.wait_time = burn_tick_interval
	
	# Make overall the parent of interval...
	burn_timer.add_child(burn_interval_timer)
	
	# Set autostart...
	burn_timer.autostart = false
	burn_interval_timer.autostart = false
	
	# Set one shot...
	burn_timer.one_shot = true
	burn_interval_timer.one_shot = false
	
	# Set timeout connection...
	burn_timer.timeout.connect(queue_free)"""
	pass
	
func _process(delta):
	look_at(position + velocity)

func _physics_process(delta):
	move_and_collide(velocity)
	
func _on_damage_area_body_entered(body):
	if body.is_in_group("Enemy"):
		var burn_timer = Timer.new()
		var burn_interval_timer = Timer.new()
		
		# Set timer wait times...
		burn_timer.wait_time = lifetime
		burn_interval_timer.wait_time = burn_tick_interval
		
		# Make overall the parent of interval...
		burn_timer.add_child(burn_interval_timer)
		
		# Set autostart...
		burn_timer.autostart = false
		burn_interval_timer.autostart = false
		
		# Set one shot...
		burn_timer.one_shot = true
		burn_interval_timer.one_shot = false
		
		# Set timeout connection...
		burn_timer.timeout.connect(queue_free)
		
		body.add_child(burn_timer)
		burn_interval_timer.timeout.connect(burn_tick.bind(body, burn_dmg))
		burn_tick(body, burn_dmg)
		burn_timer.start()
		burn_interval_timer.start()

func burn_tick(body, dmg):
	body.get_node("HealthComponent").modify_health(dmg)

# Ensure that projectile does not live forever...
func _on_lifetime_timer_timeout():
	queue_free()
