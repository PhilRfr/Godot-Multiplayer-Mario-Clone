extends KinematicBody2D
class_name Actor

export(bool) var is_player_controlled : bool = false
export(String) var player_prefix : String = "p1_action_"

export var speed = Vector2(150.0, 350.0)
export var gravity : int = ProjectSettings.get("physics/2d/default_gravity")
const FLOOR_NORMAL = Vector2.UP
var _velocity = Vector2.ZERO
var shorted_actions = {}
var inputs = {}
var direction : Vector2 = Vector2.ZERO
var snap_vector : Vector2 = Vector2.DOWN * 8
var _fsm : FSM = null

#===============================================================================

func init_fsm():
	_fsm = FSM.new(self)

#===============================================================================

func _ready():
	if is_player_controlled:
		for action in InputMap.get_actions():
			if action.begins_with(player_prefix):
				shorted_actions[action.substr(len(player_prefix))] = action
	init_fsm()

var current_state : String = ""

func _physics_process(delta):
	decide_inputs()
	_fsm.run_state()
	current_state = _fsm.current_state

func apply_gravity():
	self._velocity.y += gravity

func move(jump : bool = false):
	_velocity.y = clamp(_velocity.y, - 3 * speed.y, speed.y)
	var snap = Vector2.ZERO if jump else snap_vector 
	_velocity = move_and_slide_with_snap(_velocity, snap, Vector2.UP, false, 4, deg2rad(60), false)

func decide_inputs():
	if is_player_controlled:
		# Direction first
		direction.x = (
			Input.get_action_strength(shorted_actions['move_right'])
			- Input.get_action_strength(shorted_actions['move_left'])
		)
		direction.y = (
			Input.get_action_strength(shorted_actions['move_down'])
			- Input.get_action_strength(shorted_actions['move_up'])
		)
		inputs = {}
		for input in shorted_actions:
			inputs[input] = Input.is_action_pressed(shorted_actions[input])
