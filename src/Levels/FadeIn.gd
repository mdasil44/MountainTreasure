extends ColorRect


signal start_fade
signal fade_finished


func fade_in():
	$AnimationPlayer.play("Fade")


func fade_out():
	$AnimationPlayer.play_backwards("Fade")


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished")
