class_name RelicControl
extends Control

const RELICS_PER_PAGE := 5
const TWEEN_SCROLL_DURATION := 0.20

@export var left_button: TextureButton
@export var right_button: TextureButton

@onready var relics: HBoxContainer = %Relics
@onready var page_width = self.custom_minimum_size.x

var num_of_relics := 0
var current_page := 1
var max_page := 0
var tween: Tween

func _ready() -> void:
	left_button.pressed.connect(_on_left_pressed)
	right_button.pressed.connect(_on_right_pressed)
	
	for relic: RelicUI in relics.get_children():
		relic.free()
	
	relics.child_order_changed.connect(_on_relics_child_order_changed)
	_on_relics_child_order_changed()


func update() -> void:
	if not is_inside_tree():
		return
	
	num_of_relics = relics.get_child_count()
	max_page = ceili(num_of_relics / float(RELICS_PER_PAGE))
	
	left_button.disabled = current_page <= 1
	right_button.disabled = current_page >= max_page

func _tween_to(x_position: float) -> void:
	if tween:
		tween.kill()
	
	left_button.disabled = true
	right_button.disabled = true
	
	tween = create_tween().set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(relics, "position:x", x_position, TWEEN_SCROLL_DURATION)
	await tween.finished
	update()

func _on_left_pressed() -> void:
	if current_page > 1:
		current_page -= 1
		update()
		_tween_to(relics.position.x + page_width)

func _on_right_pressed() -> void:
	if current_page < max_page:
		current_page += 1
		update()
		_tween_to(relics.position.x - page_width)

func _on_relics_child_order_changed() -> void:
	update()
