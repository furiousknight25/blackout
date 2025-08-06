extends CharacterBody3D

var health : int = 100
var movement_speed: float = 1.0
var movement_speed_modifier : float = 1.0
var has_mouse: bool = false

var spawn_probability = 3

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var player
@onready var reset_point

enum States { WAIT, START, RESET, CROUCH, ATTACK }

var state = States.RESET

@onready var target: Node3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	var main = get_tree().root.get_node("Node3D")
	player = main.get_node("Player")
	reset_point = main.get_node("EnemyStuff").get_node("Reset")
	navigation_agent_3d.movement_target = reset_point

func _physics_process(_delta):
	
	match state:
		States.RESET:
			if navigation_agent.is_navigation_finished():
				state = States.WAIT
				wait()
		States.WAIT:
			pass
		States.START:
			pass
		States.CROUCH:
			pass
		States.ATTACK:
			if navigation_agent.is_navigation_finished():
				state = States.RESET
				SignalBus.emit_signal("playerHit")
				reset()
	
	move_and_slide()

func wait():
	movement_speed_modifier = 0.0
	await get_tree().create_timer(3.0).timeout
	
	if randi_range(0, 9) < spawn_probability:
		spawn_probability = 3
		state = States.START
		start()
	else:
		spawn_probability += 1
		wait()

func start():
	SignalBus.emit_signal("enemyStarting")
	movement_speed_modifier = 1.0
	navigation_agent.movement_target = player
	await get_tree().create_timer(6.0).timeout
	state = States.CROUCH
	crouch()

func reset():
	navigation_agent.movement_target = reset_point
	movement_speed_modifier = 5.0


func crouch():
	## TODO: sound cue for incoming attack
	SignalBus.emit_signal("enemyCrouching")
	movement_speed_modifier = 0
	await get_tree().create_timer(3.0).timeout
	state = States.ATTACK
	attack()

func attack():
	movement_speed_modifier = 6.0

func take_damage( damage : int ):
	health -= damage
	if health <= 0:
		state = States.RESET
		SignalBus.emit_signal("enemyKilled")
		reset()
