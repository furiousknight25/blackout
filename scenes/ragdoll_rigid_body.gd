extends RigidBody3D

func new_position(new_position : Vector3):
	set_position(new_position)

func unpause():
	freeze = false
	linear_velocity = Vector3(randf_range(-2, 2), randf_range(-2, 2), randf_range(-2, 2))
