extends "res://src/Enemies/EnemyBat.gd"


var fireball = preload("res://src/Projectiles/Fireball.tscn")
onready var FireballPos = $FireballPosition

export (float) var firerate: = 1.0 # how long between firing (shots per second)

var firerate_timer = Timer.new()


func _ready() -> void:
	stats.max_health = 2
	get_node("BatAnimation").modulate = Color("ddb231") # 00ffff
	
	firerate_timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	firerate_timer.set_wait_time(1/firerate)
	firerate_timer.set_one_shot(true)
	add_child(firerate_timer)
	
	set_action(funcref(self, "shoot_fireball"))


func _physics_process(delta: float) -> void:
	pass


func shoot_fireball(target) -> bool:
	var target_position = target.global_position
	var curr_position = Vector2(global_position.x, global_position.y-15) # offset y for sprite
	var angle = (target_position - curr_position).angle()
	
	FireballPos.global_position = curr_position + Vector2(10, 0).rotated(angle)
	
	if firerate_timer.get_time_left() <= 0:
		var fireball_instance = fireball.instance()
		
		fireball_instance.start(curr_position, angle)
		FireballPos.add_child(fireball_instance)
		firerate_timer.start()
		
		return true
	return false
