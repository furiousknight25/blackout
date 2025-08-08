extends MeshInstance3D

@onready var timer: Timer = $Timer
@onready var crank_sound: AudioStreamPlayer3D = $CrankSound

var last_rotation = Vector3.ZERO

func _ready() -> void:
	crank_sound.stream_paused = true
	
func _process(_delta: float) -> void:
	if last_rotation != rotation:
		last_rotation = rotation
		crank_sound.stream_paused = false
		timer.start()
	
func _on_timer_timeout() -> void:
	crank_sound.stream_paused = true
