class_name Computer
extends StaticBody3D

@onready var progress_bar: ProgressBar = $Sprite3D/SubViewport/ProgressBar
@onready var ui_popup: UIPopup = $"UI Popup"


var incrementTimer : float = 2.0 #time it takes to increase a chunk of progress
var percentIncrease : int = 10 #the amount of progress in percentage is increased
var currentIncrementTime : float = 0 #The amount of time held down so far
var paused = false

func interact(delta : float):
	if paused: return
	currentIncrementTime += delta
	if currentIncrementTime >= incrementTimer and progress_bar.value < 100:
		progress_bar.value += percentIncrease
		currentIncrementTime = 0
	elif progress_bar.value >= 100:
		SignalBus.emit_signal("computerFinished")
		paused = true
		progress_bar.value = 0

func showUI():
	ui_popup.fadeIn()
