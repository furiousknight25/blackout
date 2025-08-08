extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coverup_rect: ColorRect = $CoverupRect

func _ready() -> void:
	animation_player.play("FadeIn")


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		transition()
	


func transition():
	if !animation_player.is_playing():
		animation_player.play("FadeOut")
		
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://scenes/TestSceneOne.tscn")
