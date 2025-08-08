extends AnimationTree

var velocity := Vector3.ZERO

func play_animation(animation: String):
	match animation:
		"reload":
			get("parameters/StateMachine/playback").travel("reload")
		"shoot":
			get("parameters/StateMachine/playback").travel("shoot")
		"click":
			get("parameters/StateMachine/playback").travel("click_no_ammo")
		"type":
			get("parameters/StateMachine/playback").travel("loop_type_on_computer")
		"crank":
			get("parameters/StateMachine/playback").travel("crank_loop")
		"b2i":
			get("parameters/StateMachine/playback").travel("BlendTree")
		

func set_velocity(new_velocity):
	self.velocity = new_velocity

func _process(delta: float) -> void:
	
	if velocity.length() >= 1:
		set("parameters/StateMachine/BlendTree/walk_idle/blend_amount", lerp(get("parameters/StateMachine/BlendTree/walk_idle/blend_amount"), 1.0, delta * 12))
	else:
		set("parameters/StateMachine/BlendTree/walk_idle/blend_amount", lerp(get("parameters/StateMachine/BlendTree/walk_idle/blend_amount"), 0.0, delta * 12))
	
