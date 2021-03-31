extends "res://src/Enemies/EnemySlime.gd"

signal boss_dead(val)

func _ready() -> void:
	stats.set_health(3)
	
	var shape = CircleShape2D.new()
	shape.set_radius(detection_radius)
	$PlayerDetectionZone/CollisionShape2D.set_shape(shape)
	
	stagger_timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	stagger_timer.set_wait_time(action_stagger_time)
	stagger_timer.set_one_shot(true)
	add_child(stagger_timer)

func _physics_process(delta: float) -> void:
	pass

func _on_Stats_no_health():
	# make bat disappear
	
	emit_signal("boss_dead", global_position)
	
	queue_free()
	var enemyDeath = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeath)
	enemyDeath.global_position = global_position
	
