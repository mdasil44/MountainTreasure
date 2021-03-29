extends CanvasLayer


func _input(event):
	if event.is_action_pressed("pause"):
		if !get_node("PauseMenu").visible:
			get_tree().paused = true
			get_node("PauseMenu").show()
			get_node("PauseMenu/PanelContainer/CenterContainer/VBoxContainer/Continue").grab_focus()
		else:
			get_tree().paused = false
			get_node("PauseMenu").hide()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Continue_pressed():
	get_tree().paused = false
	get_node("PauseMenu").hide()
