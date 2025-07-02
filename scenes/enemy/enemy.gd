class_name Enemy
extends Area2D

@export var stats: EnemyStats : set = set_enemy_stats

@onready var sprite: Sprite2D = $Sprite2D
@onready var arrow: Sprite2D = $Arrow
@onready var stats_ui: StatsUI = $StatsUI
@onready var intent_ui: IntentUI = $IntentUI
@onready var status_handler: StatusHandler = %StatusHandler
@onready var modifier_handler: ModifierHandler = $ModifierHandler
@onready var handler_container: CenterContainer = %HandlerContainer

var arrow_offset := 7
var enemy_action_picker : EnemyActionPicker
var current_action : EnemyAction : set = set_current_action
var moving := false


func set_current_action(value: EnemyAction) -> void:
	current_action = value
	update_intent()


func set_enemy_stats(value: EnemyStats) -> void:
	stats = value.create_instance()
	
	if stats.id == "boss":
		_set_boss()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		stats.stats_changed.connect(update_action)
	
	update_enemy()

func setup_ai() -> void:
	if enemy_action_picker:
		enemy_action_picker.queue_free()
	
	var new_action_picker: EnemyActionPicker = stats.ai.instantiate()
	add_child(new_action_picker)
	enemy_action_picker = new_action_picker
	enemy_action_picker.enemy = self

func update_stats() -> void:
	stats_ui.update_stats(stats)

func update_action() -> void:
	if not enemy_action_picker:
		return
	
	if not current_action:
		current_action = enemy_action_picker.get_action()
		return
	
	var new_conditional_action := enemy_action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		current_action = new_conditional_action

func update_enemy() -> void:
	if not stats is Stats:
		return
	
	if not is_inside_tree():
		await ready
	
	sprite.texture = stats.art
	arrow.position = Vector2.RIGHT * (sprite.get_rect().size.x / 2 + arrow_offset)
	setup_ai()
	update_stats()

func update_intent() -> void:
	if current_action:
		current_action.update_intent_text()
		intent_ui.update_intent(current_action.intent)

func do_turn() -> void:
	stats.block = 0
	stats.dodge = 0
	sprite.modulate = Color(1,1,1,1)
	
	if not current_action:
		return
	
	current_action.perform_action()

func take_damage(damage: int, which_modifier: Modifier.Type = Modifier.Type.DMG_TAKEN) -> void:
	if stats.health <= 0:
		return
	
	var modified_damage := modifier_handler.get_modified_value(damage, which_modifier)
	
	bonk()
	stats.take_damage(modified_damage)
	
	if stats.dodge < 1:
		sprite.modulate = Color(1,1,1,1)


func bonk() -> void:
	if moving == true:
		return
	
	if stats.dodge > 0:
		return
	
	moving = true
	var original_pos = sprite.position
	var offset: Vector2
	if stats.id == "boss":
		offset = Vector2(0, 10)
	else:
		offset = Vector2(0, 5)
	var original_scale := sprite.scale
	var bonk_scale := original_scale * Vector2(1, 0.4)
	
	var tween := create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(sprite, "scale", bonk_scale, 0.02)
	tween.tween_property(sprite, "position", original_pos + offset, 0.02)
	var timer = get_tree().create_timer(0.5)
	await timer.timeout
	tween.kill()
	if stats.health <= 0:
		die()
	else:
		tween = create_tween()
		tween.set_parallel(true)
		tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(sprite, "scale", original_scale, 0.3)
		tween.tween_property(sprite, "position", original_pos, 0.3)
		moving = false

func die() -> void:
	Events.enemy_died.emit(self)
	queue_free()

func _on_area_entered(_area: Area2D) -> void:
	arrow.show()

func _on_area_exited(_area: Area2D) -> void:
	arrow.hide()

func _set_boss() -> void:
	if not is_node_ready():
		await ready
	sprite.scale = Vector2(2,2)
	arrow_offset = 15
	stats_ui.position.y += 10
	intent_ui.position.y -= 10
	handler_container.position.y += 10
