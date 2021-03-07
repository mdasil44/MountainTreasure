extends "res://src/Enemies/EnemyBat.gd"


func _ready() -> void:
	stats.max_health = 1
	get_node("BatAnimation").modulate = Color("00ffff")


func _physics_process(delta: float) -> void:
	pass


func _on_Hitbox_area_entered(area: Area2D) -> void:
	area.get_parent().stats.frozen_timer.start()
	stagger_timer.start()
