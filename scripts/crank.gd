extends MeshInstance3D

@onready var timer: Timer = $Timer
@onready var crank_sound: AudioStreamPlayer3D = $CrankSound

var is_cranking : bool = false
var last_rotation = Vector3.ZERO

func _ready() -> void:
	await get_tree().create_timer(.01).timeout
	crank_sound.stream_paused = true
	
func _process(_delta: float) -> void:
	if last_rotation != rotation:
		last_rotation = rotation
		crank_sound.stream_paused = false
		is_cranking = false
		timer.start()
	
func _on_timer_timeout() -> void:
	crank_sound.stream_paused = true
	#is_cranking = true
	start_cranking.call_deferred()

func start_cranking():
	is_cranking = true
