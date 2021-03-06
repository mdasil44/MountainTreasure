extends Node


export(int) var max_health = 1
onready var health = max_health setget set_health

signal no_health
signal health_changed(value)

export (float) var freeze_time = 1.0
export (float) var frozen_speed_mod = 0.75
var frozen_timer = Timer.new()
var frozen = false

export (float) var poison_time = 1.0
var poison_timer = Timer.new()

var speed_mod = 1.0


func _ready() -> void:
	frozen_timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	frozen_timer.set_wait_time(freeze_time)
	frozen_timer.set_one_shot(true)
	add_child(frozen_timer)
	
	poison_timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	poison_timer.set_wait_time(poison_time)
	poison_timer.set_one_shot(true)
	add_child(poison_timer)


func _physics_process(delta: float) -> void:
	speed_mod = update_speed_mod()
	
	if frozen_timer.get_time_left() > 0:
		frozen = true
	else:
		frozen = false


func set_health(value):
	health = value;
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")


func update_speed_mod() -> float:
	var new_mod = 1.0
	
	if frozen_timer.get_time_left() > 0:
		new_mod *= frozen_speed_mod
	
	return new_mod
