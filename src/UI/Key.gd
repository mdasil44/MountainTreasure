extends Node2D


enum KEY_COLOR {White = 0, Gold = 1, Silver = 2, Copper = 3, Iron = 4} 
enum KEY_TYPE {Wide = 0, Regular = 1, Small = 2, Decorative = 3, Ring = 4}

export (KEY_COLOR) var color = KEY_COLOR.Gold
export (KEY_TYPE) var type = KEY_TYPE.Regular

export (bool) var animated = true 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Key.frame = color*5 + type
	
	if animated:
		$AnimationPlayer.current_animation = "Floating"
		$KeyShadow.visible = 1
	else:
		$AnimationPlayer.current_animation = "[stop]"
		$KeyShadow.visible = 0


func _on_CollisionArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.increment_keys()
	queue_free()
