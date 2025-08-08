extends Node
@onready var progress_bar: ProgressBar = $Sprite3D/SubViewport/ProgressBar
@onready var idle_loop_sfx: AudioStreamPlayer3D = $IdleLoopSFX
@onready var ui_popup: UIPopup = $"UI Popup"
@onready var crank_mesh: MeshInstance3D = $Cube_059/Crank
@onready var idle_shutdown: AudioStreamPlayer3D = $IdleShutdown
@onready var idle_start: AudioStreamPlayer3D = $IdleStart
@onready var scary_music: AudioStreamPlayer = $ScaryMusic
@onready var hold_timer: Timer = $HoldTimer


var total_power = 100
const base_drain = -10
var total_delta = 0
var is_cranking = false
var is_rat = false

var timer : Timer
var is_gen_low : bool = false
var is_gen_off = false

var incrementTimer : float = 1.5 #time it takes to increase a chunk of progress
var percentIncrease : int = 20 #the amount of progress in percentage is increased
var currentIncrementTime : float = 0 #The amount of time held down so far

var is_paused : bool = true

signal power_changed(current_power)

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = incrementTimer
	timer.start()
	
	SignalBus.connect("increasePowerDrain", increasePowerDrain)
	SignalBus.connect("decreasePowerDrain", decreasePowerDrain)
	SignalBus.connect("unpauseStage", unpause)
	SignalBus.connect("nextStage", pause)
	SignalBus.connect('lostGame', die)

func _on_timer_timeout(): #reducing power on here
	
	
	total_delta = 0
	
	total_delta += base_drain
	if is_rat: total_delta -= 40
	
	if is_cranking: total_delta = 20.0
	
	if is_paused: total_delta = 0
	
	
	total_power = clampf(total_power + total_delta, 0.0, 100.0)
	progress_bar.value = total_power
	
	emit_signal("power_changed", total_power)
	
	if total_power <= 0 and is_gen_off == false:
		idle_shutdown.play()
		is_gen_off = true
		idle_loop_sfx.stop()
		idle_start.stop()
	
	if total_power > 0 and is_gen_off == true:
		is_gen_off = false
		scary_music.stop() 
		idle_start.play()
	if total_power > 0:
		scary_music.stop() 
	
	# emit signal if gen crosses 25% threshold
	if total_power <= 25.0 && not is_gen_low:
		is_gen_low = true
		SignalBus.emit_signal("generatorLow")
	elif total_power > 25.0 && is_gen_low:
		is_gen_low = false
		SignalBus.emit_signal("generatorHigh")

func interact(delta : float):
	crank_mesh.rotation.x += delta * 2
	currentIncrementTime += delta
	if !is_cranking:
		SignalBus.emit_signal("set_crank", true)
	is_cranking = true
	
	hold_timer.start()
	
	
func showUI():
	ui_popup.fadeIn()

func _on_hold_timer_timeout() -> void:
	is_cranking = false
	SignalBus.emit_signal("set_crank", false)

func increasePowerDrain(power):
	is_rat = true

func decreasePowerDrain(power):
	is_rat = false
	
func pause(stage : int):
	is_paused = true
	total_power = 100


func unpause(_stage : int):
	is_paused = false

func die():
	is_paused = true
	total_power = 100
