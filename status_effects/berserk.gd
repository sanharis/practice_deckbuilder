class_name BerserkStatus
extends Status

const WRATH_STATUS := preload("res://status_effects/wrath.tres")

var wrath_stacks := 2


func get_tooltip() -> String:
	var stacks_per_turn := wrath_stacks * stacks
	return tooltip % stacks_per_turn

func apply_status(target: Node) -> void:
	var status_effect := StatusEffect.new()
	var wrath := WRATH_STATUS.duplicate()
	wrath.stacks = wrath_stacks * stacks
	status_effect.status = wrath
	status_effect.execute([target])
	
	status_applied.emit(self)
