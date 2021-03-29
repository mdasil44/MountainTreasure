extends Node2D


export var required_keys = 1
export (String) var next_scene


func _ready() -> void:
	$UILayer/FadeIn.fade_out()
	yield($UILayer/FadeIn, "fade_finished")
	$UILayer/FadeIn.hide()


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if $YSort/Player.stats.keys >= required_keys:
			$UILayer/FadeIn.show()
			$UILayer/FadeIn.fade_in()
			yield($UILayer/FadeIn, "fade_finished")
			get_tree().change_scene(next_scene)
