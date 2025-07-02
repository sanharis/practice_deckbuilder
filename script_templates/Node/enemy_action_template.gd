# meta-name: EnemyAction
# meta-description: An action which can be performed by an enemy during its turn
extends EnemyAction

var base_value : int

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	
	SfxPlayer.play(sound)
	
	Events.enemy_action_completed.emit(enemy)

func update_intent_text() -> void:
	var player := target as Player
	if not player:
		return
	
	var modified_dmg := player.modifier_handler.get_modified_value(base_value, Modifier.Type.DMG_TAKEN)
	intent.current_text = intent.base_text % modified_dmg
