extends Node

onready var BOMB_TEMPLATE = preload("res://elements/items/Bomb.tscn")
onready var THROWABLE_TEMPLATE = preload("res://elements/items/ThrownItem.tscn")

onready var EXPLOSION_DOODAD = preload("res://elements/fx/Explosion.tscn")


func encapsulate(item, speed : Vector2 = Vector2.ZERO):
	var new_object = THROWABLE_TEMPLATE.instance()
	new_object.get_node("Item").add_child(item)
	new_object.initial_speed = speed
	return new_object

func create_explosion(parent : Node2D, position : Vector2, duration : float = 2.0):
	var new_item = EXPLOSION_DOODAD.instance()
	new_item.explosion_time = duration
	parent.add_child(new_item)
	new_item.global_position = position
