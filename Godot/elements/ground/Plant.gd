extends Node2D

enum ItemType{
	VEGETABLE,
	BIG_VEGETABLE,
	BOMB
}

export(ItemType) var content

func _ready():
	pass # Replace with function body.

func dig(by):
	print("I'm being dug by ", by.name)
	if content == ItemType.BOMB:
		by.add_item(TemplatesLibrary.BOMB_TEMPLATE.instance())
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.will_dig = self

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		body.will_dig = null

