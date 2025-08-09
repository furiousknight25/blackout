extends AnimationTree

var velocity := Vector3.ZERO
var reload_time = 3.2

func play_animation(animation: String):
	match animation:
		"reload":
			get("parameters/StateMachine/playback").travel("reload")
			$"../../../..".is_reloading = true
			await get_tree().create_timer(reload_time).timeout
			$"../../../..".is_reloading = false
			
		"shoot":
			get("parameters/StateMachine/playback").travel("shoot")
		"click":
			get("parameters/StateMachine/playback").travel("click_no_ammo")
		"type":
			tween_to_state(1.0)
		"crank":
			tween_to_state(-1.0)
		"b2i":
			tween_to_state(0.0)
		

@export var current_tween = 0.0
func tween_to_state(tween_amount):
	var tween = create_tween()
	tween.tween_property(self, "current_tween", tween_amount, .2)

func set_velocity(new_velocity):
	self.velocity = new_velocity

func _process(delta: float) -> void:
	set("parameters/StateMachine/BlendTree/crank_type/blend_amount", current_tween)
	
	if velocity.length() >= 1:
		set("parameters/StateMachine/BlendTree/walk_idle/blend_amount", lerp(get("parameters/StateMachine/BlendTree/walk_idle/blend_amount"), 1.0, delta * 12))
	else:
		set("parameters/StateMachine/BlendTree/walk_idle/blend_amount", lerp(get("parameters/StateMachine/BlendTree/walk_idle/blend_amount"), 0.0, delta * 12))
