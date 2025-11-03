class_name Computer
extends StaticBody3D

@onready var progress_bar: ProgressBar = $Sprite3D/SubViewport/ProgressBar
@onready var num_label: Label3D = $NumLabel
@onready var rich_text_label: RichTextLabel = $Numbers/SubViewport/RichTextLabel


var incrementTimer : float = 2.0 #time it takes to increase a chunk of progress
var percentIncrease : int = 10 #the amount of progress in percentage is increased
var currentIncrementTime : float = 0 #The amount of time held down so far
var power = true

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
	SignalBus.connect("lightsOff", power_state)


func interact(_delta : float):
		pass


func _input(event: InputEvent) -> void:
	if not radio_is_finished:
		return
	if rich_text_label.visible:
		if event is InputEventKey and event.is_pressed() or Input.is_action_just_pressed("ddown") or Input.is_action_just_pressed("dleft") or Input.is_action_just_pressed("dright") or Input.is_action_just_pressed("dup"):
			#if event.physical_keycode >= KEY_0 and event.physical_keycode <= KEY_9:
				#keysPressed = keysPressed + char(event.physical_keycode)
				#checkForMatch()
				#
				#resetKeys()
				#SignalBus.emit_signal("set_type", true)
				#$TypingSFX.volume_db = 0.0
			#
			#elif event.physical_keycode >= KEY_KP_0 and event.physical_keycode <= KEY_KP_9:
				#keysPressed = keysPressed + char(event.unicode)
				#checkForMatch()
				#resetKeys()
				#SignalBus.emit_signal("set_type", true)
				#$TypingSFX.volume_db = 0.0
			#else:
			if event.is_action("dup"): type("0")
			if event.is_action("dright"): type("1")
			if event.is_action("ddown"): type("2")
			if event.is_action("dleft"): type("3")
			


func type(i :String):
	keysPressed = keysPressed + i
	print(keysPressed)
	checkForMatch()
	
	resetKeys()
	SignalBus.emit_signal("set_type", true)
	$TypingSFX.volume_db = 0.0

var key_length = 0
func resetKeys():
	if keysPressed.length() >= 4:
		key_length = 0
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
		var random_dir_num = str(randi_range(0, 3))
		randNumString = randNumString + random_dir_num
	
	var new_reg = ""
	for i : String in randNumString:
		
		match i:
			'0': new_reg = new_reg + "up "
			'1': new_reg = new_reg + "right "
			"2": new_reg = new_reg + "down "
			"3": new_reg = new_reg + "left "
	rich_text_label.text = "[outline_size=5]" + "[outline_color=black]" + new_reg + "[/outline_color]" + "[/outline_size]"
	print(new_reg)
	
	keysPressed = ""
	key_length = 0


func updateColoration() -> void:
	
	# Check if the keys pressed so far match the START of the random string
	if randNumString.begins_with(keysPressed):
		# The part that matches is just keysPressed
		var matched_part = keysPressed
		# The remaining part is the rest of the string
		var remaining_part = randNumString.substr(keysPressed.length())
		
		var new_lime_text = ""
		for i in matched_part:
			match i:
				"0": new_lime_text = new_lime_text + "up "
				"1": new_lime_text = new_lime_text + "right "
				"2": new_lime_text = new_lime_text + "down "
				"3": new_lime_text = new_lime_text + "left "
		
		var new_regular_text = ""
		for i in remaining_part:
			match i:
				'0': new_regular_text = new_regular_text + "up "
				'1': new_regular_text = new_regular_text + "right "
				"2": new_regular_text = new_regular_text + "down "
				"3": new_regular_text = new_regular_text + "left "
				
		# Build the final text with the colored (lime) part first
		rich_text_label.text = "[outline_size=5]" + "[outline_color=black]" + \
							   "[color=lime]" + new_lime_text + "[/color]" + \
							   new_regular_text + \
							   "[/outline_color]" + "[/outline_size]"
		
		# You don't need key_length += 1 here, as keysPressed.length()
		# already tracks this.
	
	else:
		# The user pressed a wrong key
		key_length = 0 # This is handled by randomizeNumString anyway
		$RejectSFX.play()
		# Reset with a new number string
		randomizeNumString()
func showUI():
	if power:
		rich_text_label.visible = true
	else:
		hideUI()

func hideUI():
	rich_text_label.visible = false
	SignalBus.emit_signal("set_type", false)
	$TypingSFX.volume_db = -80.0

func power_state(state):
	
	if !state: power = true
	else: power = false
		

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
	
