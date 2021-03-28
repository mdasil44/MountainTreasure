extends Container

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

const HEART = preload("res://src/UI/Heart.tscn")

const HEART_ROW_SIZE = 8
const HEART_OFFSET = 8*2


func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)


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
		new_heart.global_position = Vector2(-16,-16)
		add_child(new_heart)


func _physics_process(delta: float) -> void:
	for heart in get_children():
		var index = heart.get_index()
		
		var x = self.rect_global_position.x + (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = self.rect_global_position.y + (index / HEART_ROW_SIZE) * HEART_OFFSET
		heart.position = Vector2(x,y)
		
		var last_heart = floor(hearts/4)
		if index > last_heart:
			heart.frame = 0
		if index == last_heart:
			heart.frame = hearts - (last_heart * 4)
		if index < last_heart:
			heart.frame = 4
