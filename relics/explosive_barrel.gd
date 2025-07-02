extends Relic

@export var base_damage := 2


func activate_relic(owner: RelicUI) -> void:
	var enemies := owner.get_tree().get_nodes_in_group("enemies")
	var damage_effect := DamageEffect.new()
	damage_effect.amount = base_damage
	damage_effect.execute(enemies)
	
	owner.flash()
