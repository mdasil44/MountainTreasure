extends PanelContainer

func _on_StartButton_pressed():
	get_tree().change_scene("res://src/Levels/World.tscn")
	


func _on_ExitButton_pressed():
	get_tree().quit()
