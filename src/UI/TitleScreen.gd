extends PanelContainer


func _ready() -> void:
	$FadeIn.show()
	$FadeIn.fade_out()
	yield($FadeIn, "fade_finished")
	$FadeIn.hide()
	
	$CenterContainer/VBoxContainer/StartButton.grab_focus()


func _on_StartButton_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()
	yield($FadeIn, "fade_finished")
	get_tree().change_scene("res://src/Levels/Level1.tscn")
	queue_free()
	#visible = false


func _on_ExitButton_pressed():
	get_tree().quit()
