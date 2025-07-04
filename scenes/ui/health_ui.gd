class_name HealthUI
extends HBoxContainer

@export var show_cap: bool = false

@onready var health_label: Label = %HealthLabel
@onready var max_health_label: Label = %MaxHealthLabel


func update_stats(stats: Stats) -> void:
	health_label.text = str(stats.health)
	max_health_label.text = "/%s" % str(stats.max_health)
	max_health_label.visible = show_cap
