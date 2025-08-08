extends Node3D

@export var timeToSpawn : float = 15.0

## Give a PathFollow3D node to be used as the route the enemy will follow (Remember that a PathFollow3D node needs a Path3D as a parent)
@export var followPaths : Array[PathFollow3D] #give the follow path/s for the manager to use to spawn Power Eaters on

@onready var spawn_timer : Timer = $SpawnTimer
@onready var powerEater : PackedScene = preload("res://scenes/power_eater.tscn")

var followPath : PathFollow3D
var moveTween : Tween
var progressSpot : float = 0.5 #this will stop in the middle of the path for the cable

var paused: bool = true

func _ready() -> void:
	spawn_timer.wait_time = timeToSpawn
	spawn_timer.start()
	
	SignalBus.connect("unpauseStage", unpause)
	SignalBus.connect("nextStage", pause)
	SignalBus.connect("resetSpawnTimer", resetSpawnTimer)


func spawnPowerEater() -> void:
	if not paused:
		followPath.progress_ratio = 0
		
		var newPowerEater : CharacterBody3D = powerEater.instantiate()
		followPath.add_child(newPowerEater)
		
		moveTween = get_tree().create_tween()
		moveTween.tween_property(followPath, "progress_ratio", progressSpot, progressSpot / 0.5)
		
		await moveTween.finished
		SignalBus.emit_signal("attackGenerator")


func resetSpawnTimer() -> void:
	spawn_timer.start()
	


func _on_spawn_timer_timeout() -> void:
	selectFollowPath()


func getMaxProgress() -> float:
	followPath.progress_ratio = 1
	return followPath.progress


func selectFollowPath():
	followPath = followPaths[randi_range(0, followPaths.size() - 1)]
	
	for child in followPath.get_children():
		if child is Rat:
			return
	
	spawnPowerEater()
	


func pause(stage : int):
	paused = true

func unpause(stage : int):
	if stage == 1:
		paused = true
	elif stage == 2:
		paused = false
	elif stage == 3:
		paused = false
