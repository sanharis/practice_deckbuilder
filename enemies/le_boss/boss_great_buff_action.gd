extends EnemyAction

const WRATH_STATUS := preload("res://status_effects/wrath.tres")

@export var stacks_per_action := 5
@export var block := 15

var hp_treshold := 10
var uses := 0

func is_performable() -> bool:
	var hp_under_treshold := enemy.stats.health <= hp_treshold
	if hp_under_treshold and uses == 0:
		uses += 1
		return true
	
	return false

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var status_effect := StatusEffect.new()
	var wrath = WRATH_STATUS.duplicate()
	wrath.stacks = stacks_per_action
	status_effect.status = wrath
	status_effect.execute([enemy])
	
	var block_effect := BlockEffect.new()
	block_effect.amount = block
	block_effect.sound = sound
	block_effect.execute([enemy])
	
	get_tree().create_timer(0.5, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
