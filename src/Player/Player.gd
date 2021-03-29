extends KinematicBody2D

enum{
	MOVE,
	ATTACK,
	ROLL
}
var state = MOVE
export var MAX_SPEED = 100
export var ACCELERATION = 750
export var invincibility_time = 0.5
export var ROLL_SPEED = 1.2
export var fireball_mana = 5
export var detection_radius = 100
export var lockon_angle = 90 # degrees; angle at which player can lock on attack in front of them
# if enemy is within player angle +/- 0.5*lockon_angle then lock on
var motion = Vector2.ZERO
var stats = PlayerStats
var rollVector = Vector2.DOWN # we don't want roll vector to be 0

onready var animationPlayer = $AnimationPlayer # $ is access to the node in the tree
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback") # gets the node state
onready var swordHB = $HitboxAxis/SwordHitBox
onready var hurtBox = $Hurtbox
onready var FireballPos = $FireballPosition
const gameOverScreen = preload("res://src/UI/GameOverScreen.tscn")
var fireball = preload("res://src/Projectiles/Fireball_Blue.tscn")

var close_enemies = {} # empty dictionary to store nearby enemies for auto aim

const trail_scene = preload("res://src/Player/Trail.tscn")

var trail_list = []

func _ready():
	stats.connect("no_health", self, "game_over_lose")
	animationTree.active = true
	
	$TrailTimer.connect("timeout", self, "add_trail")
	
	var shape = CircleShape2D.new()
	shape.set_radius(detection_radius)
	$EnemyDetectionZone/CollisionShape2D.set_shape(shape)


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)
	
	if stats.frozen:
		modulate = Color("80deff")
	else:
		modulate = Color("ffffff")
	find_closest_enemy()


func _process(delta: float) -> void:
	# test option: press Q to quit game
	#if Input.is_key_pressed(KEY_Q):
	#	get_tree().quit()
	
	# test option: press 0 to toggle camera mode
	#if Input.is_key_pressed(KEY_0):
	#	$Camera2D.current = !$Camera2D.current
	pass


func roll_state(delta):
	motion = rollVector * MAX_SPEED * ROLL_SPEED
	hurtBox.start_invincibility(invincibility_time)
	animationState.travel("Roll")
	motion = move_and_slide(stats.speed_mod*motion)


func increment_keys():
	stats.set_keys(stats.keys + 1)


func increment_health(value):
	stats.set_health(stats.health + value)


func increment_max_health():
	stats.set_max_health(stats.max_health + 4)
	stats.set_health(stats.health + 4)


# function to move the player
func move_state(delta):
	var axis = get_input_axis()
	# if the player is not moving
	if axis == Vector2.ZERO:
		animationState.travel("Idle")
		apply_friction(ACCELERATION * delta)
	# else the player is moving, apply movement values
	else:
		rollVector = axis
		animationTree.set("parameters/Idle/blend_position", axis)
		animationTree.set("parameters/Run/blend_position", axis)
		animationTree.set("parameters/Attack/blend_position", axis)
		animationTree.set("parameters/Roll/blend_position", axis)
		animationState.travel("Run")
		apply_movement(axis * 2*ACCELERATION * delta)
	
	# continue motion, even against walls
	motion = move_and_slide(stats.speed_mod*motion)
	
	var last_axis
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("shoot"):
		shoot_fireball(axis)
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func shoot_fireball(direction):
	var curr_position = global_position
	var angle = 0
	var closest_enemy = find_closest_enemy()
	
	if closest_enemy != null:
		angle = (closest_enemy.global_position - curr_position).angle()
	else:
		angle = animationTree.get("parameters/Run/blend_position").angle()
	
	FireballPos.global_position = curr_position + Vector2(15, 0).rotated(angle)
	
	if stats.mana >= fireball_mana:
		var fireball_instance = fireball.instance()
		
		fireball_instance.start(curr_position, angle)
		FireballPos.add_child(fireball_instance)
		stats.mana -= fireball_mana
		stats.mana_regen_timer.start()


# find closest enemy for a simple auto-lock on feature when shooting fireballs
func find_closest_enemy() -> Node:
	var closest_enemy = null
	
	for enemy in close_enemies.values():
		var global_angle_to_enemy = (enemy.global_position - global_position).angle()
		var curr_angle = animationTree.get("parameters/Run/blend_position").angle()
		var angle_to_enemy = abs(short_angle_dist(curr_angle,global_angle_to_enemy))
		
		if angle_to_enemy <= (PI*lockon_angle/360):
			if closest_enemy == null:
				closest_enemy = enemy
			else:
				var enemy_dist = (enemy.global_position - global_position).length()
				var closest_enemy_dist = (closest_enemy.global_position - global_position).length()
				
				if enemy_dist < closest_enemy_dist:
					closest_enemy = enemy
	
	return closest_enemy


func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference


func attack_state(delta):
	motion = Vector2.ZERO
	animationState.travel("Attack")


func attack_anim_finished():
	state = MOVE

func roll_anim_finished():
	motion = Vector2.ZERO
	state = MOVE

func get_input_axis():
	var axis = Vector2.ZERO
	# get x and y axis of movement values. positve values means to right or down
	axis.x = Input.get_action_strength("move_right")- Input.get_action_strength("move_left")
	axis.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return axis.normalized()


func apply_friction(amount):
	# subtract our motion with a decreasing vector value in the opposite direction to slow down
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO


func apply_movement(accel):
	motion += accel
	# cap the motion speed
	motion = motion.clamped(MAX_SPEED)


func _on_Hurtbox_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		#print(area.get_parent().knockback*area.get_parent().vel)
		#var knockback_vel = clamp(area.get_parent().knockback*area.get_parent().vel,0,area.get_parent().knockback*area.get_parent().MAX_SPEED)
		#print(knockback_vel)
		area.get_parent().vel = (-area.get_parent().knockback*area.get_parent().vel).clamped(area.get_parent().MAX_SPEED*area.get_parent().knockback)
	if not hurtBox.invincible:
		stats.set_health(stats.health - area.damage)
		hurtBox.start_invincibility(invincibility_time)
		hurtBox.create_hit_effect()
		$HurtAudio.play()


func _on_EnemyDetectionZone_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		if not close_enemies.has(body):
			close_enemies[body] = body


func _on_EnemyDetectionZone_body_exited(body: Node) -> void:
	if close_enemies.has(body):
		close_enemies.erase(body)

func game_over_lose():
	queue_free()
	var gameOver = gameOverScreen.instance()
	get_parent().get_parent().add_child(gameOver)
	gameOver.setTitle(false)
	#get_tree().paused


func add_trail():
	var trail = trail_scene.instance()
	trail.player = self
	trail.position = position
	add_child(trail)
	trail_list.push_front(trail)
