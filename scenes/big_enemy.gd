extends CharacterBody3D

var movement_speed: float = 2.0
var target_position: Vector3
var health : int = 100
var movement_speed_modifier : int = 1.0
var crouch_wait_time : float = 3.0

signal target_reached(target: Node3D)

@onready var target: Node3D
#@onready var player: Node3D = get_tree().root.get_node("Node3D").get_node("Player")
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func _physics_process(_delta):
	# grab new target position 
	get_target_position()
	
	# look at target
	look_at(target_position)
	# lock x rotation so whole body doesn't tilt downwards
	rotation.x = 0
	
	## set target position to self if within 1m of true target
	if abs(target_position - global_position).length() <= 2 && target.name == "Player":
		target_position = global_position
		target_reached.emit(target)
		return
	
	# set nav agent target
	navigation_agent.target_position = target_position
	
	# exit this funcion if the enemy has already reached its goal
	if navigation_agent.is_navigation_finished():
		print('nav finished')
		return
	
	# grab current position
	var current_agent_position: Vector3 = global_position

	# grab next path position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	# set velocity to the next position
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()


func pause():
	pass

func start():
	pass

func reset():
	pass

func die():
	## TODO: death animation triggers
	reset()

func crouch():
	## TODO: sound cue for incoming attack
	await get_tree().create_timer(crouch_wait_time).timeout
	attack()

func attack():
	pass

func take_damage( damage : int ):
	health -= damage
	if health <= 0:
		die()

#region Navigation stuff

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	
	## Now that the navigation map is no longer empty, set the movement target.
	get_target_position()

	#set_movement_target(movement_target_position)
	navigation_agent.target_position = target_position

func get_target_position():
	# grab the player node for targeting
	if target == null:
		target = get_tree().root.get_node("Node3D").get_node("Player")
		
	# ensure that the movement target is not null
	if target != null:
		target_position = target.global_position
	else:
		push_error("Enemy movement target is still null after trying to grab target node")

#endregion
