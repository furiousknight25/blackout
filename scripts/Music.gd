extends Node

@onready var music_sfx: AudioStreamPlayer3D = $MusicSFX
@onready var distort_music_sfx: AudioStreamPlayer3D = $DistortMusicSFX

@export var tween_blend = 0.0 #-1-1 use -0 to shutoff music

func _process(delta: float) -> void:
	
	var regular_blend = 0.0
	if tween_blend == 1.0: regular_blend = 0.0
	if tween_blend == 0.0: regular_blend = -80.0
	music_sfx.volume_db = lerp(music_sfx.volume_db, regular_blend, delta * 12)
	
	var distort_blend = 0
	if tween_blend == -1.0: distort_blend = 0.0
	if tween_blend == 0.0 or 1.0: distort_blend = -80.0
	distort_music_sfx.volume_db = lerp(distort_music_sfx.volume_db, distort_blend, delta * 12)

func set_tween_blend(blend):
	tween_blend = blend
