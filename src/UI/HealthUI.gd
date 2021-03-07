extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

const HEART_FULL = preload("res://src/UI/HeartUIFull.tscn")
const HEART_EMPTY = preload("res://src/UI/HeartUIEmpty.tscn")
const HEART = preload("res://src/UI/Heart.tscn")

const HEART_ROW_SIZE = 8
onready var HEART_OFFSET = 8

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
	
	var num_hearts: int = max_hearts/4
	if (max_hearts % 4) > 0:
		num_hearts += 1
	
	for heart in num_hearts:
		var new_heart = HEART.instance()
		HEART_OFFSET = 8*new_heart.scale.x
		$HeartContainer.add_child(new_heart)


func _physics_process(delta: float) -> void:
	for heart in $HeartContainer.get_children():
		var index = heart.get_index()
		
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = (index / HEART_ROW_SIZE) * HEART_OFFSET
		heart.position = Vector2(x,y)
		
		var last_heart = floor(hearts/4)
		if index > last_heart:
			heart.frame = 0
		if index == last_heart:
			heart.frame = hearts - (last_heart * 4)
		if index < last_heart:
			heart.frame = 4
