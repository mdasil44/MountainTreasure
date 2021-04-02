extends Node2D


export var required_keys = 1
export (String) var next_scene


var potion = preload("res://src/Potions/Potion.tscn")
var key = preload("res://src/UI/KeyPickup.tscn")

var room_potions = [key, potion, potion, key, potion]

var rooms = [1, 1, 1, 1, 1, 1, 1]

onready var positions = [$YSort/Room1/Position2D, $YSort/Room2/Position2D, $YSort/Room3/Position2D, $YSort/Room4/Position2D, $YSort/Room5/Position2D, $YSort/Room6/Position2D, $YSort/Room7/Position2D]

var rng = RandomNumberGenerator.new()

var roomNodes = []
var bossRoom = []


func _ready() -> void:
	$UILayer/FadeIn.show()
	$UILayer/FadeIn.fade_out()
	yield($UILayer/FadeIn, "fade_finished")
	$UILayer/FadeIn.hide()
	
	$LevelTransition/KeyRequirement/KeysRequired.text = str(required_keys)
	
	$LevelTransition.connect("body_entered", self, "next_level")

	roomNodes = get_tree().get_nodes_in_group("Level_Rooms")
	bossRoom = get_tree().get_nodes_in_group("BossRoom")

func _physics_process(delta):
	if not bossRoom.empty() and bossRoom[0].get_child_count() == 1:
		$LevelTransition/KeyRequirement.visible = true
	
	if roomNodes.empty():
		return
	
	for i in 7:
		if roomNodes[i].get_child_count() == 1 && rooms[i] == 1:
			rooms[i] = 0
			if !room_potions.empty():
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
	if index == 6:
		var object_instance = key.instance()
		positions[index].add_child(object_instance)
	else:
		rng.randomize()
		var randomNum = rng.randi_range(0, room_potions.size() - 1)
		var object_instance = room_potions[randomNum].instance()
		room_potions.remove(randomNum)

		positions[index].add_child(object_instance)
	
	
	

