extends Node2D

@onready var background_player: AnimationPlayer = $BackgroundPlayer
@onready var credit_scroll: AnimationPlayer = $CreditScroll
@onready var music_sfx: AudioStreamPlayer2D = $MusicSFX
@onready var fade: AnimationPlayer = $Fade


func _ready() -> void:
	
	music_sfx.volume_db = -80.0
	music_sfx.playing = true
	background_player.play("background movement")
	credit_scroll.play("scroll")
	fade.play("fadeIn")

func _process(delta: float) -> void:
	music_sfx.volume_db = lerp(music_sfx.volume_db, 0.0, delta * 1.5)

func _on_background_player_animation_finished(anim_name: StringName) -> void:
	background_player.play("background movement")

func _on_credit_scroll_animation_finished(anim_name: StringName) -> void:
	credit_scroll.play("scroll")
