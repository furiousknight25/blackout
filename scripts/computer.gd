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


func _ready() -> void:
	randomizeNumString()
	
	SignalBus.connect("hideUI", hideUI)


func interact(_delta : float):
		pass


func _input(event: InputEvent) -> void:
	if rich_text_label.visible:
		if event is InputEventKey and event.is_pressed() and event.physical_keycode >= KEY_0 and event.physical_keycode <= KEY_9:
			keysPressed = keysPressed + char(event.physical_keycode)
			checkForMatch()
			resetKeys()


func resetKeys():
	if keysPressed.length() >= 4:
		keysPressed = ""


func checkForMatch(): 
	updateColoration()
	if keysPressed == randNumString:
		progress_bar.value = clamp(progress_bar.value + percentIncrease, 0, 100)
		randomizeNumString()
		
		if progress_bar.value == 100:
			$FinishSFX.play()


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
		randomizeNumString()


func showUI():
	rich_text_label.visible = true


func hideUI():
	rich_text_label.visible = false
