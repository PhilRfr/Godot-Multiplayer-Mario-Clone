extends Actor

func start_run():
	direction.x = -1
	return "walk"

func toggle_direction(direction : float):
	$Sprite.flip_h = direction > 0
	if has_node("Mask"):
		$Mask.flip_h = direction > 0
	$"Frontal lobe".scale.x = - direction

func play_animation(animation : String):
	$Sprite.play(animation)
	if has_node("Mask"):
		$Mask.play(animation)

func walk_run():
	toggle_direction(direction.x)
	play_animation("walk")
	var left = $PlatformLeft.is_colliding()
	var right = $PlatformRight.is_colliding()
	if going_to_hit:
		direction.x = -direction.x
		going_to_hit = false
	else:
		if left != right:
			if left:
				direction.x = -1
			else:
				direction.x = 1
	_velocity.x = direction.x * self.speed.x
	apply_gravity()
	move()

var going_to_hit = false

func _physics_process(delta):
	for body in in_zone:
		if body.is_in_group('player'):
			body.hurt(self)

func _on_Head_bonker_body_entered(body):
	going_to_hit = true

var in_zone = []

func _on_PainZone_body_entered(body):
	in_zone.append(body)

func _on_PainZone_body_exited(body):
	in_zone.erase(body)
