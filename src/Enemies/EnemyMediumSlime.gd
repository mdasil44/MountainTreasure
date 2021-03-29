extends KinematicBody2D

signal medium_boss_dead(val)

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

func _ready() -> void:
	get_node("PlayerDetectionZone/CollisionShape2D").shape.radius = detection_radius
	
	stats.health = 2
	
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
			player = playerDetZone.player
			if player != null:
				var playerDirection = (player.global_position - global_position).normalized()
				
				if stagger_timer.get_time_left() <=0:
					vel = vel.move_toward(playerDirection * MAX_SPEED, ACCELERATION * delta)
				else:
					vel = Vector2.ZERO
				
				# face the player
				if playerDirection.angle() <= -3*PI/4 or playerDirection.angle() >= 3*PI/4:
					$SlimeAnimation.animation = "move_left"
				elif playerDirection.angle() <= -PI/4:
					$SlimeAnimation.animation = "move_down"
				elif playerDirection.angle() >= PI/4:
					$SlimeAnimation.animation = "move_up"
				elif playerDirection.angle() <= 0 or playerDirection.angle() > 0:
					$SlimeAnimation.animation = "move_right"
				else:
					$SlimeAnimation.animation = "move_down"
				
				# perform action if any
				if action != null:
					var action_performed = action.call_func(player)
					
					# if the action was performed stagger the enemy (stop for a time)
					if action_performed:
						stagger_timer.start()
	vel = move_and_slide(vel)



func seek_player():
	if playerDetZone.can_see_player():
		state = CHASE


func _on_Hurtbox_area_entered(area):
	# reduce bat health by damage of sword
	print("hi")
	stats.health -= area.damage
	hurtBox.create_hit_effect()
	vel = -knockback*vel
	vel = move_and_slide(vel)
	$HitAudio.play()


func _on_Stats_no_health():
	# make bat disappear
	emit_signal("medium_boss_dead", global_position)
	
	queue_free()
	var enemyDeath = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeath)
	enemyDeath.global_position = global_position
	
	


func set_action(action):
	self.action = action

