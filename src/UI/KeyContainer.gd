extends Container

enum KEY_COLOR {White = 0, Gold = 1, Silver = 2, Copper = 3, Iron = 4} 
enum KEY_TYPE {Wide = 0, Regular = 1, Small = 2, Decorative = 3, Ring = 4}

export (KEY_COLOR) var color = KEY_COLOR.Gold
export (KEY_TYPE) var type = KEY_TYPE.Regular

var keys = 0 setget set_keys

const KEY = preload("res://src/UI/Key.tscn")

const KEY_ROW_SIZE = 8
const KEY_OFFSET = 8*2


func set_keys(value):
	keys = value if value >= 0 else 0
	
	if keys > get_child_count():
		for key in (keys - get_child_count()):
			var new_key = KEY.instance()
			new_key.frame = color*5 + type
			new_key.global_position = Vector2(-16,-16)
			add_child(new_key)
	elif keys < get_child_count():
		for i in (get_child_count() - keys):
			get_children().back().queue_free()


func _ready():
	self.keys = PlayerStats.keys
	PlayerStats.connect("keys_changed", self, "set_keys")


func _physics_process(delta: float) -> void:
	for key in get_children():
		var index = key.get_index()
		key.frame = color*5 + type
		
		var x = self.rect_global_position.x + self.rect_size.x - (index % KEY_ROW_SIZE) * KEY_OFFSET
		var y = self.rect_global_position.y + (index / KEY_ROW_SIZE) * KEY_OFFSET
		key.global_position = Vector2(x-4,y+4)
