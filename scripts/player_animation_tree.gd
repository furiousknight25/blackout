extends AnimationTree

var velocity := Vector3.ZERO

func play_animation(animation: String):
	match animation:
		"reload":
			get("parameters/StateMachine/playback").travel("reload")
		"shoot":
			get("parameters/StateMachine/playback").travel("shoot")
		

func set_velocity(velocity):
	self.velocity = velocity

func _process(delta: float) -> void:
	
	if velocity.length() >= 1:
		set("parameters/idle_walk_blend/blend_amount", lerp(get("parameters/idle_walk_blend/blend_amount"), 1.0, delta * 12))
	else:
		set("parameters/idle_walk_blend/blend_amount", lerp(get("parameters/idle_walk_blend/blend_amount"), 0.0, delta * 12))
	
