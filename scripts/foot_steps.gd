extends AudioStreamPlayer3D

@onready var parent: CharacterBody3D = $".."
var played = false

func _physics_process(delta: float) -> void:
	if parent.velocity.length() > 2:
		if played:
			played = false
			play()

func _on_timer_timeout() -> void:
	played = true
