extends CanvasLayer


onready var title = $PanelContainer/CenterContainer/VBoxContainer/GameOverTitle


func _ready() -> void:
	$PanelContainer/CenterContainer/VBoxContainer/Restart.grab_focus()


func setTitle(win: bool):
	if win:
		title.text = "You Win!!"
		title.modulate = Color.green
	else:
		title.text = "You Lose!!"
		title.modulate = Color.red



func _on_Restart_pressed():
	PlayerStats.reset()
	$FadeIn.show()
	$FadeIn.fade_in()
	yield($FadeIn, "fade_finished")
	get_tree().change_scene("res://src/Levels/Level1.tscn")


func _on_Quit_pressed():
	get_tree().quit()
