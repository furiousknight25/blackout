extends Node


func _ready() -> void:
	SignalBus.connect("nextStage", checkForWinState)
	SignalBus.connect("lostGame", lose)


func checkForWinState(stage : int):
	if stage == 3:
		SignalBus.emit_signal("wonGame")


func lose():
	SignalBus.stage = 1
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file.bind("res://scenes/main_menu.tscn").call_deferred()
	
