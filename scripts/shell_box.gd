extends StaticBody3D

@onready var use_timer: Timer = $UseTimer

var scaleTween : Tween
var rotationTween : Tween
var rotSide : bool = true

func interact(_delta : float):
	if use_timer.is_stopped():
		use_timer.start()
		
		wiggle()
		
		SignalBus.emit_signal("refillAmmo")


func wiggle() -> void:
	rotationTween = get_tree().create_tween()
	rotationTween.tween_property(self, "rotation_degrees", Vector3(0, 10, 0), 0.1)
	
	await rotationTween.finished
	rotationTween = get_tree().create_tween()
	rotationTween.tween_property(self, "rotation_degrees", Vector3(0, -10, 0), 0.1)
	
	await rotationTween.finished
	rotationTween = get_tree().create_tween()
	rotationTween.tween_property(self, "rotation_degrees", Vector3(0, 0, 0), 0.1)
