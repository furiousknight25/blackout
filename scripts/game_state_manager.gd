extends Node


func _ready() -> void:
	SignalBus.connect("wonGame", win)
	SignalBus.connect("lostGame", lose)


func win():
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file.bind("res://scenes/credit_scene.tscn").call_deferred()

func lose():
	SignalBus.stage = 1
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file.bind("res://scenes/main_menu.tscn").call_deferred()
	
