extends Node

@onready var music_sfx: AudioStreamPlayer3D = $MusicSFX
@onready var distort_music_sfx: AudioStreamPlayer3D = $DistortMusicSFX
@onready var talk_sfx: AudioStreamPlayer3D = $TalkSFX

@export var tween_blend = 0.0 #-1-1 use -0 to shutoff music

var base_volume = -10.0

func _ready() -> void:
	SignalBus.connect("musicPlay", play_music)
	SignalBus.connect("musicScary", play_scary)
	
func _process(delta: float) -> void:
	var regular_blend = base_volume
	if tween_blend == 1.0: regular_blend = base_volume 
	if tween_blend == 0.0: regular_blend = -80.0
	if tween_blend == -1.0: regular_blend = -80.0
	music_sfx.volume_db = lerp(music_sfx.volume_db, regular_blend, delta * 12)
	
	var distort_blend = 0
	if tween_blend == -1.0: distort_blend = base_volume
	if tween_blend == 0.0: distort_blend = -80.0
	if tween_blend == 1.0: distort_blend = -80.0
	distort_music_sfx.volume_db = lerp(distort_music_sfx.volume_db, distort_blend, delta * 40)
	#print(tween_blend)

func start_music():
	if !music_sfx.playing and !distort_music_sfx.playing:
		music_sfx.play()
		distort_music_sfx.play()
	tween_blend = 1.0
	music_sfx.volume_db = base_volume

func play_scary(state):
	if state == false:
		tween_blend = 1.0
	elif state == true:
		tween_blend = -1.0
	
	
func play_music(state):
	if state == true:
		$StaticTransitionSFX.play()
	elif state == false:
		tween_blend = 0.0
	

func set_tween_blend(blend):
	tween_blend = blend

func _on_static_transition_to_talk_sfx_finished() -> void:
	talk_sfx.play()
