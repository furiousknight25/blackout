extends Marker3D

func _physics_process(delta: float) -> void:
	rotation = $Camera3D/Rig/fpsanimations/ArmRIG/Skeleton3D/BoneAttachment3D.rotation
