class_name Rat
extends CharacterBody3D

@export var powerDrainAmount : int = 5
@export var maxHealth : int = 1

@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var meshes: Node3D = $Meshes

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
	gpu_particles_3d.emitting = true
	meshes.hide()
	SignalBus.emit_signal("decreasePowerDrain", powerDrainAmount)
	SignalBus.emit_signal("resetSpawnTimer")
	
	await get_tree().create_timer(gpu_particles_3d.lifetime).timeout
	self.queue_free()


func attackGenerator() -> void: #keep the signal but replace the attacking var or add any animation for attacking the gen here
	SignalBus.emit_signal("increasePowerDrain", powerDrainAmount)
	attacking = true
