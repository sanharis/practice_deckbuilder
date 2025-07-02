class_name BattleStats
extends Resource

@export_range(0,3) var battle_tier: int
@export_range(0.0,10.0) var weight: float
@export var min_gold: int
@export var max_gold: int
@export var enemies: PackedScene

var accumulated_weight: float = 0.0


func roll_gold_reward() -> int:
	return RNG.instance.randi_range(min_gold, max_gold)
