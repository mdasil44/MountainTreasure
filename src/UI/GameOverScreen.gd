extends CanvasLayer


onready var title = $PanelContainer/CenterContainer/VBoxContainer/GameOverTitle


func setTitle(win: bool):
	if win:
		title.text = "You Win!!"
		title.modulate = Color.green
	else:
		title.text = "You Lose!!"
		title.modulate = Color.red



func _on_Restart_pressed():
	get_tree().change_scene("res://src/Levels/World.tscn")


func _on_Quit_pressed():
	get_tree().quit()
