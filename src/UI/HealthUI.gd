extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

const HEART_FULL = preload("res://src/UI/HeartUIFull.tscn")
const HEART_EMPTY = preload("res://src/UI/HeartUIEmpty.tscn")

onready var label = $Label

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if label != null:
		label.text = "Health = " + str(hearts)

func set_max_hearts(value):
	max_hearts = max(value, 1)
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	
	for heart in max_hearts:
		$MarginContainer/HBoxContainer.add_child(HEART_FULL.instance())
