class_name Computer
extends StaticBody3D

@onready var progress_bar: ProgressBar = $Sprite3D/SubViewport/ProgressBar
@onready var num_label: Label3D = $NumLabel
@onready var rich_text_label: RichTextLabel = $Numbers/SubViewport/RichTextLabel


var incrementTimer : float = 2.0 #time it takes to increase a chunk of progress
var percentIncrease : int = 10 #the amount of progress in percentage is increased
var currentIncrementTime : float = 0 #The amount of time held down so far

var keysPressed = ""
var randNumString = ""

var first_code_is_entered : bool = false
var radio_is_finished : bool = false


func _ready() -> void:
	randomizeNumString()
	
	SignalBus.connect("radioFinished", radioFinished)
	SignalBus.connect("unpauseStage", unpause)
	SignalBus.connect("nextStage", pause)
	SignalBus.connect("hideUI", hideUI)
	SignalBus.connect("lostGame", die)


func interact(_delta : float):
		pass


func _input(event: InputEvent) -> void:
	if not radio_is_finished:
		return
	if rich_text_label.visible:
		if event is InputEventKey and event.is_pressed():
			if event.physical_keycode >= KEY_0 and event.physical_keycode <= KEY_9:
				keysPressed = keysPressed + char(event.physical_keycode)
				checkForMatch()
				
				resetKeys()
				SignalBus.emit_signal("set_type", true)
			
			elif event.physical_keycode >= KEY_KP_0 and event.physical_keycode <= KEY_KP_9:
				keysPressed = keysPressed + char(event.unicode)
				checkForMatch()
				resetKeys()
				SignalBus.emit_signal("set_type", true)


func resetKeys():
	
	if keysPressed.length() >= 4:
		
		keysPressed = ""


func checkForMatch():
	updateColoration()
	if keysPressed == randNumString:
		$AcceptedSFX.play()
		progress_bar.value = clamp(progress_bar.value + percentIncrease, 0, 100)
		# check for win state
		checkForWin()
		if not first_code_is_entered && radio_is_finished:
			SignalBus.emit_signal("unpauseStage", SignalBus.stage)
			first_code_is_entered = true
		randomizeNumString()
		

func checkForWin():
	if progress_bar.value >= 100:
		$FinishSFX.play()
		SignalBus.stage += 1
		SignalBus.emit_signal("nextStage", SignalBus.stage)

func randomizeNumString():
	randNumString = ""
	for i in range(0, 4):
		randNumString = randNumString + str(randi_range(0, 9))
	rich_text_label.text = "[outline_size=5]" + "[outline_color=black]" + randNumString + "[/outline_color]" + "[/outline_size]"
	
	keysPressed = ""


func updateColoration() -> void:
	if randNumString.contains(keysPressed):
		rich_text_label.text = "[outline_size=5]" + "[outline_color=black]" + "[color=lime]" + randNumString.substr(0,keysPressed.length()) + "[/color]" + randNumString.substr(keysPressed.length(), randNumString.length()) + "[/outline_color]" + "[/outline_size]"
	else:
		$RejectSFX.play()
		randomizeNumString()

func showUI():
	rich_text_label.visible = true

func hideUI():
	rich_text_label.visible = false
	SignalBus.emit_signal("set_type", false)

func radioFinished():
	radio_is_finished = true

func pause(stage : int):
	first_code_is_entered = false
	radio_is_finished = false
	progress_bar.value = 0
	if stage == 1:
		pass
	elif stage == 2:
		pass
	elif stage == 3:
		pass

func unpause(_stage : int):
	pass

func die():
	
	randomizeNumString()
	updateColoration()
	progress_bar.value = 0
	first_code_is_entered = false
	radio_is_finished = false
	
