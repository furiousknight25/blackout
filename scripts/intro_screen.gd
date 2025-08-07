extends Node2D

@onready var coverup_rect: ColorRect = $CoverupRect
var transTween : Tween

func _ready() -> void:
	transTween = get_tree().create_tween()
	transTween.tween_property(coverup_rect, "modulate", Color.TRANSPARENT, 2.0)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		transition()
	


func transition():
	if !transTween.is_running():
		transTween = get_tree().create_tween()
		transTween.tween_property(coverup_rect, "modulate", Color.BLACK, 2.0)

		await transTween.finished
		get_tree().change_scene_to_file("res://scenes/TestSceneOne.tscn")
