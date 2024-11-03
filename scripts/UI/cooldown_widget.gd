class_name CooldownWidget
extends TextureRect

var timer_to_watch : Timer = null
var previous_check : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_to_watch:
		if previous_check and !timer_to_watch.is_stopped():
			# Previously stopped...but now not stopped...
			# Started...
			get_node("Fuzzy").position.y = 0
		
		if !previous_check and timer_to_watch.is_stopped():
			# Previously not stopped...but now stopped...
			# Ended...
			get_node("Fuzzy").position.y = 64

		if !timer_to_watch.is_stopped():
			get_node("Fuzzy").position.y = lerp(position.y, 64.0, (1.0 - snapped(timer_to_watch.time_left, 0.01) / timer_to_watch.wait_time))

		previous_check = timer_to_watch.is_stopped()
