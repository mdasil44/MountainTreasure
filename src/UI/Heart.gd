extends Node2D


export (bool) var animated = true 


func _ready() -> void:
	if animated:
		$AnimationPlayer.current_animation = "Floating"
		$HeartShadow.visible = 1
	else:
		$AnimationPlayer.current_animation = "[stop]"
		$HeartShadow.visible = 0


func _on_CollisionArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.increment_max_health()
	queue_free()
