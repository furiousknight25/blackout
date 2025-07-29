extends Node
@onready var progress_bar: ProgressBar = $Sprite3D/SubViewport/ProgressBar

var total_power = 100
var delta_power = -5
var cranking = false
var timer : Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = 1.0
	timer.start()


func _on_timer_timeout(): #reducing power on here
	total_power += delta_power
	
	progress_bar.value = total_power
	print(total_power)
	

func interact():
	cranking = !cranking
	if cranking:
		delta_power += 20
	else:
		delta_power -= 20
