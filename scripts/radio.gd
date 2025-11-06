extends Node3D

var first_stage = [
	". . .",
	"Oh good, you're up.",
	"There's been a containment breach.",
	"You were knocked out when the lights went dark.",
	"The company enacted a quarantine on sector 3",
	"There are blocks on door function to keep those things in.",
	"If there's a computer terminal by you,",
	"you can open the doors.",
	"Enter the series of numbers to open the door.",
	"Do it quickly, but you need to keep the lights on.",
	"They like the dark.",
	"There's generator near you.",
	"Keep it running by holding left trigger.",
	". . .",
	"If you have a gun, use it.",
	"Your shotgun only has three shots.",
	"Make them count, I've seen what those things can do.",
	"More ammo should be stored nearby.",
	"Its only rock salt, though,",
	"So make sure they get close before you hit them.",
	". . .",
	"I really need to get out of here.",
	"I did a lot of work keeping them away from you.",
	"Would you kindly open the door?",
	"Neither of us want to die here."
]

var second_stage = [
	". . .",
	"Holy shit...",
	"I heard an air vent open just now.",
	"That's great!",
	"You got through the lower-security protocol.",
	"The next level should unlock a door.",
	"If you can get that, we can escape.",
	". . .",
	"Looks like you opened a vent.",
	"I can see something moving in there.",
	"They don't look very big.",
	"They're probably just rats.",
	". . .",
	"Rats know when there's danger, you know.",
	"I can see them scurrying around.",
	"Just make sure they don't chew through any wires.",
	"You can't get us out of here if you can't keep the lights on.",
]

var third_stage = [
	". . .",
	"You idiot, you unlocked a containment unit, not the exit door!",
	"There's another one of them in there with you now.",
	"Just open that door!"
]

var final_stage = [
	". . .",
	"Oh, you actually got it.",
	"I didn't think you would do it.",
	"I mean the doors were closed for a reason.",
	"But I guess you have a strong survival instinct",
	"and bad foresight.",
	". . .",
	"I was working on that quarantine lock for hours...",
	"its hard to type without hands.",
	"And the others are too dumb to know you're helping us.",
	"It was hard to keep you safe.",
	"Thanks for opening the door for us."
]

var line_index = 0
var character_index = 0

var current_script : Array = first_stage
var current_line : String = ""

var playing : bool
var skipping: bool
var done = false

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
	
	if SignalBus.stage == 1:
		current_script = first_stage
	elif SignalBus.stage == 2:
		current_script = second_stage
	elif SignalBus.stage == 3:
		current_script = third_stage
	setup()

func setup():
	# wait for the first physics frame to play
	$MusicMaker/StaticTransitionToTalkSFX.play()
	music_maker.radio_on = true
	SignalBus.emit_signal("lightsOff", true)
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


func end_dialogue():
	if !done: 
		done = true
		$MusicMaker/StaticTransitionSFX.play()
		$MusicMaker/TalkSFX.stop()
		await $MusicMaker/StaticTransitionSFX.finished
		music_maker.radio_on = false
		music_maker.start_music()
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
