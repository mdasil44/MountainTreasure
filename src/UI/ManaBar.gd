extends ProgressBar

var mana = 4 setget set_mana
var max_mana = 4 setget set_max_mana

onready var MANA_LENGTH = 8


func set_mana(value):
	mana = clamp(value, 0, max_mana)


func set_max_mana(value):
	max_mana = max(value, 1)


func _ready():
	self.max_mana = PlayerStats.max_mana
	self.mana = PlayerStats.mana
	PlayerStats.connect("mana_changed", self, "set_mana")


func _physics_process(delta: float) -> void:
	max_value = max_mana
	value = mana
