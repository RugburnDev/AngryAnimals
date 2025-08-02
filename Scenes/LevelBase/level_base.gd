extends Node2D

const BIRD = preload("res://Scenes/Bird/bird.tscn")
const MAIN = preload("res://Scenes/Main/main.tscn")

@onready var spawn_marker: Marker2D = $spawn_marker


#region builtins
func _ready() -> void:
	_setup()

func _enter_tree() -> void:
	SignalHub._on_bird_died.connect(_bird_died)

func _physics_process(_delta: float) -> void:
	pass
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().change_scene_to_packed(MAIN)
#endregion

#region misc
func _setup() -> void:
	var regex = RegEx.new()
	regex.compile("\\d+$")
	print(name)
	var result = regex.search(name)
	if result:
		print(result)
		SignalHub.emit_cast_level_name(result.get_string())
	_spawn_bird()
#endregion

#region events
func _bird_died() -> void:
	_spawn_bird()
	
func _spawn_bird() -> void:
	var bird = BIRD.instantiate()
	bird.position = spawn_marker.position
	add_child(bird)
	print("bird spawned")
#endregion
