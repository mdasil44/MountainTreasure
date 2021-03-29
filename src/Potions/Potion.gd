tool
extends Area2D

enum Potion {
	HEALTH,
	MANA
}

export(Potion) var type = Potion.HEALTH

func _process(delta):
	if Engine.editor_hint:
		if type == Potion.MANA:
			$Sprite.region_rect.position.x = 8
		else:
			$Sprite.region_rect.position.x = 0

func _ready():
	if type == Potion.MANA:
		$Sprite.region_rect.position.x = 8
	else:
		$Sprite.region_rect.position.x = 0



func _on_Potion_body_entered(body):
	queue_free()

