extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var play_button: TextureButton = $PlayButton
@onready var coverup_rect: ColorRect = $coverupRect


func _ready() -> void:
	animation_player.play("Sway")



func transition():
	if animation_player.current_animation != "FadeOut":
		animation_player.play("FadeOut")
		
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://scenes/intro_screen.tscn")


func _on_play_button_button_up() -> void:
	transition()


func _on_quit_button_button_up() -> void:
	get_tree().quit()
