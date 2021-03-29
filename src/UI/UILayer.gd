extends CanvasLayer


func _input(event):
	if event.is_action_pressed("PauseMenu"):
		get_tree().paused = true
		get_node("PauseMenu").show()

func _on_Quit_pressed():
	get_tree().quit()


func _on_Continue_pressed():
	get_tree().paused = false
	get_node("PauseMenu").hide()
