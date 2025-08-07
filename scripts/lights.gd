extends Node

@onready var lights = get_children()
var power = 0
var on = true
func _on_generator_power_changed(current_power: Variant) -> void:
	if current_power != 0:
		current_power /= 100
	elif on:
		on = false
		flickerOff()
	power = current_power
	

func flickerOn():
	var randint = randi_range(15,25) #gets a random integer between two numbers
	for i in range(randint): #flickers a randint number of times
		await awaitTimer() #wait for the timer to finish
	for child in get_children():
		child.light_energy = 1.0 #sets the light back to normal brightness

func flickerOff():
	var randint = randi_range(25,35) #gets a random integer between two numbers
	for i in range(randint): #flickers a randint number of times
		await awaitTimer() #wait for the timer to finish
	for child in get_children():
		child.light_energy = 0.0 #turns the lights off

	
func awaitTimer():
	for child in get_children():
		var rand = randf_range(0,1.0) #choses an int between 0 and max energy
		child.light_energy = rand #sets brightness to the random int
	await get_tree().create_timer(0.1).timeout #creates a timer for the flicker to last for
