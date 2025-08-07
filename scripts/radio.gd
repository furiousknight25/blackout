extends Node3D

var first_night = [
	"Good, you're awake",
	"listen closely.",
	"Recharge the generator",
	"with RMB.",
	". . .",
	"Shoot with LMB"
]
var second_night = [
	
]
var third_night = [
	
]

var line_index = 0
var character_index = 0

var current_script : Array = first_night
var current_line : String = ""

@onready var label_3d: Label3D = $Label3D
@onready var dialogue_timer: Timer = $DialogueTimer

func _ready() -> void:
	setup.call_deferred()

func setup():
	# wait for the first physics frame to playe
	await get_tree().physics_frame
	
	# wait a moment before starting
	await get_tree().create_timer(3.0).timeout
	dialogue_timer.start()
	get_next_line()

func single_interact():
	# TODO: skip dialogue when interacting with radio
	get_next_line()

func get_next_line():
	if line_index < current_script.size():
		current_line = current_script.get(line_index)
		display_next_character()
		line_index += 1
	else:
		line_index = 0
		end_dialogue()


func display_next_character():
	if character_index <= current_line.length():
		label_3d.text = current_line.left(character_index)
		await dialogue_timer.timeout
		character_index += 1
		display_next_character()
	else:
		character_index = 0

func end_dialogue():
	print('dialogue ended')
