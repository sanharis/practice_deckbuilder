class_name Tooltip
extends PanelContainer

@export var fade_seconds := 0.2

@onready var tooltip_icon : TextureRect = %TooltipIcon
@onready var tooltip_text_label : RichTextLabel = %TooltipText

var tween: Tween
var its_visible := false


func _ready() -> void:
	Events.card_tooltip_requested.connect(show_tooltip)
	Events.tooltip_hide_requested.connect(hide_tooltip)
	modulate = Color.TRANSPARENT
	hide()

func show_tooltip(icon: Texture, text: String) -> void:
	its_visible = true
	if tween:
		tween.kill()
	
	tooltip_icon.texture = icon
	tooltip_text_label.text = text
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self, "modulate", Color.WHITE, fade_seconds)

func hide_tooltip() -> void:
	its_visible = false
	if tween:
		tween.kill()
	
	get_tree().create_timer(fade_seconds, false).timeout.connect(hide_animation)

func hide_animation() -> void:
	if not its_visible:
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_seconds)
		tween.tween_callback(hide)


func _on_mouse_entered() -> void:
	if its_visible:
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color(1,1,1,0), fade_seconds)

func _on_mouse_exited() -> void:
	if its_visible:
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color(1,1,1,1), fade_seconds)
