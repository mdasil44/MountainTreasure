extends Node2D


onready var Pos1 = $Position1
onready var Pos2 = $Position2
onready var Pos3 = $Position3
onready var Pos4 = $Position4
onready var Pos5 = $Position5
onready var Pos6 = $Position6

var count = 0


var Slime1 = preload("res://src/Enemies/EnemyMediumSlime.tscn")
var Slime2 = preload("res://src/Enemies/EnemyMediumSlime.tscn")


var Slime3 = preload("res://src/Enemies/EnemySlime.tscn")
var Slime4 = preload("res://src/Enemies/EnemySlime.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	
	pass # Replace with function body.


func on_boss_dead(val):
	var slime_instance1 = Slime1.instance()
	var slime_instance2 = Slime2.instance()
	
	slime_instance1.connect("medium_boss_dead", self, "on_medium_dead")
	slime_instance2.connect("medium_boss_dead", self, "on_medium_dead")
	
	Pos1.set_global_position(val + Vector2(0,10))
	Pos2.set_global_position(val + Vector2(0,-20))
	
	Pos1.add_child(slime_instance1)
	Pos2.add_child(slime_instance2)
	
	
func on_medium_dead(val): 
	
	if count == 0:
		count = 1
		var slime_instance3 = Slime3.instance()
		var slime_instance4 = Slime4.instance()
		
		Pos3.set_global_position(val + Vector2(0,10))
		Pos4.set_global_position(val + Vector2(0,-10))
		
		Pos3.add_child(slime_instance3)
		Pos4.add_child(slime_instance4)
	else:
		var slime_instance5 = Slime3.instance()
		var slime_instance6 = Slime4.instance()
		
		Pos5.set_global_position(val + Vector2(0,10))
		Pos6.set_global_position(val + Vector2(0,-10))
		
		Pos5.add_child(slime_instance5)
		Pos6.add_child(slime_instance6)
