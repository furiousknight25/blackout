extends Node3D

var first_night = [
	"[inaudible]",
	"Hello?",
	"Hello? Hello?",
	"Is anyone alive on this channel?",
	"Hell, this is one-way anyways, why am I asking?",
	". . .",
	"If you're alive, listen closely...",
	"There's been a containment breach.",
	"Units 3B and 3C are down.",
	"There's a quarantine on sector 3 until they kill those things",
	"You wanna keep those lights on...",
	"otherwise those freaks will gut you.",
	"They don't like light,",
	"that's why those things slashed the breaker box.",
	"All of sector 3 is in the dark.",
	"If you have a radio, though, you should have a generator.",
	"Keep that generator running!",
	"Crank it by holding RMB every once in a while.",
	". . .",
	"Oh, and if you have a gun, use it.",
	"Keep track of your ammo, though.",
	"The standard-issue shotgun only has three shots.",
	"Make them count.",
	"More ammo should be stored nearby.",
	". . .",
	"Uh... you should probably try to find a way out.",
	"If there's a computer terminal by you,",
	"you can release the quarantine blocks on door function.",
	"Remember to...",
	"[inaudible]"
]

var second_night = [
	"Holy shit...",
	"Are you alive in 3C still?",
	"I heard an air open vent just now.",
	"That's great!",
	"Well, except for the fact that my sensors see something in the vents...",
	"But that's besides the point!",
	"You got through the lower-security protocol.",
	"The next level should unlock a door.",
	"If you can get that, we can escape.",
	". . .",
	"Just deal with those things in the vents and you'll be fine.",
	"They don't look very big, anyways.",
	"Maybe they're some rats.",
	"Rats know when there's danger, you know.",
	". . .",
	"Just make sure they don't chew through any wires.",
	"Good luck."
]

var third_night = [
	"Shit! You unlocked unit 3A, not the exit door!",
	"There's another one of those things now.",
	"Just open that door!"
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
	SignalBus.emit_signal("dialogueEnded")

func start_new_dialogue():
	line_index = 0
	get_next_line()
