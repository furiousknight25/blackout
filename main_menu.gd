extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var play_button: TextureButton = $PlayButton
@onready var coverup_rect: ColorRect = $coverupRect
@onready var music_sfx: AudioStreamPlayer2D = $MusicSFX
@onready var fade: AnimationPlayer = $Fade
@onready var fade_2: ColorRect = $Fade2

func _ready() -> void:
	fade.play("fadeIn")
	music_sfx.volume_db = -80.0
	music_sfx.playing = true
	animation_player.play("Sway")
	

func _process(delta: float) -> void:
	music_sfx.volume_db = lerp(music_sfx.volume_db, 0.0, delta * 1.5)

func transition():
	fade.play("fadeOut")
	await fade.animation_finished
	get_tree().change_scene_to_file.bind("res://scenes/intro_screen.tscn").call_deferred()
	#get_tree().change_scene_to_file("res://scenes/intro_screen.tscn")


func _on_play_button_button_up() -> void:
	transition()


func _on_quit_button_button_up() -> void:
	get_tree().quit()


func _on_fade_animation_finished(anim_name: StringName) -> void:
	fade_2.color = Color.TRANSPARENT
