extends Node2D

@onready var background_player: AnimationPlayer = $BackgroundPlayer
@onready var credit_scroll: AnimationPlayer = $CreditScroll

func _ready() -> void:
	background_player.play("background movement")
	credit_scroll.play("scroll")

func _on_background_player_animation_finished(anim_name: StringName) -> void:
	background_player.play("background movement")

func _on_credit_scroll_animation_finished(anim_name: StringName) -> void:
	credit_scroll.play("scroll")
