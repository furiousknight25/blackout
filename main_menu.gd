extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var play_button: TextureButton = $PlayButton
@onready var coverup_rect: ColorRect = $coverupRect
var transTween : Tween


func _ready() -> void:
	animation_player.play("Sway")



func transition():
	if transTween != null and !transTween.is_running():
		transTween = get_tree().create_tween()
		transTween.tween_property(coverup_rect, "modulate", Color.BLACK, 2.0)

		await transTween.finished
		get_tree().change_scene_to_file("res://scenes/intro_screen.tscn")


func _on_play_button_button_up() -> void:
	print("yuhh")
	transition()
