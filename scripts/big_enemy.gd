extends CharacterBody3D

var health : int = 100
var movement_speed: float = 1.3
var movement_speed_modifier : float = 1.0
var light_speed_modifier : float = 1.0
var has_mouse: bool = false
var paused: bool = true
var spawn_probability = 3


@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var player
@onready var crawl_over_box: Area3D = $CrawlOver
@onready var reset_point
@onready var crouch_sfx: AudioStreamPlayer3D = $Crouch
@onready var foot_step_freq: Timer = $FootSteps/FootStepFreq


enum States { WAIT, START, RESET, CROUCH, ATTACK }

var state = States.RESET



@onready var target: Node3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

signal hit_box

func _ready():
	SignalBus.connect("generatorLow", generatorLow)
	SignalBus.connect("generatorHigh", generatorHigh)
	SignalBus.connect("unpauseStage", unpause)
	SignalBus.connect("nextStage", pause)
	SignalBus.connect("lostGame", die)
	
	visible = false
	paused = true
	
	var main = get_tree().root.get_node("Node3D")
	player = main.get_node("Player")
	if name == "BigEnemy1":
		reset_point = main.get_node("EnemyStuff").get_node("Reset1")
	elif name == "BigEnemy2":
		reset_point = main.get_node("EnemyStuff").get_node("Reset2")
	else:
		push_error("One of the enemies is not named properly:\n Rename to either BigEnemy1 or BigEnemy2")
	
	
	navigation_agent_3d.movement_target = reset_point

func _physics_process(_delta):
	if velocity.length() > .1:
		foot_step_freq.paused = false
	else:
		foot_step_freq.paused = true
	
	match state:
		States.RESET:
			if navigation_agent.is_navigation_finished():
				state = States.WAIT
				wait()
				crawl_over_box.set_deferred("monitorable", true)
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
	if paused:
		spawn_probability = -1
	else:
		spawn_probability = 3
	
	movement_speed_modifier = 0.0
	await get_tree().create_timer(6.0).timeout
	
	if randi_range(0, 9) < spawn_probability:
		spawn_probability = 3
		state = States.START
		start()
	else:
		wait()

func start():
	SignalBus.emit_signal("enemyStarting")
	movement_speed_modifier = 1.0
	navigation_agent.movement_target = player
	await self.hit_box #CUSTOM AWAIT
	
	state = States.CROUCH
	crouch()

func reset():
	navigation_agent.movement_target = reset_point
	movement_speed_modifier = 5.0
	health = 100.0
	foot_step_freq.wait_time = .5


func crouch():
	## TODO: sound cue for incoming attack
	SignalBus.emit_signal("enemyCrouching")
	movement_speed_modifier = 0
	await get_tree().create_timer(3.0).timeout
	state = States.ATTACK
	attack()

func attack():
	movement_speed_modifier = 6.0
	foot_step_freq.wait_time = .2

func take_damage( damage : int ):
	$HurtSFX.play()
	health -= damage
	if health <= 0:
		state = States.RESET
		SignalBus.emit_signal("enemyKilled")
		foot_step_freq.wait_time = .2
		reset()
		

func generatorLow():
	spawn_probability = 6
	light_speed_modifier = 1.5

func generatorHigh():
	spawn_probability = 3
	light_speed_modifier = 1.0


func pause(_stage : int):
	paused = true
	reset()
	get_tree().create_timer(3).timeout
	visible = false

func die():
	visible = false
	paused = true
	reset()
	self.queue_free()

func unpause(stage: int):
	print(stage)
	if stage == 1:
		if name == "BigEnemy1":
			visible = true
			paused = false
			print("enemy 1 activated")
		elif name == "BigEnemy2":
			visible = false
			paused = true
			print("enemy 2 deactivated")
		else:
			push_error("One of the enemies is not named properly:\n Rename to either BigEnemy1 or BigEnemy2")
	elif stage == 2:
		if name == "BigEnemy1":
			visible = true
			paused = false
			print("enemy 1 activated")
		elif name == "BigEnemy2":
			visible = false
			paused = true
			print("enemy 2 deactivated")
		else:
			push_error("One of the enemies is not named properly:\n Rename to either BigEnemy1 or BigEnemy2")
	elif stage == 3:
		if name == "BigEnemy1":
			visible = true
			paused = false
			print("enemy 1 activated")
		elif name == "BigEnemy2":
			visible = true
			paused = false
			print("enemy 2 activated")
		else:
			push_error("One of the enemies is not named properly:\n Rename to either BigEnemy1 or BigEnemy2")
	else:
		print("enemies deactivated")
		visible = false
		paused = true
	reset()

func _on_crawl_over_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	#print(body)
	crouch_sfx.play()
	crawl_over_box.set_deferred("monitorable", false)
	hit_box.emit()
