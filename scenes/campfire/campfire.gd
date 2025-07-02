class_name Campfire
extends Control

@export var char_stats: CharacterStats
@onready var rest: Button = %Rest

var heal_amount := 10

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_rest_pressed() -> void:
	rest.disabled = true
	char_stats.heal(heal_amount)
	animation_player.play("fade_out")

func _on_fade_out_finished() -> void:
	Events.campfire_exited.emit()
