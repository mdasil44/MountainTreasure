extends "res://src/Enemies/EnemyBat.gd"

var count = 0

var fireball = preload("res://src/Projectiles/Fireball.tscn")
var fireball1 = preload("res://src/Projectiles/Fireball.tscn")
var fireball2 = preload("res://src/Projectiles/Fireball.tscn")

var bat1 = preload("res://src/Enemies/EnemyBat.tscn")
var bat2 = preload("res://src/Enemies/EnemyBat.tscn")

onready var BatPos = $BatPosition1
onready var BatPos1 = $BatPosition2

onready var FireballPos = $FireballPosition
onready var FireballPos1 = $FireballPosition1
onready var FireballPos2 = $FireballPosition2

export (float) var firerate: = 1.5 # how long between firing (shots per second)

var firerate_timer = Timer.new()


func _ready() -> void:
	stats.health = 5
	
	get_node("BatAnimation").modulate = Color("ddb231") # 00ffff
	
	firerate_timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	firerate_timer.set_wait_time(1/firerate)
	firerate_timer.set_one_shot(true)
	add_child(firerate_timer)
	
	set_action(funcref(self, "shoot_fireball"))


func _physics_process(delta: float) -> void:
	
	if stats.health == 3 && count == 0:
		
		count = 1
		
		var bat_instance1 = bat1.instance()
		var bat_instance2 = bat2.instance()
		
		BatPos.add_child(bat_instance1)
		BatPos1.add_child(bat_instance2)
		
	elif stats.health == 1 && count == 1:
		
		count = 2
		
		var bat_instance1 = bat1.instance()
		var bat_instance2 = bat2.instance()
		
		BatPos.add_child(bat_instance1)
		BatPos1.add_child(bat_instance2)
		


func shoot_fireball(target) -> bool:
	
	var target_position = target.global_position
	var curr_position = Vector2(global_position.x, global_position.y-15) # offset y for sprite
	var angle = (target_position - curr_position).angle()
	var angle1 = (target_position - curr_position).angle() + 0.2
	var angle2 = (target_position - curr_position).angle() - 0.2
	
	FireballPos.global_position = curr_position + Vector2(10, 0).rotated(angle)
	FireballPos1.global_position = curr_position + Vector2(10, 0).rotated(angle1)
	FireballPos2.global_position = curr_position + Vector2(10, 0).rotated(angle2)
	
	if firerate_timer.get_time_left() <= 0:
		var fireball_instance = fireball.instance()
		var fireball_instance1 = fireball1.instance()
		var fireball_instance2 = fireball2.instance()
		
		fireball_instance.start(curr_position, angle)
		fireball_instance1.start(curr_position, angle1)
		fireball_instance2.start(curr_position, angle2)
		
		FireballPos.add_child(fireball_instance)
		FireballPos1.add_child(fireball_instance1)
		FireballPos2.add_child(fireball_instance2)

		firerate_timer.start()
		
		return true
	return false
