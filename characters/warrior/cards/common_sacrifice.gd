extends Card

var base_damage := 2
var base_draw := 2

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var draw_effect := DrawEffect.new()
	var damage_effect := SelfDamageEffect.new()
	damage_effect.amount = base_damage
	draw_effect.amount = base_draw
	draw_effect.execute(targets)
	damage_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % base_damage

func get_updated_tooltip(player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var modified_damage := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	
	return tooltip_text % modified_damage
