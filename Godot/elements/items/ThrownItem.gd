extends KinematicBody2D

var item_extends : Vector2
var initial_speed : Vector2 = Vector2.ONE * 150
var velocity : Vector2
var gravity : int = ProjectSettings.get("physics/2d/default_gravity")

const collisions_bits = {
	'player' : 1,
	'ennemies' : 4,
	'ground' : 2
}

var collisions

# Called when the node enters the scene tree for the first time.
func _ready():
	var ref = $Item.get_child(0)
	if ref.has_signal("destroy"):
		ref.connect("destroy", self, "destroy")
	item_extends = ref.get("extents")
	if item_extends == null:
		item_extends = Vector2.ONE
	$CollisionShape2D.shape.extents = item_extends
	$CollisionShape2D.position.y = -item_extends.y
	$VisibilityNotifier2D.position.y = -2 * item_extends.y
	$VisibilityNotifier2D.position.x = -2 * item_extends.x
	$VisibilityNotifier2D.rect = Rect2(0, 0, 2*item_extends.x,2*item_extends.y)
	velocity = initial_speed
	collisions = ref.get("collide_with")
	if collisions:
		var collision_mask = 0
		for type in collisions:
			if type != "player":
				collision_mask += collisions_bits[type]
		self.set_collision_mask(collision_mask)

func _physics_process(delta):
	var collision = move_and_collide(delta * velocity)
	var velo = velocity.length()
	if collision:
		if "player" in collisions:
			set_collision_mask_bit(0, true)
		velocity = velocity.bounce(collision.normal).normalized() * velo * 0.8
	velocity.y += gravity


func _on_VisibilityNotifier2D_screen_exited():
	var can_despawn = true
	for item in $Item.get_children():
		if item.get("no_despawn"):
			can_despawn = false
	if can_despawn:
		destroy()

func destroy():
	print("Despawn")
	queue_free()
