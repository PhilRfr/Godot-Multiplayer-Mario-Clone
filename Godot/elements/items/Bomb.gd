extends Node2D

signal destroy

export var frame : int = 0
var ref : int = 0
const TIME_BEFORE_BLINK = 3
const TIME_BEFORE_BLOW = 6
const EXPLOSION_LASTS_FOR = 1
var extents = 4 * Vector2.ONE

var collide_with = ['player', 'ennemies', 'ground']

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Blink timer".wait_time = TIME_BEFORE_BLINK
	$"Blow timer".wait_time = TIME_BEFORE_BLOW
	$"Blink timer".start()
	$"Blow timer".start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite.frame = frame + ref * 4


func _on_Graphic_blink_timeout():
	ref += 1
	ref = (ref + 1) % 4
	if $"Graphic blink".wait_time > 0.01:
		$"Graphic blink".wait_time /= 2


func _on_Blink_timer_timeout():
	$"Graphic blink".start()


func _on_Blow_timer_timeout():
	var grandpa = get_parent().get_parent().get_parent()
	var pos = self.global_position
	TemplatesLibrary.create_explosion(grandpa, pos, EXPLOSION_LASTS_FOR)
	self.emit_signal("destroy")
	queue_free()
