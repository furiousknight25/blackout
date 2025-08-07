extends Node
@onready var progress_bar: ProgressBar = $Sprite3D/SubViewport/ProgressBar
@onready var idle_loop_sfx: AudioStreamPlayer3D = $IdleLoopSFX

var total_power = 30
var delta_power_decrease = -5
var delta_power_increase = 20
var timer : Timer

var incrementTimer : float = 1.5 #time it takes to increase a chunk of progress
var percentIncrease : int = 20 #the amount of progress in percentage is increased
var currentIncrementTime : float = 0 #The amount of time held down so far

signal power_changed(current_power)

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = incrementTimer
	timer.start()
	
	SignalBus.connect("increasePowerDrain", increasePowerDrain)
	SignalBus.connect("decreasePowerDrain", decreasePowerDrain)


func _on_timer_timeout(): #reducing power on here
	total_power = clampf(total_power + delta_power_decrease, 0.0, 100.0)
	
	progress_bar.value = total_power
	emit_signal("power_changed", total_power)
	print(total_power)
	

func interact(delta : float):
	currentIncrementTime += delta
	if currentIncrementTime >= incrementTimer: #increasing power here
		total_power = clampf(total_power + delta_power_increase, 0.0, 100.0)
		
		progress_bar.value = total_power
		currentIncrementTime = 0
		
		print(total_power)


func increasePowerDrain(drainAmount : int) -> void:
	delta_power_decrease -= drainAmount


func decreasePowerDrain(drainAmount : int) -> void:
	delta_power_decrease += drainAmount
