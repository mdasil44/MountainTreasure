extends Node2D


export var required_keys = 1
export (String) var next_scene


func _ready() -> void:
	$UILayer/FadeIn.show()
	$UILayer/FadeIn.fade_out()
	yield($UILayer/FadeIn, "fade_finished")
	$UILayer/FadeIn.hide()
	
	$LevelTransition/KeyRequirement/KeysRequired.text = str(required_keys)
	$LevelTransition/KeyRequirement.visible = true
	
	$LevelTransition.connect("body_entered", self, "next_level")


func next_level(body: Node) -> void:
	if body.is_in_group("player"):
		if $YSort/Player.stats.keys >= required_keys:
			$UILayer/FadeIn.show()
			$UILayer/FadeIn.fade_in()
			yield($UILayer/FadeIn, "fade_finished")
			get_tree().change_scene(next_scene)
			body.stats.set_keys(0)

