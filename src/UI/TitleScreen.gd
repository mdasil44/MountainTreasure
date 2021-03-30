extends PanelContainer


func _ready() -> void:
	$CenterContainer/VBoxContainer/StartButton.grab_focus()


func _on_StartButton_pressed():
	get_tree().change_scene("res://src/Levels/Level1.tscn")
	queue_free()
	#visible = false


func _on_ExitButton_pressed():
	get_tree().quit()
