extends Node


func _ready() -> void:
	SignalBus.connect("nextStage", checkForWinState)


func checkForWinState(stage : int):
	if stage == 3:
		SignalBus.emit_signal("wonGame")
