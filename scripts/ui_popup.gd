class_name UIPopup
extends Node3D

@onready var sprite : Sprite3D = $Sprite3D

var colorModulateTween : Tween
var canFadeIn : bool = true
var canFadeOut : bool = false


func _ready() -> void:
	SignalBus.connect("hideUI", fadeOut)

func fadeIn() -> void:
	if canFadeIn:
		canFadeIn = false
		canFadeOut =  true
		
		colorModulateTween = get_tree().create_tween()
		colorModulateTween.tween_property(sprite, "modulate", Color.WHITE, 1.0)
		

func fadeOut():
	if canFadeOut:
		print("yaa")
		canFadeOut = false
		canFadeIn = true
		
		colorModulateTween = get_tree().create_tween()
		colorModulateTween.tween_property(sprite, "modulate", Color.TRANSPARENT, 1.0)
		
		
