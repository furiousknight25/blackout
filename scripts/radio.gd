extends Node3D


var debug = [
	"whats up pisser",
	"you gotta shit bricks soon"
]

var first_stage = [
	"...",
	"Hello?",
	"Hello? Hello?",
	"Is anyone alive on this channel?",
	". . .",
	"If you're alive, listen closely...",
	"There's been a containment breach.",
	"Units 3B and 3C are down.",
	"There's a quarantine on sector 3 until they kill those things",
	"You wanna keep those lights on...",
	"otherwise they'll kill you.",
	"They don't like light,",
	"that's why they slashed the breaker box.",
	"All of sector 3 is in the dark.",
	". . .",
	"Honestly the dark is nice compared to the bright overhead lighting",
	"I could never stand it, so I can't blame those things.",
	". . .",
	"Oh, you should probably have a generator.",
	"Keep that generator running to keep the lights on.",
	"Crank it by holding RMB every once in a while.",
	". . .",
	"Oh, and if you have a gun, use it.",
	"Keep track of your ammo, though.",
	"The standard-issue shotgun only has three shots.",
	"Make them count.",
	"More ammo should be stored nearby.",
	". . .",
	"Oh boy, they're really worked up right now.",
	"Its a good think the shells are only rock salt...",
	". . .",
	"Uh... you should probably try to find a way out.",
	"If there's a computer terminal by you,",
	"you can release the quarantine blocks on door function.",
	"In quarantine, the terminals are all put onto the bypass screen.",
	"You should be able to enter a series of numbers to open the door.",
	"Uh... yeah that's it."
]

var second_stage = [
	". . .",
	"Holy shit...",
	"Are you alive in 3C still?",
	"I heard an air vent open just now.",
	"That's great!",
	"Well, except for the fact that I see something in the vents...",
	"But that's besides the point.",
	"You got through the lower-security protocol.",
	"The next level should unlock a door.",
	"If you can get that, we can escape.",
	". . .",
	"Just deal with those things in the vents and you'll be fine.",
	"They don't look very big, anyways.",
	"They're probably just rats.",
	". . .",
	"Rats know when there's danger, you know.",
	". . .",
	"Just make sure they don't chew through any wires.",
	"You can't get out of here if you can't keep the lights on.",
	"By the way I'm pretty stuck in here too...",
	"Would you kindly open the door for me?"
]

var third_stage = [
	"Shit! You unlocked unit 3A, not the exit door!",
	"There's another one of the boys in here now.",
	"Just open that door!"
]

var final_stage = [
	". . .",
	"Oh, you actually got it.",
	"I didn't think you'd actually do it.",
	"I mean the doors were closed for a reason.",
	"But I guess you have a strong survival instinct",
	"and bad foresight.",
	"My children just ran out, by the way.",
	"Thanks for getting us out of here.",
	"I was working on that quarantine lock for hours...",
	"its hard to get the kids to type for me when they're so worked up.",
	"Anyways I gotta go.",
	"Thanks again for opening the door for us."
]

var line_index = 0
var character_index = 0

var current_script : Array = first_stage
var current_line : String = ""

var playing : bool
var skipping: bool

@onready var ui_popup: UIPopup = $"UI Popup"
@onready var label_3d: Label3D = $Label3D
@onready var dialogue_timer: Timer = $DialogueTimer
@onready var music_maker: Node = $MusicMaker
@onready var static_transition_to_talk_sfx: AudioStreamPlayer3D = $MusicMaker/StaticTransitionToTalkSFX
@onready var talk_sfx: AudioStreamPlayer3D = $MusicMaker/TalkSFX


## TODO: Fix bug where clicking rapidly causes the text to not go to the next line but also not
##       show the rest of the line


func _ready() -> void:
	SignalBus.connect("unpauseStage", unpause)
	SignalBus.connect("nextStage", nextStage)
	SignalBus.connect("lostGame", die)
	
	setup()

func setup():
	# wait for the first physics frame to play
	$MusicMaker/StaticTransitionToTalkSFX.play()
	SignalBus.emit_signal("musicPlay", false)
	# wait a moment before starting
	await get_tree().create_timer(2.0).timeout
	
	SignalBus.emit_signal("musicPlay", false)
	dialogue_timer.start()
	get_next_line()
	done = false

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
	talk_sfx.volume_db = -10.0
	line_index += 1
	
	if line_index < current_script.size():
		current_line = current_script.get(line_index)
		playing = true
		
		display_next_character()
	else:
		talk_sfx.volume_db = -80.0
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
		talk_sfx.volume_db = -80.0
		character_index = 0

var done = false
func end_dialogue():
	if !done: 
		done = true
		$MusicMaker/StaticTransitionSFX.play()
		
		$MusicMaker/TalkSFX.stop()
	label_3d.text = ""
	if current_script != final_stage:
		SignalBus.emit_signal("radioFinished")
		
	elif current_script == final_stage:
		SignalBus.emit_signal("wonGame")


func start_new_dialogue():
	line_index = 0
	get_next_line()

func showUI():
	ui_popup.fadeIn()

func unpause(stage : int):
	pass
	
func nextStage(stage : int):
	if current_script != final_stage:
		music_maker.set_tween_blend(0.0)
	static_transition_to_talk_sfx.play()
	character_index = 0
	line_index = 0
	
	if stage == 1:
		current_script = first_stage
	elif stage == 2:
		current_script = second_stage
	elif stage == 3:
		current_script = third_stage
	elif stage == 4:
		current_script = final_stage
	
	setup()

func die():
	character_index = 0
	line_index = 0
	current_script = first_stage
