extends Node


export(int) var max_health = 1
onready var health = max_health setget set_health

export (int) var max_mana = 20
export (int) var mana_regen_rate = 2 # per second mana regeneration rate
export (float) var mana_regen_buffer = 0.5 # seconds to wait after mana use before regen
onready var mana = max_mana setget set_mana

var keys = 0 setget set_keys

signal no_health
signal health_changed(value)

signal no_mana
signal mana_changed(value)

signal keys_changed(value)

export (float) var freeze_time = 1.0
export (float) var frozen_speed_mod = 0.75
var frozen_timer = Timer.new()
var frozen = false

var mana_regen_timer = Timer.new()

var speed_mod = 1.0


func _ready() -> void:
	frozen_timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	frozen_timer.set_wait_time(freeze_time)
	frozen_timer.set_one_shot(true)
	add_child(frozen_timer)
	
	mana_regen_timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	mana_regen_timer.set_wait_time(mana_regen_buffer)
	mana_regen_timer.set_one_shot(true)
	add_child(mana_regen_timer)


func _physics_process(delta: float) -> void:
	speed_mod = update_speed_mod()
	
	if frozen_timer.get_time_left() > 0:
		frozen = true
	else:
		frozen = false
	
	#print(mana)
	if mana_regen_timer.get_time_left() <= 0:
		set_mana(mana + mana_regen_rate*delta)


func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")


func set_mana(value):
	mana = clamp(value, 0, max_mana)
	emit_signal("mana_changed", mana)
	if mana <= 0:
		emit_signal("no_mana")


func set_keys(value):
	keys = value if value >= 0 else 0
	emit_signal("keys_changed", keys)


func update_speed_mod() -> float:
	var new_mod = 1.0
	
	if frozen_timer.get_time_left() > 0:
		new_mod *= frozen_speed_mod
	
	return new_mod
