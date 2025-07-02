class_name Stats
extends Resource

signal stats_changed

@export var max_health := 1
@export var art: Texture

var health: int : set = set_health
var block: int : set = set_block
var dodge: int : set = set_dodge

func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	stats_changed.emit()

func set_block(value: int) -> void:
	block = clampi(value, 0, 999)
	stats_changed.emit()

func set_dodge(value: int) -> void:
	dodge = value

func take_damage(damage: int) -> void:
	if damage <= 0:
		return
	
	if dodge > 0:
		dodge -= 1
		if dodge <= 0:
			stats_changed.emit()
		return
	
	var initial_damage := damage
	var final_damage := clampi(damage - block, 0, damage)
	block = clampi(block - initial_damage, 0, block)
	health -= final_damage

func heal(amount: int) -> void:
	health += amount

func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.dodge = 0
	return instance
