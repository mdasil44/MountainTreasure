extends Node2D


export var required_keys = 1
export (String) var next_scene


var potion = preload("res://src/Potions/Potion.tscn")

var room_potions = [potion, potion, potion, potion, potion, potion]

var rooms = [1, 1, 1, 1, 1, 1]

onready var positions = [$YSort/Room1/Position2D, $YSort/Room2/Position2D, $YSort/Room3/Position2D, $YSort/Room4/Position2D, $YSort/Room5/Position2D, $YSort/Room6/Position2D]

var rng = RandomNumberGenerator.new()

var roomNodes = []


func _ready() -> void:
	$UILayer/FadeIn.show()
	$UILayer/FadeIn.fade_out()
	yield($UILayer/FadeIn, "fade_finished")
	$UILayer/FadeIn.hide()
	
	$LevelTransition/KeyRequirement/KeysRequired.text = str(required_keys)
	$LevelTransition/KeyRequirement.visible = true
	
	$LevelTransition.connect("body_entered", self, "next_level")

	roomNodes = get_tree().get_nodes_in_group("Level1_Rooms")

func _physics_process(delta):
	if roomNodes.empty():
		return
	
	for i in 6:
		if roomNodes[i].get_child_count() == 1 && rooms[i] == 1:
			rooms[i] = 0
			spawn_potion(i)
			
	


func next_level(body: Node) -> void:
	if body.is_in_group("player"):
		if $YSort/Player.stats.keys >= required_keys:
			$UILayer/FadeIn.show()
			$UILayer/FadeIn.fade_in()
			yield($UILayer/FadeIn, "fade_finished")
			get_tree().change_scene(next_scene)
			body.stats.set_keys(0)
			
func spawn_potion(var index):
	rng.randomize()
	var randomNum = rng.randi_range(0,1)
	print(randomNum)
	var potion_instance = room_potions[index].instance()
	potion_instance.type = randomNum
	positions[index].add_child(potion_instance)
	
	
	

