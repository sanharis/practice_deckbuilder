class_name Player
extends Node2D

@export var stats: CharacterStats : set = set_character_stats

@onready var sprite: Sprite2D = $Sprite2D
@onready var stats_ui: StatsUI = $StatsUI
@onready var status_handler: StatusHandler = %StatusHandler
@onready var modifier_handler: ModifierHandler = $ModifierHandler

var original_pos: Vector2

func _ready() -> void:
	original_pos = sprite.position
	status_handler.owner = self

func set_character_stats(value: CharacterStats) -> void:
	stats = value
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()

func update_player() -> void:
	if not stats is CharacterStats:
		return
	
	if not is_inside_tree():
		await ready
	
	sprite.texture = stats.art
	update_stats()

func update_stats() -> void:
	stats_ui.update_stats(stats)
	if stats.dodge <= 0:
		sprite.modulate = Color(1,1,1,1)

func take_damage(damage: int, which_modifier: Modifier.Type = Modifier.Type.DMG_TAKEN) -> void:
	if stats.health <= 0:
		return
	
	var modified_damage := modifier_handler.get_modified_value(damage, which_modifier)
	
	stats.take_damage(modified_damage)
	flinch()

func flinch() -> void:
	var offset : Vector2
	if sprite.position != original_pos:
		offset = sprite.position + Vector2(randi_range(-10, -15), randi_range(5, -5))
	else:
		offset = original_pos + Vector2(randi_range(-10, -15), randi_range(5, -5))
	
	var tween := create_tween()
	
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "position", offset, 0.4)
	if stats.health <= 0:
		Events.player_died.emit()
		queue_free()
	else:
		tween.tween_property(sprite, "position", original_pos, 0.2)
