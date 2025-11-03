extends Marker3D
@export var horizontal_sensitivity = .005
@export var vertical_sensitivity = .005

func _physics_process(_delta: float) -> void:
	#return
	#position = $Camera3D/Rig/ViewmodelStuff/ARMS_SK/Skeleton3D/BoneAttachment3D.position
	rotation = $Camera3D/Rig/ViewmodelStuff/ARMS_SK/Skeleton3D/BoneAttachment3D.rotation
	
	$Camera3D/Rig/ViewmodelStuff.rotation = lerp($Camera3D/Rig/ViewmodelStuff.rotation, Vector3.ZERO, _delta * 8)
	var joy_input = Input.get_vector("lleft", "lright", "lup", "ldown")
	var yaw = joy_input.x * horizontal_sensitivity
	rotate_y(deg_to_rad(-yaw))

	# Vertical rotation (up/down)
	var pitch = joy_input.y * vertical_sensitivity
	
	$Camera3D/Rig/ViewmodelStuff.rotation += Vector3(pitch, -yaw, 0)
	
	
	
	
