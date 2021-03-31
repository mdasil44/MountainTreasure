extends KinematicBody2D

const EnemyDeathEffect = preload("res://src/Effects/BatDeathAnimation.tscn")
onready var stats = $Stats
var vel = Vector2.ZERO
export var ACCELERATION = 400
export var MAX_SPEED = 50
export var FRICTION = 250
export var detection_radius = 50
export var action_stagger_time = 0.1
export var knockback = 2

var target
var hit_pos
var ray_visual = true
var laser_color = Color(1.0, 0.329, 0.298, 1.0)

enum{
	IDLE,
	WANDER,
	CHASE
}

onready var playerDetZone = $PlayerDetectionZone
onready var hurtBox = $Hurtbox
var state = CHASE
var player: Node = null
var action = null
var stagger_timer = Timer.new()

var chasing_trail = false


func _ready() -> void:
	var shape = CircleShape2D.new()
	shape.set_radius(detection_radius)
	$PlayerDetectionZone/CollisionShape2D.set_shape(shape)
	
	stagger_timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	stagger_timer.set_wait_time(action_stagger_time)
	stagger_timer.set_one_shot(true)
	add_child(stagger_timer)


func _physics_process(delta):
	match state:
		IDLE:
			vel = vel.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			if playerDetZone.player != null:
				player = playerDetZone.player
				chasing_trail = true
				
				var playerDirection = (player.global_position - global_position).normalized()
				
				if stagger_timer.get_time_left() <=0:
					vel = vel.move_toward(playerDirection * MAX_SPEED, ACCELERATION * delta)
				else:
					vel = Vector2.ZERO
				
				# face the player
				if playerDirection.x < 0:
					$BatAnimation.flip_h = true
				else:
					$BatAnimation.flip_h = false
				
				# perform action if any
				if action != null:
					var action_performed = action.call_func(player)
					
					# if the action was performed stagger the enemy (stop for a time)
					if action_performed:
						stagger_timer.start()
			elif player != null and chasing_trail:
				var look = get_node("RayCast2D")
				
				for trail in player.trail_list:
					look.cast_to = trail.global_position/2 - global_position
					look.force_raycast_update()
					
					if !look.is_colliding():
						var trailDirection = look.cast_to.normalized()
						vel = vel.move_toward(trailDirection * MAX_SPEED, ACCELERATION * delta)
						break
			if player == null:
				state = IDLE
	vel = move_and_slide(vel)


func seek_player():
	if playerDetZone.can_see_player():
		state = CHASE


func _on_Hurtbox_area_entered(area):
	# reduce bat health by damage of sword
	stats.health -= area.damage
	hurtBox.create_hit_effect()
	vel = -knockback*vel
	vel = move_and_slide(vel)
	$HitAudio.play()


func _on_Stats_no_health():
	# make bat disappear
	queue_free()
	var enemyDeath = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeath)
	enemyDeath.global_position = global_position


func set_action(action):
	self.action = action
