extends Actor

signal life_hud

var current_life = 2
var life_total = 2

var will_dig = null
var dig_timer = 1
var facing : int = -1
var charged_jump : bool = false
var damage_position : Vector2 = Vector2.ZERO

func is_big():
	return current_life > 1

func is_invulnerable():
	return not $Invulframes.is_stopped()

func add_item(element):
	print('Added element')
	$Item.add_child(element)

func is_carrying():
	return $Item.get_child_count() > 0

#=================================States========================================

func start_run():
	send_life_update()
	return "idle"

func throw_run():
	if !is_on_floor():
		return "air"
	return "idle"

func throw_enter():
	$Item.visible = false
	var position_item = $Item.global_position
	var item_to_throw = $Item.get_child(0)
	$Item.remove_child(item_to_throw)
	var throw_speed = Vector2.ONE * 150
	throw_speed.x *= facing
	item_to_throw = TemplatesLibrary.encapsulate(item_to_throw, throw_speed)
	get_parent().add_child(item_to_throw)
	item_to_throw.global_position = position_item
	SoundManager.play_FX("throwing")

func death_enter():
	$"Sprite animation".stop()
	$BigCollisionShape.disabled = true
	$SmallCollisionShape.disabled = true
	collision_mask = 0
	collision_layer = 0
	play_animation("death")
	$"Sprite/Sweat particles".emitting = true
	$"Sprite/Sweat particles".visible = true
	SoundManager.play_music("life-lost")
	
func death_run():
	pass

func idle_run():
	play_animation("idle")
	apply_gravity()
	move()
	if _velocity.y > 0:
		_velocity.y == 0
	if direction.x != 0:
		return "walk"
	if !is_on_floor():
		return "air"
	if inputs['action_jump']:
		return "jump"
	if inputs['dig'] and not is_carrying() and will_dig != null:
			return "dig"
	if is_carrying() and inputs['throw']:
		return "throw"
	if inputs['duck']:
		return "duck"
	_velocity.x = 0

func dig_enter():
	$Item.position = Vector2(0, 14)
	$Item.visible = true
	$"Sprite/Sweat particles".emitting = true
	$"Sprite/Sweat particles".visible = true
	$Dig.wait_time = 1
	will_dig.dig(self)
	$Dig.start()
	play_animation("dig")
	$"Item uprooting".play("big" if is_big() else "small")
	SoundManager.play_FX("pull-ground")

func dig_run():
	if $Dig.is_stopped():
		return "idle"

func dig_exit():
	$"Sprite/Sweat particles".emitting = false
	$"Sprite/Sweat particles".visible = false
	
func jump_run():
	play_animation("jump")
	var modifier = 1.5 if charged_jump else 1
	_velocity.y = -speed.y * modifier
	move(true)
	if !inputs["action_jump"]:
		$Jump.stop()
	if $Jump.is_stopped():
		return "air"

func jump_enter():
	$Jump.start()

func jump_exit():
	charged_jump = false

func air_run():
	play_animation("jump")
	apply_gravity()
	_velocity.x = direction.x * self.speed.x / 2
	move()
	if inputs['dig'] and is_carrying():
		return "throw"
	if is_on_floor():
		if direction.x == 0:
			return "idle"
		return "walk"

func walk_run():
	play_animation("walk")
	_velocity.x = direction.x * self.speed.x
	apply_gravity()
	move()
	if !is_on_floor():
		return "air"
	if _velocity.x == 0:
		return "idle"
	if inputs['action_jump']:
		return "jump"
	if inputs['dig']:
		if is_carrying():
			return "throw"
		if will_dig != null:
			return "dig"
	if inputs['duck']:
		return "duck"

func walk_enter():
	charged_jump = false

func duck_run():
	print("Ducking", $Charged.is_stopped())
	_velocity.x *= 0.8
	play_animation("duck")
	apply_gravity()
	move()
	if $Charged.is_stopped() and not charged_jump:
		SoundManager.play_FX("jump-charge")
		charged_jump = true
		$"Charged animation".play("charged")
	if !inputs['duck']:
		return "idle"

func duck_enter():
	if is_big():
		$BigCollisionShape.disabled = true
		$SmallCollisionShape.disabled = false
		$BigCollisionShape.visible = false
		$SmallCollisionShape.visible = true
	$Charged.start()
	
func duck_exit():
	if is_big():
		$BigCollisionShape.disabled = false
		$SmallCollisionShape.disabled = true
		$BigCollisionShape.visible = true
		$SmallCollisionShape.visible = false
	$Charged.stop()

#===============================================================================

func play_animation(state):
	var suffix = "_carry" if is_carrying() else ""
	var stateful_animation = state + suffix
	var animation = state
	if $"Sprite animation".has_animation(stateful_animation):
		animation = stateful_animation
	if $"Sprite animation".current_animation != animation:
		$"Sprite animation".play(animation)

func set_state(state_name):
	$"Alteration states".play()

var last_big : bool = true

func _physics_process(delta):
	if _velocity.x < 0:
		facing = -1
		$Sprite.flip_h = false
	if _velocity.x > 0:
		$Sprite.flip_h = true
		facing = 1
	if last_big != is_big():
		update_hitbox()
		last_big = is_big()

func update_hitbox():
	for item in $Item.get_children():
		if is_big():
			item.position = $"Item in hand big".position
		else:
			item.position = $"Item in hand small".position

func _on_Charged_animation_animation_finished(anim_name):
	if charged_jump:
		$"Charged animation".play("charged")

func send_life_update():
	emit_signal("life_hud", current_life, life_total)

func hurt(by):
	if not is_invulnerable():
		current_life -= 1
		send_life_update()
		if current_life > 0:
			SoundManager.play_FX("taking-damage")
			$Invulframes.start()
			$"Hurt animation".play("hurt")
		else:
			_fsm.change_state("death")

func _on_Hurt_animation_animation_finished(anim_name):
	if is_invulnerable():
		$"Hurt animation".play(anim_name)
