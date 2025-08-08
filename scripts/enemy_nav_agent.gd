extends NavigationAgent3D

var movement_target_position: Vector3

@onready var enemy = get_parent()
@onready var movement_target: Node3D

@warning_ignore("unused_signal") signal movement_target_reached(target: Node3D)

func _ready() -> void:

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func _physics_process(_delta: float) -> void:
	# grab new target position 
	get_movement_target_position()
	
	# look at target
	if get_next_path_position() != get_parent().global_position:
		enemy.look_at(get_next_path_position())
	# lock x rotation so whole body doesn't tilt downwards
	enemy.rotation.x = 0
	
	### if needed this is a manual way to set an offset so that the nav agent finishes early
	#if movement_target_position - this.global_position.length() <= 2 && movement_target.name == "Player":
		#movement_target_position = this.global_position
		#movement_target_reached.emit(movement_target)
		#return
	
	# set nav agent target
	target_position = movement_target_position
	
	# exit this funcion if the enemy has already reached its goal
	if is_navigation_finished():
		#print('nav finished')
		return
	
	# grab current position
	var current_agent_position: Vector3 = enemy.global_position

	# grab next path position
	var next_path_position: Vector3 = get_next_path_position()

	# set velocity to the next position
	if enemy.paused == false:
		enemy.velocity = ( current_agent_position.direction_to(next_path_position) 
							* enemy.movement_speed * enemy.movement_speed_modifier
							* enemy.light_speed_modifier )


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	
	## Now that the navigation map is no longer empty, set the movement target.
	get_movement_target_position()

	#set_movement_target(movement_target_position)
	target_position = movement_target_position

func get_movement_target_position():
	# grab the player node for targeting
	if movement_target == null:
		movement_target = get_tree().root.get_node("Node3D").get_node("Player")
		
	# ensure that the movement target is not null
	if movement_target != null:
		movement_target_position = movement_target.global_position
	else:
		push_error("Enemy movement target is still null after trying to grab target node")
