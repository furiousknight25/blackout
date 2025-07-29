extends Node

var total_power = 100
var delta_power = -1

var timer : Timer
func _process(delta: float) -> void:
	timer = Timer.new()
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout(): #reducing power on here
	pass
