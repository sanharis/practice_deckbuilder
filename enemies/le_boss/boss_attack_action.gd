extends EnemyAction

const BURNOUT_CARD := preload("res://enemies/le_boss/burnout_card.tres")

@export var base_damage := 5

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var player := target as Player
	if not player:
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	var damage_effect := DamageEffect.new()
	var target_array : Array[Node] = [target]
	var modified_dmg := enemy.modifier_handler.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	
	damage_effect.amount = modified_dmg
	damage_effect.sound = sound
	
	tween.tween_property(enemy, "global_position", end, 0.3)
	tween.tween_callback(damage_effect.execute.bind(target_array))
	tween.tween_callback(player.stats.draw_pile.add_card.bind(BURNOUT_CARD.duplicate()))
	tween.tween_interval(0.2)
	tween.tween_property(enemy, "global_position", start, 0.3)
	
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)

func update_intent_text() -> void:
	var player := target as Player
	if not player:
		return
	
	var modified_dmg := enemy.modifier_handler.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	var final_dmg := player.modifier_handler.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
	intent.current_text = intent.base_text % final_dmg
