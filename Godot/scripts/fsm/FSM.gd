extends Node
class_name FSM

var actor

func _init(actor):
	self.actor = actor

func execute_actor_func(func_name):
	var result = null
	if actor.has_method(func_name):
		result = funcref(actor, func_name).call_func()
	return result

var current_state = "start"

func change_state(new_state):
	execute_actor_func(current_state + "_exit")
	execute_actor_func(new_state + "_enter")
	current_state = new_state

func run_state():
	var fun_name_rn = current_state + "_run"
	var new_state = execute_actor_func(fun_name_rn)
	if new_state and new_state != current_state:
		change_state(new_state)
