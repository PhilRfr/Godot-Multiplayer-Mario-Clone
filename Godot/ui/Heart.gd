extends Control

var heart_on : bool = false

func update():
	$Sprite.frame = 0 if heart_on else 1
