extends Card

const BERSERKER_STATUS := preload("res://status_effects/berserk.tres")


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var berserk := BERSERKER_STATUS.duplicate()
	status_effect.status = berserk
	status_effect.execute(targets)
