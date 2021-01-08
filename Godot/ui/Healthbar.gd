extends VBoxContainer

onready var HEARTCONTAINER_TEMPLATE = preload("res://ui/Heart.tscn")

var current_max : int = 0
var current_life : int = 0

func update_bar(life_current : int, life_max : int):
	print("Update received")
	if life_max != current_max:
		if life_max > current_max:
			var delta = life_max - current_max
			for i in range(delta):
				add_child(HEARTCONTAINER_TEMPLATE.instance())
		else:
			var delta = current_max - life_max
			for i in range(delta):
				get_child(get_child_count() - 1).queue_free()
				yield(get_tree(), "idle_frame")
	if life_current != current_life:
		var i = 0
		for child in get_children():
			child.heart_on = i < life_current
			i += 1
	for child in get_children():
		child.update()
	current_life = life_current
	current_max = life_max
