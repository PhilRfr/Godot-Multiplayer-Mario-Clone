extends Sprite

export(int) var animation_frame :int = 0

func _process(delta):
	frame = animation_frame
	if not get_parent().is_big():
		frame += 13
