class_name ShopRelic
extends VBoxContainer

const RELIC_UI := preload("res://scenes/relic_handler/relic_ui.tscn")

@export var relic: Relic: set = set_relic

@onready var relic_container: CenterContainer = %RelicContainer
@onready var price: HBoxContainer = %Price
@onready var price_label: Label = %PriceLabel
@onready var button: Button = %Button
@onready var gold_cost := RNG.instance.randi_range(200, 400)


func update(run_stats: RunStats) -> void:
	if not relic_container or not price or not button:
		return
	
	price_label.text = str(gold_cost)
	
	if run_stats.gold >= gold_cost:
		price_label.remove_theme_color_override("font_color")
		button.disabled = false
	else:
		price_label.add_theme_color_override("font_color", Color.RED)
		button.disabled = true

func set_relic(new_relic: Relic) -> void:
	if not is_node_ready():
		await ready
	
	relic = new_relic
	
	for relic_ui: RelicUI in relic_container.get_children():
		relic_ui.queue_free()
	
	var new_relic_ui := RELIC_UI.instantiate() as RelicUI
	relic_container.add_child(new_relic_ui)
	new_relic_ui.relic = relic

func _on_button_pressed() -> void:
	Events.shop_relic_bought.emit(relic, gold_cost)
	relic_container.queue_free()
	price.queue_free()
	button.queue_free()
