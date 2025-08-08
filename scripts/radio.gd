extends Node3D

var debug = [
	"whats up pisser",
	"you gotta shit bricks soon thug"
]

var first_stage = [
	"...",
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
	"I remotely put your terminal into bypass mode.",
	"You should be able to enter a series of numbers to open the door.",
	"Remember to... [inaudible]",
]

var second_stage = [
	". . .",
	"Holy shit...",
	"Are you alive in 3C still?",
	"I heard an air vent open just now.",
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

var third_stage = [
	"Shit! You unlocked unit 3A, not the exit door!",
	"There's another one of those things now.",
	"Just open that door!"
]

var line_index = 0
var character_index = 0

var current_script : Array = debug
var current_line : String = ""

var playing : bool
var skipping: bool

@onready var ui_popup: UIPopup = $"UI Popup"
@onready var label_3d: Label3D = $Label3D
@onready var dialogue_timer: Timer = $DialogueTimer


## TODO: Fix bug where clicking rapidly causes the text to not go to the next line but also not
##       show the rest of the line


func _ready() -> void:
	SignalBus.connect("unpauseStage", unpause)
	SignalBus.connect("nextStage", nextStage)
	SignalBus.connect("lostGame", die)
	setup()

func setup():
	# wait for the first physics frame to play
	
	# wait a moment before starting
	await get_tree().create_timer(2.0).timeout
	dialogue_timer.start()
	get_next_line()

func interact():
	pass

func single_interact():
	if skipping == true:
		return
	
	if not playing:
		get_next_line()
	elif playing:
		skipping = true
		await get_tree().create_timer(0.05).timeout
		label_3d.text = current_line
		skipping = false
		get_next_line()
		

func get_next_line():
	# break loop if the player is skipping
	if skipping == true:
		return
		
	line_index += 1
	
	if line_index < current_script.size():
		current_line = current_script.get(line_index)
		playing = true
		
		display_next_character()
	else:
		end_dialogue()

func display_next_character():
	# break loop if the player is skipping
	if skipping == true:
		character_index = 0
		return
	
	if character_index <= current_line.length():
		label_3d.text = current_line.left(character_index)
		await dialogue_timer.timeout
		character_index += 1
		display_next_character()
	else:
		playing = false
		character_index = 0

func end_dialogue():
	label_3d.text = ""
	SignalBus.emit_signal("radioFinished")

func start_new_dialogue():
	line_index = 0
	get_next_line()

func showUI():
	ui_popup.fadeIn()

func unpause(stage : int):
	pass
	
func nextStage(stage : int):
	character_index = 0
	line_index = 0
	
	if stage == 1:
		current_script = first_stage
	elif stage == 2:
		current_script = second_stage
	elif stage == 3:
		current_script = third_stage
	
	setup()

func die():
	character_index = 0
	line_index = 0
	current_script = first_stage
