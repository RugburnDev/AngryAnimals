extends RigidBody2D

enum AnimalState {Ready, Drag, Release}

const DRAG_LIM_MIN : Vector2 = Vector2(-60,0)
const DRAG_LIM_MAX : Vector2 = Vector2(0,60)
const IMPULSE_GAIN : float = 20.0
const IMPULSE_MAX : float = 1200.0

@onready var debug_label: Label = $debug_label
@onready var arrow_sprite: Sprite2D = $ArrowSprite
@onready var stretch_sound: AudioStreamPlayer = $StretchSound
@onready var kick_sound: AudioStreamPlayer = $Kick_Sound
@onready var launch_sound: AudioStreamPlayer = $LaunchSound

var _state : AnimalState = AnimalState.Ready
var _start : Vector2 = Vector2.ZERO
var _drag_start : Vector2 = Vector2.ZERO
var _drag_vector : Vector2 = Vector2.ZERO
var _arrow_scale_x : float = 0.0

#region inputs
func _unhandled_input(event: InputEvent) -> void:
	if _state == AnimalState.Drag and event.is_action_released("drag"):
		call_deferred("_change_state", AnimalState.Release)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("drag") and _state == AnimalState.Ready:
		_change_state(AnimalState.Drag)
#endregion

#region builtins
func _ready() -> void:
	_setup()


func _physics_process(_delta: float) -> void:
	_update_state()
	_update_debug_label()
#endregions

#region misc
func _setup() -> void:
	_arrow_scale_x = arrow_sprite.scale.x
	arrow_sprite.hide()
	_start = position
#endregion

#region dragging
func _update_arrow_scale() -> void:
	var impulse_length : float = _calculate_impulse().length()
	var perc : float = clamp(impulse_length / IMPULSE_MAX, 0.0, 1.0)
	arrow_sprite.scale.x = lerp(_arrow_scale_x, 2*_arrow_scale_x, perc)
	arrow_sprite.rotation = (_start-position).angle()

func _start_dragging() -> void:
	arrow_sprite.show()
	_drag_start = get_global_mouse_position()
	
	
func _handle_dragging() -> void:
	var new_drag_vector = get_global_mouse_position() - _drag_start
	new_drag_vector = new_drag_vector.clamp(DRAG_LIM_MIN, DRAG_LIM_MAX)
	
	var diff : Vector2 = _drag_vector - new_drag_vector
	if diff.length() > 0 and not stretch_sound.playing:
		stretch_sound.play()
	
	_drag_vector = new_drag_vector	
	position = _start + _drag_vector
	_update_arrow_scale()
#endregion

#region release
func _calculate_impulse() -> Vector2:
	return -_drag_vector * IMPULSE_GAIN
	
	
func _start_release() -> void:
	arrow_sprite.hide()
	launch_sound.play()
	SignalHub.emit_on_attempt_made()
	freeze = false
	apply_central_impulse(_calculate_impulse())
#endregion

#region state
func _update_state() -> void:
	match _state:
		AnimalState.Drag:
			_handle_dragging()


func _change_state(new_state: AnimalState) -> void:
	if _state == new_state:
		return
	
	_state = new_state
	
	match _state:
		AnimalState.Drag:
			_start_dragging()
		AnimalState.Release:
			_start_release()
#endregion

#region events
func _die() -> void:
	SignalHub.emit_on_bird_died()
	print("bird died")
	queue_free()


func _score() -> void:
	print("bird scored")
	pass
#endregion

#region signals
func _on_screen_exited() -> void:
	_die()


func _on_sleeping_state_changed() -> void:
	if sleeping:
		for body in get_colliding_bodies():
			if body is Cup:
				body._die()
				call_deferred("_die")
				_score()


func _on_body_entered(_body: Node) -> void:
	if _body is Cup and kick_sound.playing == false:
		kick_sound.play()
#endregion

#region debug
func _update_debug_label() -> void:
	var ds = "ST: %s | SL: %s | FR: %s" % [AnimalState.keys()[_state], sleeping, freeze]
	ds += "\n_drag_start: %.1f, %.1f" % [_drag_start.x, _drag_start.y]
	ds += "\n_drag_vector: %.1f, %.1f" % [_drag_vector.x, _drag_vector.y]
	debug_label.text = ds
#endregion
