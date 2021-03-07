extends Area2D

export (float) var lifetime: = 5.0 # how long fireball will last by default
export (float) var speed: = 75 # how fast does fireball travel
export (float) var shot_spread: = 0.05 # how much spread there is to each fireball
export (int) var damage = 1

onready var timer = $LifetimeTimer

var velocity:Vector2


func _ready() -> void:
	timer.set_wait_time(lifetime)
	timer.connect("timeout", self, "timeout")
	
	timer.start()
	
	connect("body_entered", self, "body_entered")
	connect("area_entered", self, "area_entered")
	
	set_as_toplevel(true) # make the scene independent from parent movement


func start(starting_position, direction):
	#global_position = starting_position + Vector2(0,-15).rotated(direction)
	direction = direction + rand_range(-shot_spread, shot_spread)
	rotation = direction + PI # adding PI to ensure sprite is in the right direction
	velocity = Vector2(speed, 0).rotated(direction)


func _physics_process(delta: float) -> void:
	global_translate(velocity * delta)


func body_entered(body: Node) -> void:
	queue_free()


func timeout() -> void:
	queue_free()


func area_entered(area: Area2D) -> void:
	queue_free()
