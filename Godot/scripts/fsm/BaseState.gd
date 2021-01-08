extends Node2D
class_name BaseState

export var tag : String = ""

func _ready():
	tag = name.to_lower()


#################################################
# Player State Base
#################################################
func enter(actor: Actor):
	actor.play(tag)

func run(actor: Actor):
	return null

func exit(actor: Actor):
	if actor and actor.anim:
		actor.anim.clear_queue()
#################################################
