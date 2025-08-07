extends CharacterBody3D

@export var powerDrainAmount : int = 5
@export var maxHealth : int = 1

var currentHealth : int = maxHealth
var attacking : bool = false


func _ready() -> void:
	currentHealth = maxHealth
	
	SignalBus.connect("attackGenerator", attackGenerator)


func _physics_process(delta: float) -> void:
	if attacking:
		rotate_y(5.0 * delta) #lmao get rotated idiot
	
	if currentHealth <= 0:
		die()


func take_damage(damage : int) -> void:
	if currentHealth > 0:
		currentHealth -= damage


func die() -> void: #rip bozo
	SignalBus.emit_signal("decreasePowerDrain", powerDrainAmount)
	SignalBus.emit_signal("resetSpawnTimer")
	self.queue_free()


func attackGenerator() -> void: #keep the signal but replace the attacking var or add any animation for attacking the gen here
	SignalBus.emit_signal("increasePowerDrain", powerDrainAmount)
	attacking = true
