extends Node

@onready var lights = get_children()

var power = 0
var on = true

var org_colors := []
const scary_color : Color = Color(0.5,0,0,0.0)

var close = false
func _ready() -> void:
	for i : Light3D in lights:
		org_colors += [i.light_color]

func _process(delta: float) -> void:
	print(close)
	if close:
		var index = 0
		for i:Light3D in lights:
			i.light_color = lerp(i.light_color, scary_color.lerp(org_colors[index], .65), delta * .5)
			index += 1
	else:
		var index = 0
		for i :Light3D in lights:
			i.light_color = lerp(i.light_color, org_colors[index], delta)
			index += 1

func _on_generator_power_changed(current_power: Variant) -> void:
	if current_power != 0:
		current_power /= 100
		if on == false and current_power != 0:
			flickerOn()
			on = true
	elif on:
		on = false
		flickerOff()
	power = current_power
	

func flickerOn():
	
	var randint = randi_range(15,25) #gets a random integer between two numbers
	for i in range(randint): #flickers a randint number of times
		await awaitTimer() #wait for the timer to finish
	for child in get_children():
		if on:
			child.light_energy = 10.0
		else:
			child.light_energy = 0.0 #turns the lights off

func flickerOff():
	var randint = randi_range(25,35) #gets a random integer between two numbers
	for i in range(randint): #flickers a randint number of times
		await awaitTimer() #wait for the timer to finish
	for child in get_children():
		if on:
			child.light_energy = 10.0
		else:
			child.light_energy = 0.0 #turns the lights off


func awaitTimer():
	for child in get_children():
		var rand = randf_range(0,1.0) #choses an int between 0 and max energy
		child.light_energy = rand #sets brightness to the random int
	await get_tree().create_timer(0.1).timeout #creates a timer for the flicker to last for
