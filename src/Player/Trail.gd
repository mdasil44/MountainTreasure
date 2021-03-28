extends Node2D


var player


func _ready() -> void:
	set_as_toplevel(true) # make the scene independent from parent movement
	$Timer.connect("timeout", self, "remove_trail")


func remove_trail():
	player.trail_list.erase(self)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
